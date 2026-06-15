Create View TTBCOLALabelElements_view as 
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


