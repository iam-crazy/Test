DROP PROCEDURE IF EXISTS watermanagementsystem.jobresultSelection;
CREATE PROCEDURE watermanagementsystem.`jobresultSelection`(
$SampleNumber bigint ,
$jobTitle varchar(50)
)
begin
Set @jobTitle :='';
Set @D_jobTitle :='';
SELECT Purpose   into @jobTitle
FROM watermanagementsystem.job_sampledeatils 
where SampleName=$SampleNumber;
if @D_jobTitle='Construction' then 
    Set @D_jobTitle :='Construction Purpose';
elseif @D_jobTitle='Department' then 
    Set @D_jobTitle :='Analytical Purpose'; 
elseif @D_jobTitle='Awt' then 
    Set @D_jobTitle :='Analytical Purpose'; 
else 
      Set @D_jobTitle :='Drinking Purpose'; 
 end if; 

if $jobTitle='NotDefault' then
    begin
        SET @ROW_NUMBER = 0;
        SELECT
              ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO, 
              a.Id as Id, 
              a.ParameterId as ParameterId,
              a.ChallanNo as ChallanNo,
              a.SampleNumber as SampleNumber,
              a.Parameter as Name,
              a.Result as Result,
              a.AcceptableLimit as AcceptableLimit,
              a.PermissableLimit as PermissableLimit, 
              a.JobTitle  as JobTitle 
        FROM watermanagementsystem.jobresult a 
        left join watermanagementsystem.parameters b
        on a.Id=b.Id where a.SampleNumber=$SampleNumber order by b.Id Asc;
    end;
    elseif $jobTitle='Default' then
     begin    
        SET @ROW_NUMBER = 0;
          SELECT
              ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO,
              0 as Id,  
              a.Id as ParameterId, 
              '' as ChallanNo,
              '' as SampleNumber,
              a.Name as Name, 
              '' as Result, 
              a.AcceptableLimit as AcceptableLimit,
              a.PermissableLimit as PermissableLimit, 
              '' as JobTitle 
        FROM watermanagementsystem.parameters a where   a.active  =1 and a.ParameterType =@D_jobTitle;
    end;
 END IF;
 end;

DROP PROCEDURE IF EXISTS watermanagementsystem.JOBSUMMARYSELECTION;
CREATE PROCEDURE watermanagementsystem.`JOBSUMMARYSELECTION`(
      $KEYCODE VARCHAR(20),
      $FROMDATE DATE, 
      $TODATE DATE,
      $CHALLANNO VARCHAR(100),
      $RESULT  VARCHAR(100),
      $STATUS  VARCHAR(100)
  )
BEGIN
 SET @ROW_NUMBER = 0;
      IF $KEYCODE='ALL'  THEN  
          SELECT 
              A.ID, 
             cast( A.CHALLANNO as CHAR(1000)) as CHALLANNO , 
              A.CHALLANDATE, 
              A.SAMPLETYPE, 
              B.PURPOSE, 
              C.SAMPLENAME,
              A.SAMPLECOLLECTEDON, 
              A.SAMPLESENTBY, 
              A.ADDRESS,  
              A.CREATEDBY, 
              A.CREATEDON,            
              C.STATUS, 
              C.OBSERVATION
          FROM JOB_CHALLANDETAILS A
          LEFT JOIN JOB_PURPOSEDETAILS B
          ON A.ID = B.CHALLANDETAILSID
          AND A.CHALLANNO = B.CHALLANNO
          LEFT JOIN JOB_SAMPLEDEATILS C
          ON B.PURPOSE = C.PURPOSE AND  A.CHALLANNO=C.CHALLANNO
          ORDER BY A.ID DESC ;
      ELSEIF $KEYCODE='CHALLANNOONLY'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.CHALLANNO	= $CHALLANNO
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='CHALLANNO'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.CHALLANNO	= $CHALLANNO
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='RESULT'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.RESULT	= $RESULT
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='STATUS'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.STATUS	= $STATUS
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='STATUSRESULT'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.STATUS	= $STATUS AND A.RESULT	= $RESULT
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='STATUSCHALLANNO'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.STATUS	= $STATUS AND A.CHALLANNO	= $CHALLANNO
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='STATUSDATE'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.STATUS	= $STATUS AND A.CHALLANDATE 	
 >= $FROMDATE AND A.CHALLANDATE<= $TODATE
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='RESULTDATE'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.RESULT	= $RESULT AND A.CHALLANDATE 	
 >= $FROMDATE AND A.CHALLANDATE<= $TODATE
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='RESULTCHALLANNO'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE A.RESULT	= $RESULT AND A.CHALLANNO	= $CHALLANNO
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='CHALLANNODATE'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE  A.CHALLANNO	= $CHALLANNO AND A.CHALLANDATE 	
 >= $FROMDATE AND A.CHALLANDATE<= $TODATE
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='CHALLANNORESULTSTATUS'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE  A.CHALLANNO	= $CHALLANNO AND A.RESULT	= $RESULT AND A.STATUS	= $STATUS
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='RESULTSTATUSDATE'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE  A.CHALLANDATE 	
 >= $FROMDATE AND A.CHALLANDATE<= $TODATE AND A.RESULT	= $RESULT AND A.STATUS	= $STATUS
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='CHALLANNORESULTDATE'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE  A.CHALLANDATE 	
 >= $FROMDATE AND A.CHALLANDATE<= $TODATE AND A.RESULT	= $RESULT AND A.CHALLANNO	= $CHALLANNO
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='CHALLANNOSTATUSDATE'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* 
          FROM JOBDETAILS A 
          WHERE  A.CHALLANDATE 	
 >= $FROMDATE AND A.CHALLANDATE<= $TODATE AND A.STATUS	= $STATUS AND A.CHALLANNO	= $CHALLANNO
          ORDER BY A.ID DESC;
      ELSEIF $KEYCODE='DATE'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO , A.* FROM JOBDETAILS A WHERE A.CHALLANDATE 	
 >= $FROMDATE AND A.CHALLANDATE<= $TODATE ORDER BY A.ID DESC;
      END IF;
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMSJOBDETAILSINSERTUPDATE;
CREATE PROCEDURE watermanagementsystem.`WMSJOBDETAILSINSERTUPDATE`(
$ISSAVE BIT, 
$ID BIGINT,
$CHALLANNO VARCHAR(100),
$CHALLANDATE	DATE	,
$DATEOFCOLLECTION	DATE,
$DATEOFRECEIPT	DATE	,
$SOURCEASPERLABEL	VARCHAR(1000)	,
$SAMPLESENTBY	VARCHAR(100)	,
$CREATEDBY VARCHAR(100)	,
$JOBTITLE VARCHAR(30),
$AMOUNT DECIMAL,
$STATUS  VARCHAR(100)	,
$RESULT  VARCHAR(100)	,
$REPORT  VARCHAR(2000)	,
               
OUT $OUTPUT  VARCHAR(200)
)
BEGIN
 -- DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  --
   -- SET $OUTPUT='ERROR';BEGIN
  --  ROLLBACK;
 -- END;START TRANSACTION;
   IF $ISSAVE=1 THEN
        BEGIN 
        
              INSERT INTO JOBDETAILS
                ( 
                  CHALLANNO,
                  CHALLANDATE,
                  DATEOFCOLLECTION,
                  DATEOFRECEIPT,
                  SOURCEASPERLABEL,
                  SAMPLESENTBY,
                  CREATEDBY,
                  JOBTITLE	,
                    AMOUNT,
                    STATUS,
                    RESULT,
                    REPORT
                 )
              VALUES
                (
                  $CHALLANNO,
                  $CHALLANDATE,
                  $DATEOFCOLLECTION,
                  $DATEOFRECEIPT,
                  $SOURCEASPERLABEL,
                  $SAMPLESENTBY,
                  $CREATEDBY,
                  $JOBTITLE,
                  $AMOUNT,
                  $STATUS,
                  $RESULT,
                  $REPORT
                );
         -- COMMIT;
          SET $OUTPUT=LAST_INSERT_ID();
        END;
    ELSE  
        BEGIN 
            UPDATE  JOBDETAILS SET 
                    CHALLANNO=$CHALLANNO,
                    CHALLANDATE=$CHALLANDATE,
                    DATEOFCOLLECTION=$DATEOFCOLLECTION,
                    DATEOFRECEIPT=$DATEOFRECEIPT,
                    SOURCEASPERLABEL=$SOURCEASPERLABEL,
                    SAMPLESENTBY=$SAMPLESENTBY,
                    CREATEDBY=$CREATEDBY,
                    JOBTITLE=$JOBTITLE,
                    AMOUNT =$AMOUNT,
                    STATUS =$STATUS,
                    RESULT =$RESULT,
                    REPORT =$REPORT
            WHERE ID=$ID; 
           SET $OUTPUT=$ID;
        END;
    END IF;  
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.WmsJobResultInsertUpdate;
CREATE PROCEDURE watermanagementsystem.`WmsJobResultInsertUpdate`(
$ISSAVE BIT, 
$ID BIGINT,
$SampleNumber varchar(200),
$PARAMETER	VARCHAR(500),
$RESULT	VARCHAR(100),
$ACCEPTABLELIMIT	VARCHAR(100),
$PERMISSABLELIMIT	VARCHAR(100),
$ParameterId bigint,
$ChallanNo VARCHAR(100),
OUT $OUTPUT  VARCHAR(200)
)
BEGIN
   IF $ISSAVE=1 THEN
        BEGIN 
              INSERT INTO JOBRESULT
                  (                     
                     SampleNumber,
                     Result,
                     PermissableLimit,
                     ParameterId,
                     Parameter,
                     ChallanNo,
                     AcceptableLimit
                )
              VALUES
                  (
                      $SampleNumber,                     
                      $RESULT,
                      $PERMISSABLELIMIT, 
                      $ParameterId,
                      $PARAMETER,
                      $ChallanNo,
                      $ACCEPTABLELIMIT
                      
                  );
          SET $OUTPUT=LAST_INSERT_ID();
        END;
    ELSE  
        BEGIN 
            UPDATE  JOBRESULT SET
                    PARAMETER=$PARAMETER,
                    RESULT=$RESULT,
                    ACCEPTABLELIMIT=$ACCEPTABLELIMIT,
                    PERMISSABLELIMIT=$PERMISSABLELIMIT,
                    ParameterId=$ParameterId                    
            WHERE ID=$ID and ChallanNo=$ChallanNo and SampleNumber=$SampleNumber; 
           SET $OUTPUT=$ID;
        END;
    END IF;  
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.Wms_ChallanInsertUpdate;
CREATE PROCEDURE watermanagementsystem.`Wms_ChallanInsertUpdate`(
   $ISSAVE BIT,
   $ID BIGINT,
   $CHALLANNO VARCHAR(500),
   $CHALLANDATE DATE,
   $SAMPLECOLLECTEDON DATE,
   $SAMPLESENTBY VARCHAR(100),
   $ADDRESS VARCHAR(500),
   $CREATEDBY VARCHAR(100),
   $SAMPLETYPE VARCHAR(100),
   $STATUS VARCHAR(100),
   $AREA VARCHAR(100),
   OUT $OUTPUT  VARCHAR(200)
)
BEGIN
 DECLARE ISVALID INT;
	 IF $ISSAVE=1 THEN
        BEGIN 
          SELECT COUNT(*) INTO ISVALID  FROM JOB_CHALLANDETAILS A WHERE A.CHALLANNO=$CHALLANNO;
            IF ISVALID=0 THEN
              SET @D_CHALLAN_KEY = 0;
              SET @D_CHALLAN_NO = '';
              IF $SAMPLETYPE='DEPARTMENT' THEN 
                  SELECT 
                    IFNULL(MAX(CHALLANKey),0)+1 ,
                    CONCAT('DEP', IFNULL(MAX(CHALLANKey),0)+1) 
                  INTO @D_CHALLAN_KEY , @D_CHALLAN_NO 
                  FROM JOB_CHALLANDETAILS WHERE SAMPLETYPE='DEPARTMENT';
              ELSE  
                  SELECT 
                    IFNULL(MAX(CHALLANKey),0)+1 ,
                    CONCAT('PR', IFNULL(MAX(CHALLANKey),0)+1) 
                  INTO @D_CHALLAN_KEY , @D_CHALLAN_NO 
                  FROM JOB_CHALLANDETAILS WHERE SAMPLETYPE='PRIVATE';
              END IF;
            INSERT INTO JOB_CHALLANDETAILS
                      ( 
                        SAMPLETYPE,
                        SAMPLECOLLECTEDON,
                        SAMPLESENTBY ,                       
                        CREATEDON,
                        CREATEDBY,
                        CHALLANKEY,
                        CHALLANNO,
                        CHALLANDATE,
                        ADDRESS,
                        STATUS,
                        AREA
                      )	
                  VALUES
                      (
                        $SAMPLETYPE,
                        $SAMPLECOLLECTEDON,
                        $SAMPLESENTBY,
                        NOW(),
                        $CREATEDBY,
                        @D_CHALLAN_KEY,
                        @D_CHALLAN_NO,
                        $CHALLANDATE,
                        $ADDRESS,
                        $STATUS,
                        $AREA);
                       SET $OUTPUT=CONCAT( LAST_INSERT_ID(),'-',@D_CHALLAN_NO);
            ELSE
               SET $OUTPUT='EXIST';
            END IF;
        END;
    ELSE  
        BEGIN 
          SELECT COUNT(*) INTO ISVALID  FROM JOB_CHALLANDETAILS A WHERE  A.CHALLANNO=$CHALLANNO AND ID!=$ID;
            IF ISVALID=0 THEN
              UPDATE JOB_CHALLANDETAILS SET 
                        SAMPLETYPE=$SAMPLETYPE,
                        SAMPLECOLLECTEDON= $SAMPLECOLLECTEDON,
                        SAMPLESENTBY   =$SAMPLESENTBY ,
                        MODIFIEDBY=$CREATEDBY,
                        CHALLANDATE=$CHALLANDATE,
                        ADDRESS=$ADDRESS,
                        STATUS=$STATUS,
                        AREA=$AREA
              WHERE ID=$ID AND CHALLANNO=$CHALLANNO; 
              SET $OUTPUT=CONCAT( $ID,'-',$CHALLANNO);
            ELSE
                SET $OUTPUT='EXIST';
            END IF;
        END;
    END IF;
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.Wms_ChallanPurposeInactive;
CREATE PROCEDURE watermanagementsystem.`Wms_ChallanPurposeInactive`(
   $ChallanNo VARCHAR(200)
)
BEGIN
    update job_purposedetails
        set Active=0
        where ChallanNo= $ChallanNo;
    update job_sampledeatils
        set Active=0
        where ChallanNo= $ChallanNo;
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_CHALLANPURPOSEINSERTUPDATE;
CREATE PROCEDURE watermanagementsystem.`WMS_CHALLANPURPOSEINSERTUPDATE`(
   $CHALLANNO VARCHAR(200),
   $CHALLANDETAILSID BIGINT,
   $PURPOSE VARCHAR(100),
   $PROPOSEPARAMETER VARCHAR(100),
   $NUMBEROFSAMPLE VARCHAR(5),
   $SAMPLENUMBER VARCHAR(200),
   $AMOUNT VARCHAR(100),
   $CREATEDBY VARCHAR(100),
   OUT $OUTPUT  VARCHAR(200)
)
BEGIN
    SET @D_ISSAVE =0;
    SELECT 
        COUNT(*) INTO @D_ISSAVE 
    FROM JOB_PURPOSEDETAILS A WHERE 
    A.PURPOSE=$PURPOSE AND CHALLANNO=$CHALLANNO and SAMPLENUMBER =$SAMPLENUMBER;
  IF @D_ISSAVE =0 THEN
    BEGIN    
      SET @D_SAMPLEID = 0;
      SET @D_SAMPLEKEY = '';
        SELECT 
          IFNULL(MAX(ID),0)+1 ,
          CONCAT($SAMPLEKEY, IFNULL(MAX(ID),0)+1) 
        INTO @D_SAMPLEID , @D_SAMPLEKEY 
        FROM JOB_SAMPLEDEATILS;
      INSERT INTO JOB_PURPOSEDETAILS
      ( 
        PURPOSEPARAMETER,
        PURPOSE,
        NUMBEROFSAMPLE,
        CREATEDON,
        CREATEDBY,
        CHALLANNO,
        CHALLANDETAILSID,
        AMOUNT,
        SAMPLENUMBER,
        ACTIVE
      )	
      VALUES
      (
        $PROPOSEPARAMETER,
        $PURPOSE,
        $NUMBEROFSAMPLE,
        NOW(),
        $CREATEDBY,
        $CHALLANNO,
        $CHALLANDETAILSID,
        $AMOUNT,
        $SAMPLENUMBER,
        1
        );
        SET $OUTPUT=LAST_INSERT_ID();
    END;
  ELSE 
    BEGIN
      UPDATE JOB_PURPOSEDETAILS 
      SET AMOUNT=$AMOUNT,
          NUMBEROFSAMPLE  =$NUMBEROFSAMPLE,
          ACTIVE=1
      WHERE CHALLANNO=$CHALLANNO AND PURPOSE =$PURPOSE and SAMPLENUMBER=$SAMPLENUMBER;
      SET $OUTPUT=1;
    END; 
  END IF;
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.Wms_ChallanPurposeSelection;
CREATE PROCEDURE watermanagementsystem.`Wms_ChallanPurposeSelection`(
    $KeyCode varchar(100),
    $ProposeType varchar(100),
    $ChallanNo varchar(200)
  )
BEGIN
  if $KeyCode='ChallanNo' then
	   SELECT A.* FROM job_purposedetails A WHERE A.ChallanNo=$ChallanNo and a.active=1;
  elseif $KeyCode='SampleNo' then
	   SELECT SampleNo,concat(SampleNo,'-',PurposeParameter) as SampleName FROM job_purposedetails A WHERE A.ChallanNo=$ChallanNo and a.Active=1;
  else 
    SELECT A.* FROM job_purposedetails A WHERE A.ChallanNo=$ChallanNo and a.Purpose=$ProposeType and a.active=1; 
  end if;
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_ChallanResult_Selection;
CREATE PROCEDURE watermanagementsystem.`WMS_ChallanResult_Selection`(
$KeyCode varchar(100),
$SampleNumber varchar(500)
)
begin
  if ($KeyCode ='SampleNumber') then
    select * from job_purposedetails where SampleNo=$SampleNumber;
  elseif ($KeyCode ='Result') then
   SET @ROW_NUMBER = 0;
        SELECT
              ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO, 
              a.Id as Id, 
              a.ParameterId as ParameterId,
              a.ChallanNo as ChallanNo,
              a.SampleNumber as SampleNumber,
              a.Parameter as Parameter,
              a.Result as Result,
              a.AcceptableLimit as AcceptableLimit,
              a.PermissableLimit as PermissableLimit, 
              a.JobTitle  as JobTitle 
        FROM watermanagementsystem.jobresult a 
        left join watermanagementsystem.parameters b
        on a.Id=b.Id where a.SampleNumber=$SampleNumber order by b.Id Asc;
  else
   begin    
        SET @ROW_NUMBER = 0;
          SELECT
              ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO,
              0 as Id,  
              a.Id as ParameterId, 
              '' as ChallanNo,
              '' as SampleNumber,
              a.Name as Parameter, 
              '' as Result, 
              a.AcceptableLimit as AcceptableLimit,
              a.PermissableLimit as PermissableLimit, 
              '' as JobTitle 
        FROM watermanagementsystem.parameters a where   a.active  =1 and a.ParameterType =$SampleNumber;
    end;
  end if;
end;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_CHALLAN_SUMMARY;
CREATE PROCEDURE watermanagementsystem.`WMS_CHALLAN_SUMMARY`( $KEYCODE VARCHAR(100),
$CHALLAN_FROM_DATE DATE, 
$CHALLAN_TO_DATE DATE, 
$CHALLAN_FROM_NO VARCHAR(100), 
$CHALLAN_TO_NO VARCHAR(100), 
$SAMPLE_FROM_NO VARCHAR(100), 
$SAMPLE_TO_NO VARCHAR(100), 
$OBSERVATION VARCHAR(100), 
$STATUS  VARCHAR(100), 
$SAMPLE_TYPE  VARCHAR(100) )
BEGIN 
  SET @FILTER:=''; 
    IF $KEYCODE ='ALL' THEN 
      SELECT CONCAT(' ORDER BY A.ID DESC') 
      INTO   @FILTER ; 

    ELSEIF $KEYCODE ='CHALLANNO' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO,'  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,'  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO' THEN 
      SELECT CONCAT(' WHERE  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='STATUS' THEN 
      SELECT CONCAT(' WHERE  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC') 
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC') 
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC') 
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,'  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_STATUS' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_STATUS' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO_STATUS' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO_STATUS_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO_STATUS_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_CHALLANDATE_SAMPLENO_STATUS_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO_STATUS' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO_STATUS_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO_STATUS_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO_STATUS_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLENO_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_STATUS_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_STATUS_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.STATUS="', $STATUS,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_STATUS_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANNO_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.CHALLANNO   >=', $CHALLAN_FROM_NO,' AND A.CHALLANNO<=', $CHALLAN_TO_NO, ' AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_STATUS' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO_STATUS' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO_STATUS_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO_STATUS_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO_STATUS_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='CHALLANDATE_SAMPLENO_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE A.CHALLANDATE   >=', $CHALLAN_FROM_DATE,' AND A.CHALLANDATE<=', $CHALLAN_TO_DATE,' AND  B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO_STATUS' THEN 
      SELECT CONCAT(' WHERE B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO_STATUS_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,'  AND  B.STATUS="', $STATUS,'" AND  A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO_STATUS_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE (B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,')  AND  B.STATUS="', $STATUS,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO_STATUS_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE (B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,')  AND  B.STATUS="', $STATUS,'" AND  A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLENO_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE (B.SampleId   >=', $SAMPLE_FROM_NO,' AND B.SampleId <=', $SAMPLE_TO_NO,')  AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='STATUS_SAMPLETYPE' THEN 
      SELECT CONCAT(' WHERE  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'"  ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='STATUS_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  B.STATUS="', $STATUS,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='STATUS_SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  B.STATUS="', $STATUS,'" AND A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    ELSEIF $KEYCODE ='SAMPLETYPE_OBSERVATION' THEN 
      SELECT CONCAT(' WHERE  A.SAMPLETYPE="', $SAMPLE_TYPE,'" AND B.OBSERVATION="', $OBSERVATION,'"   ORDER BY A.ID DESC')
      INTO   @FILTER; 

    END IF;

    SET @ROW_NUMBER = 0;
    SET @QUERY='SELECT A.ID,CAST(A.CHALLANNO AS CHAR(1000)) AS CHALLANNO,A.CHALLANDATE,A.SAMPLETYPE,B.PURPOSE,B.SAMPLEno as SampleName,A.SAMPLECOLLECTEDON,A.SAMPLESENTBY,A.ADDRESS,A.CREATEDBY,A.CREATEDON,B.STATUS,A.STATUS as ChallanStatus,B.OBSERVATION FROM JOB_CHALLANDETAILS A LEFT JOIN JOB_PURPOSEDETAILS B ON A.ID = B.CHALLANDETAILSID AND A.CHALLANNO = B.CHALLANNO';
    SET @SQL:=CONCAT('select ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO ,m.* from ( ',@QUERY,@FILTER,' ) m');
    PREPARE DYNAMIC_STATEMENT FROM @SQL;
    EXECUTE DYNAMIC_STATEMENT;
    DEALLOCATE PREPARE DYNAMIC_STATEMENT;
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_Parameter_Selection;
CREATE PROCEDURE watermanagementsystem.`WMS_Parameter_Selection`(
      $KEYCODE VARCHAR(20),
      $ID BIGINT 
  )
BEGIN
 SET @ROW_NUMBER = 0;
      IF $KEYCODE='EDIT'  THEN  
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SerialNo , A.* FROM PARAMETERS A WHERE A.ID=$ID; 
        ELSEIF  $Keycode='All'then
          SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SerialNo , A.* FROM PARAMETERS A where a.Name!='' order by a.id desc;
      else
       SELECT ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SerialNo , A.* FROM PARAMETERS A where a.Name!='' and a.ParameterType=$Keycode order by a.id desc;
    END IF;
   END;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_Parameter_transaction;
CREATE PROCEDURE watermanagementsystem.`WMS_Parameter_transaction`( 
   $ISSAVE BIT,
   $ID BIGINT,
   $NAME VARCHAR(200),
   $ACCEPTABLELIMIT VARCHAR(100),
   $PERMISSABLELIMIT VARCHAR(100),
   $CREATEDBY VARCHAR(200),
   $PARAMETERTYPE VARCHAR(100),
   $ACTIVE bit,
   OUT $OUTPUT  VARCHAR(200)
  )
BEGIN
 DECLARE IsValid int;
    IF $ISSAVE=1 THEN
        BEGIN 
          select count(*) into IsValid  from parameters a where a.NAME=$NAME and a.ParameterType=$PARAMETERTYPE;
            IF IsValid=0 THEN
             INSERT INTO PARAMETERS
                      (NAME,ACCEPTABLELIMIT,PERMISSABLELIMIT,CREATEDBY,CREATEDON,ParameterType,ACTIVE)	

                  VALUES
                      ($NAME,$ACCEPTABLELIMIT,$PERMISSABLELIMIT,$CREATEDBY,NOW(),$PARAMETERTYPE,$ACTIVE);
                       SET $OUTPUT='PARAMETES INSERTED SUCCESSFULLY';
            ELSE
               SET $OUTPUT='EXIST';
            END IF;
        END;
    ELSE  
        BEGIN 
          select count(*) into IsValid  from parameters a where a.NAME=$NAME and a.ParameterType=$PARAMETERTYPE AND ID!=$ID;
            IF IsValid=0 THEN
              UPDATE PARAMETERS SET 
                      NAME=$NAME,
                      ACCEPTABLELIMIT=$ACCEPTABLELIMIT,
                      PERMISSABLELIMIT=$PERMISSABLELIMIT,
                      MODIFIEDBY=$CREATEDBY,
                      ParameterType=$PARAMETERTYPE,
                      ACTIVE=$ACTIVE
              WHERE ID=$ID; 
              SET $OUTPUT='PARAMETES UPDATED SUCCESSFULLY';
            ELSE
                SET $OUTPUT='EXIST';
            END IF;
        END;
    END IF;
  END;

DROP PROCEDURE IF EXISTS watermanagementsystem.Wms_PrintJobSummary;
CREATE PROCEDURE watermanagementsystem.`Wms_PrintJobSummary`(
$SampleNumber varchar(100)
)
begin
select 
a.ChallanNo,
a.ChallanDate, 
a.SampleSentBy as SampleDrawnBy,
a.Address,
c.SampleName  as SampleNumber,
a.SampleType as Scheme,
b.PurposeParameter as Source , 
'' as Location,
c.Report , 
c.Observation as Result,
'' as TestCommandedOn,
'' as TestCompleterdOn
from job_challandetails a
left join job_purposedetails b
on a.ChallanNo = b.ChallanNo
left join job_sampledeatils c
on
c.ChallanNo =a.ChallanNo
where c.SampleName =$SampleNumber
and c.Active = 1
and b.Active = 1;
end;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_PurposeAndSampleInsertUpdate;
CREATE PROCEDURE watermanagementsystem.`WMS_PurposeAndSampleInsertUpdate`(
 $ID bigint,
 $ISSAVE bit,
 $CHALLANNO VARCHAR(200),
 $CHALLANDETAILSID BIGINT,
 $PURPOSE VARCHAR(100),
 $PROPOSEPARAMETER VARCHAR(100),
 $NUMBEROFSAMPLE VARCHAR(5),
 $SampleNo VARCHAR(200),
 $SAMPLEKEY VARCHAR(200),
 $AMOUNT VARCHAR(100),
 $CREATEDBY VARCHAR(100),
 OUT $OUTPUT  VARCHAR(200)
)
begin
  IF $ISSAVE =1 THEN
    BEGIN    
      SET @D_SAMPLEID = 0;
      SET @D_SAMPLEKEY = '';
        SELECT 
          IFNULL(MAX(SampleId),0)+1 ,
          CONCAT($SAMPLEKEY, IFNULL(MAX(SampleId),0)+1) 
        INTO @D_SAMPLEID , @D_SAMPLEKEY 
        FROM JOB_PURPOSEDETAILS;
      INSERT INTO JOB_PURPOSEDETAILS
      ( 
        PURPOSEPARAMETER,
        PURPOSE,
        NUMBEROFSAMPLE,
        CREATEDON,
        CREATEDBY,
        CHALLANNO,
        CHALLANDETAILSID,
        AMOUNT,
        SAMPLEID,
        SAMPLENo,
        ACTIVE
      )	
      VALUES
      (
        $PROPOSEPARAMETER,
        $PURPOSE,
        $NUMBEROFSAMPLE,
        NOW(),
        $CREATEDBY,
        $CHALLANNO,
        $CHALLANDETAILSID,
        $AMOUNT,
        @D_SAMPLEID,
        @D_SAMPLEKEY,
        1
        );
        SET $OUTPUT=LAST_INSERT_ID();
    END;
    else 
      update JOB_PURPOSEDETAILS set PURPOSE= $PURPOSE,PROPOSEPARAMETER=$PROPOSEPARAMETER
      where id=$id;
       SET $OUTPUT=$id;
  end if;
end;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_Report_ChallanResult;
CREATE PROCEDURE watermanagementsystem.`WMS_Report_ChallanResult`(
$KeyCode varchar(50),
$SampleNumber varchar(100)
)
begin
  if  $KeyCode='result' then
    begin 
        SET @ROW_NUMBER = 0;
        SELECT
              ( @ROW_NUMBER := @ROW_NUMBER + 1) AS SERIALNO, 
              a.Id as Id, 
              a.ParameterId as ParameterId,
              a.ChallanNo as ChallanNo,
              a.SampleNumber as SampleNumber,
              a.Parameter as Parameter,
              a.Result as Result,
              a.AcceptableLimit as AcceptableLimit,
              a.PermissableLimit as PermissableLimit, 
              a.JobTitle  as JobTitle 
        FROM watermanagementsystem.jobresult a 
        left join watermanagementsystem.parameters b
        on a.Id=b.Id where a.SampleNumber=$SampleNumber;
    end;
  else 
      begin
        SELECT A.ID,CAST(A.CHALLANNO AS CHAR(1000)) AS CHALLANNO,A.CHALLANDATE,A.SAMPLETYPE,B.PURPOSE,C.SAMPLENAME,A.SAMPLECOLLECTEDON,A.SAMPLESENTBY,A.ADDRESS,A.CREATEDBY,A.CREATEDON,C.STATUS,A.STATUS as ChallanStatus,C.OBSERVATION FROM JOB_CHALLANDETAILS A LEFT JOIN JOB_PURPOSEDETAILS B ON A.ID = B.CHALLANDETAILSID AND A.CHALLANNO = B.CHALLANNO LEFT JOIN JOB_SAMPLEDEATILS C ON B.PURPOSE = C.PURPOSE AND  A.CHALLANNO=C.CHALLANNO where C.sampleName=$SampleNumber;
      end; 
  end if;
end;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_SampleInsertUpdate;
CREATE PROCEDURE watermanagementsystem.`WMS_SampleInsertUpdate`(
$ISSAVE	bit,
$ID	bigint,
$SAMPLEKEY	VARCHAR(100),
$CHALLANNO VARCHAR(100),
$PURPOSE	VARCHAR(100)
)
BEGIN
  BEGIN   
    IF $ISSAVE=0 THEN 
      SET @D_SAMPLEID = 0;
      SET @D_SAMPLEKEY = '';
        SELECT 
          IFNULL(MAX(ID),0)+1 ,
          CONCAT($SAMPLEKEY, IFNULL(MAX(ID),0)+1) 
        INTO @D_SAMPLEID , @D_SAMPLEKEY 
        FROM JOB_SAMPLEDEATILS;
       INSERT INTO JOB_SAMPLEDEATILS 
        (
          PURPOSE,
          SAMPLEID,
          SAMPLENAME,
          STATUS,
          CHALLANNO,
          ACTIVE 
        )
        VALUES
        (
          $PURPOSE,
          @D_SAMPLEID,
          @D_SAMPLEKEY,
          'NEW',
          $CHALLANNO,
          1
        );
    ELSE
      UPDATE JOB_SAMPLEDEATILS 
      SET ACTIVE =1 
      WHERE PURPOSE=$PURPOSE AND CHALLANNO =$CHALLANNO;
    END IF;
  END; 
  
END;

DROP PROCEDURE IF EXISTS watermanagementsystem.WMS_SampleUpdate;
CREATE PROCEDURE watermanagementsystem.`WMS_SampleUpdate`(
$SAMPLEKEY	VARCHAR(100),
$CHALLANNAME VARCHAR(100),
$Report 	VARCHAR(1000),
$Observation 	VARCHAR(100),
$Status 	VARCHAR(100),
$TestCommandedOn Date,               
OUT $OUTPUT  VARCHAR(200)
)
BEGIN   
       UPDATE job_purposedetails
       set Status=$Status,Report=$Report,Observation=$Observation,TestCommandedOn=$TestCommandedOn
       where ChallanNo=$CHALLANNAME and SampleNo=$SAMPLEKEY;
END;

