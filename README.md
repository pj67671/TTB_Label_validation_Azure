

  Because the COLA system lives in Azure it may be straightforward to
leverage Azure doument intelligence, especially if the image files already live in an Azure table 
or (even better) have the OCR text pre-extracted in a table. If not we will need a stored procedure either 
set up in Azure data factory or written manually. These can be set to ingest all new submissions so they are pre-evaluated before 
being reviewed. 
  In this case it is likely more effective to identify labels that are clearly in compliance because they do not need further 
review. This could realistically automate much of the process by simply identifying cases that do not need manual review. 

  There are other reasonable methods like using another tool for OCR but it may in fact be fastest to build this out in Azure.



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

