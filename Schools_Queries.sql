Table_Name: enrollment_24_25
countrCode	    int
countyName	    text
districtCode    int
districtName    text
schoolCode	    int
schoolName	    text
totalEnrollment	int
fifthGrade	    int
sixthGrade	    int
seventhGrade	int
eighthGrade	    int

TableName: njpubschooldistricts
city	        text
countyCode	    int
countyName	    text
districtCode	int
districtName	text
leadID          int
state	        text

TableName: title_1_schoolslist
leadID	            int
district	        text
title1Allocations	int	



select * from enrollment_24_25;
select * from njpubschooldistricts;
select * from title_1_schoolslist;

show columns from njpubschooldistricts;

Alter table njpubschooldistricts
rename column ncesId to leadId;

Update njpubschooldistricts
SET leadID =NULL
WHERE leadID REGEXP '[^0-9]';
   
UPDATE njpubschooldistricts
SET leadID = NULL
WHERE leadID = '';

Alter table njpubschooldistricts
Modify leadId int;

ALTER TABLE njpubschooldistricts
ADD PRIMARY KEY (districtCode);

CREATE INDEX idx_nj_leadid ON njpubschooldistricts (leadID);

ALTER TABLE enrollment_24_25
ADD PRIMARY KEY (districtCode, schoolCode);

ALTER TABLE title_1_schoolslist
ADD PRIMARY KEY (leadID);

SELECT
  d.countyName,
  SUM(
    COALESCE(e.fifthGrade, 0) +
    COALESCE(e.sixthGrade, 0) +
    COALESCE(e.seventhGrade, 0) +
    COALESCE(e.eighthGrade, 0)
  ) AS total_students5to8 ,e.districtName,d.leadID
FROM enrollment_24_25 e
JOIN njpubschooldistricts d
  ON d.districtCode = e.districtCode
JOIN title_1_schoolslist t
  ON t.leadID = d.leadID
GROUP BY d.countyName,e.districtName,d.leadID
ORDER BY total_students5to8 DESC;

SELECT
  d.countyName,
  d.districtCode,
  d.districtName,
  e.schoolCode,
  e.schoolName,
  (
    COALESCE(e.fifthGrade, 0) +
    COALESCE(e.sixthGrade, 0) +
    COALESCE(e.seventhGrade, 0) +
    COALESCE(e.eighthGrade, 0)
  ) AS students_5_8
FROM enrollment_24_25 e
JOIN njpubschooldistricts d
  ON d.districtCode = e.districtCode
JOIN title_1_schoolslist t
  ON t.leadID = d.leadID
ORDER BY
  d.districtName ASC,
  students_5_8 DESC;

