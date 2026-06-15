

  Because the COLA system lives in Azure it may be most straightforward to
leverage Azure doument intelligence, especially if the image files already live in an Azure table 
or (even better) have the OCR text pre-extracted in a table. If this is not the case not we will need a stored procedure in Azure data factory or written manually to extract text from the label images. These can be set up to ingest all new submissions so they are pre-evaluated before being reviewed. 

  In this case the target outcome should be manual review avoidance. Most applications are made with the intent of being easily approved and well within the rules so we expect a large share of applications, possibly 50% to be relatively easy to identify as compliant.
  
The importance of this is cost and time savings. 

  There are other reasonable methods, for example: 
   Use R or Python for OCR and statistical grouping by likelihood of approval

 
Plan Summary: Use Azure document intelligence to extract text from all labels in the COLA system as they are ingested to Azure. Include two years of recent histoy to validate sensitivity of output. 

Benefits of this approach:
Advance identification of labels that are clearly in compliance and do not need manual review generates the maximum ongoing cost savings
Inclusion of history allows the use of known rejected submissions for evaluation 
Use of Azure document intelligence avoids many complications: connecting to external APIs, many concerns related to security and operational feasibility, and potentially even cost if it is already included in our subscription.
Extracting all text and automatically evaluating all submissions leverages existing AI and big data solutions we already have

1. Create a table in Azure called TTBCOLASubmissionLabelText with a 1:1 row per row of the parent object holding the .JPG/ .TIF/TIFF labels. Match the index if this table already has a logical one like ApplicationID. 
The COLA system allows up to 10 images per submission so we use 11 columns for the text:
*/

CREATE TABLE TTBCOLASubmissionLabelText (  
	ApplicationID      bigint
	,ApplicationDate   date
	,RecordTimestamp    TIMESTAMP_NTZ
	,TextExtractImage1   varchar(500) 
	,TextExtractImage2   varchar(500)
	,TextExtractImage3   varchar(500) 
	,TextExtractImage4   varchar(500)
	,TextExtractImage5   varchar(500) 
	,TextExtractImage6   varchar(500)
	,TextExtractImage7   varchar(500) 
	,TextExtractImage8   varchar(500)
	,TextExtractImage9   varchar(500) 
	,TextExtractImage10  varchar(500)
	,AllTextCombined     varchar(5000)
	,SubmissionApprovedPreOCR VARCHAR(30)
	,SubmissionOutcome   varchar(30)
 )  
WITH
  (
    DISTRIBUTION = HASH (ApplicationID) )
/*
2. A straightforward solution to populate TTBCOLASubmissionLabelText  is to use Azure document intelligence. This avoids difficulties connecting to cloud APIs and meets the need of extracting the text from the labels. I have attached sample code at the end (code is for a different API type setup but is a good example)
3. Create a view atop the   TTBCOLASubmissionLabelText  object to verify key statutory elements are met. The view will allow testing via a query then by a reporting solution such as PowerBI. The inclusion of recent history
4. The below view will identify submissions that meet key statutory requirements:
*/
Create View TTBCOLALabelElements as 
	SELECT 
ApplicationID
,MAX( CASE WHEN   AllTextCombined like '%red wine%pink wine%rose wine%amber wine%white wine%table wine%light wine%red table wine%light white wine%sweet table wine%sherry%angelica%madeira%muscatel%port%light sherry%light angelica%light madeira%light muscatel%light port%sparkling wine%sparkling red wine%sparkling white wine%sparkling wine%sparkling red wine%%sparkling white wine%champagne%Crackling wine%petillant wine%frizzante wine%cremant% perlant%reciotto%Carbonated grape wine%carbonated wine%carbonated red wine%carbonated white wine%Fruit table wine%berry table wine%light fruit wine%light berry wine%Table wine%Dessert wine%Raisin wine%Sake%aperitif%vermouth%Fruit dessert wine%berry dessert wine%' 
THEN 1 – wine type

WHEN AllTextCombined like '%beer%malt%'  
THEN 1    – beer products 

WHEN AllTextCombined like '%whisky%cognac%brandy%rum%tequila%neutral spirits'
 THEN 1   – spirits

ELSE 0 END ) AS   IS_CLASS_TYPE 

,MAX( CASE WHEN   AllTextCombined like '%Alcohol percent by volume%percent alcohol by volume%Alcohol by volume: percent%alc/vol%percent by vol%by vol%ABV%' 
THEN 1 ELSE 0 END ) AS IS_ABV

,MAX( CASE WHEN AllTextCombined like '%AL%AK%AZ%AR%CA%CO%CT%DE%FL%
GA%HI%ID%IL%IN%IA%KS%KY%LA%ME%MD%MA%MI%MN%MS%MO%
MT%NE%NV%NH%NJ%NM%NY%NC%ND%OH%OK%OR%PA%RI%SC%SD%TN%
TX%UT%VT%VA%WA%WV%WI%WY%PR%DC%'
THEN 1 ELSE 0 END ) AS IS_ADDRESS

,MAX( CASE WHEN AllTextCombined like '%mL%L%oz% THEN 1 ELSE 0 END ) AS IS_NET_CONTENTS

,MAX( CASE WHEN AllTextCombined like '%impoted%product of% THEN 1 ELSE 0 END ) AS IS_ORIGIN

,MAX( CASE WHEN AllTextCombined like '%GOVERNMENT WARNING%' 
AND  AllTextCombined like  '%According to the Surgeon General, women should not drink alcoholic beverages during pregnancy because of the risk of birth defects%'
AND  AllTextCombined like  '%
THEN 1 ELSE 0 END ) AS IS_GOVERNMENT WARNING



, IS_CLASS_TYPE  +IS_ABV+ IS_ADDRESS+IS_NET_CONTENTS+ IS_ORIGIN+ IS_GOVERNMENT WARNING      AS LABEL_ELEMENTS_PRESENT

, IS_CLASS_TYPE  +IS_ABV+ IS_ADDRESS+IS_NET_CONTENTS+ IS_ORIGIN     AS LABEL_ELEMENTS_EXC_WARNING

, IS_GOVERNMENT WARNING  *  IS_CLASS_TYPE  * IS_ABV * IS_ADDRESS *  IS_NET_CONTENTS * IS_ORIGIN  AS IS_PASS

GROUP BY ApplicationID



/*
----- WINE LABEL 27 cfr 4.32
(a) There shall be stated on the brand label:
(1) Brand name, in accordance with § 4.33.
(2) Class, type, or other designation, in accordance with § 4.34.
(3) [Reserved]
(4) On blends consisting of American and foreign wines, if any reference is made to the presence of foreign wine, the exact percentage by volume.
(b) There shall be stated on any label affixed to the container:
(1) Name and address, in accordance with § 4.35.
(2) Net contents, in accordance with § 4.37. If the net contents is a standard of fill other than an authorized metric standard of fill as prescribed in § 4.72, the net contents statement shall appear on a label affixed to the front of the bottle.
(3) Alcohol content, in accordance with § 4.36.
(c) There shall be stated on the brand label or on a back label a statement that the product contains FD&C Yellow No. 5, where that coloring material is used in a product bottled on or after October 6, 1984.
(d) Declaration of cochineal extract or carmine. There shall be stated on a front label, back label, strip label, or neck label a statement that the product contains the color additive cochineal extract or the color additive carmine, prominently and conspicuously, using the respective common or usual name (“cochineal extract” or “carmine”), where either of the coloring materials is used in a product that is removed on or after April 16, 2013. (For example: “Contains Cochineal Extract” or “Contains Carmine” or, if applicable, “Contains Cochineal Extract and Carmine”).
(e) Declaration of sulfites. There shall be stated on a front label, back label, strip label or neck label, the statement “Contains sulfites” or “Contains (a) sulfiting agent(s)” or a statement identifying the specific sulfiting agent where sulfur dioxide or a sulfiting agent is detected at a level of 10 or more parts per million, measured as total sulfur dioxide. The provisions of this paragraph shall apply to:
(1) Any certificate of label approval issued on or after January 9, 1987;
(2) Any wine bottled on or after July 9, 1987, regardless of the date of issuance of the certificate of label approval; and,
(3) Any wine removed on or after January 9, 1988.






----------

--Code for Azure document intelligence (this is a different use case calling an API and we need an --Azure Data Factory version to populate ou table):
     // Monitor the operation until completion.
     GET /documentModels/prebuilt-read/analyzeResults/{resultId}
     200
     {...}

     // Upon successful completion, retrieve the PDF as application/pdf.
     GET {endpoint}/documentintelligence/documentModels/prebuilt-read/analyzeResults/{resultId}/pdf?api-version=2024-11-30
URI Parameters
Name    In    Required    Type    Description
endpoint    path    True    
string

uri    
The Document Intelligence service endpoint.

modelId    path    True    
string

Unique document model name.

Regex pattern: ^[a-zA-Z0-9][a-zA-Z0-9._~-]{1,63}$

resultId    path    True    
string

uuid    
Analyze operation result ID.

api-version    query    True    
string

The API version to use for this operation.

Responses
Name    Type    Description
200 OK    
file

The request has succeeded.

Media Types: "application/pdf", "application/json"

Other Status Codes    
DocumentIntelligenceErrorResponse

An unexpected error response.

Media Types: "application/pdf", "application/json"

Security
Ocp-Apim-Subscription-Key
Type: apiKey
In: header

OAuth2Auth
Type: oauth2
Flow: accessCode
Authorization URL: https://login.microsoftonline.com/common/oauth2/authorize
Token URL: https://login.microsoftonline.com/common/oauth2/token

Scopes
Name    Description
https://cognitiveservices.azure.com/.default    
Examples
Get Analyze Document Result PDF
Sample request
HTTP
HTTP

Copy
GET https://myendpoint.cognitiveservices.azure.com/documentintelligence/documentModels/prebuilt-invoice/analyzeResults/3b31320d-8bab-4f88-b19c-2322a7f11034/pdf?api-version=2024-11-30
Sample response
Status code:
200
JSON

Copy
"{pdfBinary}"
Definitions
Name    Description
DocumentIntelligenceError    
The error object.

DocumentIntelligenceErrorResponse    
Error response object.

DocumentIntelligenceInnerError    
An object containing more specific information about the error.

DocumentIntelligenceError
The error object.

Name    Type    Description
code    
string

One of a server-defined set of error codes.

details    
DocumentIntelligenceError[]

An array of details about specific errors that led to this reported error.

innererror    
DocumentIntelligenceInnerError

An object containing more specific information than the current object about the error.

message    
string

A human-readable representation of the error.

target    
string

The target of the error.

DocumentIntelligenceErrorResponse
Error response object.

Name    Type    Description
error    
DocumentIntelligenceError

Error info.

DocumentIntelligenceInnerError
An object containing more specific information about the error.

Name    Type    Description
code    
string

One of a server-defined set of error codes.

innererror    
DocumentIntelligenceInnerError

Inner error.

message    
string

A human-readable representation of the error.

In this article
URI Parameters
Responses
Security
Examples

     200 OK
     Content-Type: application/pdf
*/




Notes: 

Key requirements 
150,000 documents /year volume 
Match key words and numbers from form against label
Need results in 5 seconds 
Peak season, bulk handling
Verify
Brand name
Class/type designation
ABV (some exceptions for certain wine/beer)
Net contents
Name and address of bottler or producer
Country of origin for imports
Exact text “GOVERNMENT WARNING”


Assets
Azure architecture
COLA system stores .JPG, .JPEG, .TIF, .TIFF
Network blocks cloud APIs and ML integrations


Approach:
Identifying acceptable submissions quickly critical to efficiency 


Evaluation Criteria
Correctness and completeness of core requirements 
Code quality and organization 
Appropriate technical choices for the scope 
User experience and error handling 
Attention to requirements 
Creative problem-solving 
We understand this is time-constrained. A working core application with clean code is preferred over ambitious but incomplete features. Document any trade-offs or limitations.
Questions? Reach out for clarification—though we also value how you fill in gaps independently.
Good luck!

