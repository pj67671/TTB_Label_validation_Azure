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
