
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
