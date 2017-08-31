DROP PROCEDURE IF EXISTS watermanagementsystem.Wms_PrintJobSummary;
CREATE PROCEDURE watermanagementsystem.`Wms_PrintJobSummary`(
$SampleNumber varchar(100),
$keyCode varchar(100)
)
begin
if $keyCode='SampleNumber' then
    select 
    a.ChallanNo,
    a.ChallanDate , 
    concat(a.SampleSentBy,'/',DATE_FORMAT(a.SampleCollectedOn, "%d-%m-%Y") ) as SampleDrawnBy,
    concat(a.SampleSentBy,a.Address) as Address,
    B.SampleNo  as SampleNumber,
    a.SampleType as Scheme,
    b.Purpose as Purpose,
    b.PurposeParameter as Source ,     
    b.Location as Location,
    B.Report , 
    B.Observation as Result,
    concat(B.TestCommandedOn,'/',DATE_FORMAT(a.SampleCollectedOn, "%d-%m-%Y") ) as TestCommandedOn,
    '' as TestCompleterdOn
    from job_challandetails a
    left join job_purposedetails b
    on a.ChallanNo = b.ChallanNo

    where B.SampleNo =$SampleNumber
    and B.Active = 1
    and b.Active = 1;
 elseif $keyCode='SampleDetails' then
    select 
    DATE_FORMAT(a.SampleCollectedOn, "%d-%m-%Y") as Scheme,
    b.Purpose as Source ,
    concat(a.SampleSentBy ) as SampleDrawnBy,
    concat(a.SampleSentBy,' ',a.Address) as Address,
    a.ChallanNo,
    a.ChallanDate , 
    B.SampleNo  as SampleNumber,
    b.Location as Location, 
    concat(B.Amount) as Result
    from job_challandetails a
    left join job_purposedetails b
    on a.ChallanNo = b.ChallanNo
    where B.SampleNo =$SampleNumber
    and B.Active = 1
    and b.Active = 1;
 else 
   SELECT * FROM (select   
    a.ChallanNo,
    a.ChallanDate , 
    concat(a.SampleSentBy,'/',DATE_FORMAT(a.SampleCollectedOn, "%d-%m-%Y") ) as SampleDrawnBy,
    concat(a.SampleSentBy,a.Address) as Address,
    B.SampleNo  as SampleNumber,
    a.SampleType as Scheme,
    b.Purpose as Purpose,
    b.PurposeParameter as Source , 
    b.Location as Location,
    B.Report , 
    B.Observation as Result,
    concat(B.TestCommandedOn,'/',DATE_FORMAT(a.SampleCollectedOn, "%d-%m-%Y") ) as TestCommandedOn,
    '' as TestCompleterdOn
    from job_challandetails a
    left join job_purposedetails b
    on a.ChallanNo = b.ChallanNo

    where B.ChallanNo =$SampleNumber
    and B.Active = 1
    and b.Active = 1) as end_time LIMIT 1;
   end if;
end;
