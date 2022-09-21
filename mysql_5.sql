USE exercises;

CREATE TABLE StudentDetails (
	StudId INT NOT NULL,
    Name VARCHAR(50) NOT NULL,
    EnrollmentNo INT NOT NULL,
    DateOfJoining DATE NOT NULL,
    PRIMARY KEY (StudId)
);

CREATE TABLE StudentStipend (
	StudId INT NOT NULL,
    Project VARCHAR(2) NOT NULL,
    Stipend INT NOT NULL,
    PRIMARY KEY (StudId),
    FOREIGN KEY (StudId) REFERENCES StudentDetails (StudId)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO StudentDetails
	VALUES (11, 'Nick Panchal', 1234567, 'Biology', '2019-01-02'),
			(21, 'Yash Panchal', 246811, 'Chemistry', '2017-03-15'),
            (31, 'Gyan Rathod', 3689245, 'Physics', '2018-05-27');
            
INSERT INTO StudentStipend
	VALUES (11, 'P1', 80000),
			(21, 'P2', 10000),
            (31, 'P1', 120000);
            
#Verification
SELECT * FROM StudentDetails;
SELECT * FROM StudentStipend;

#1 Insert a new detail
ALTER TABLE StudentDetails
ADD COLUMN Major VARCHAR(30) AFTER EnrollmentNo;

#2 Select a specific student detail
SElECT Name FROM StudentDetails;

#3 Update project detail in StudentStipend
UPDATE StudentStipend
SET Project = 'P2'
WHERE StudId = 31;

#4 Drop StudentStipend table with its structure
DROP TABLE StudentStipend;

#5 Delete only StudentDetails table data
TRUNCATE TABLE StudentDetails;

#6 Fetch Student names having a stipend greater than or equal to 50000 and less than or equal to 100000
SELECT d.Name FROM StudentDetails d
JOIN StudentStipend s ON (d.StudId = s.StudId)
WHERE s.Stipend >= 50000 AND s.Stipend <= 100000;

#7 Fetch student names and stipend records, return name even if stipend record is not present
SELECT d.Name, s.StudId, s.Project, s.Stipend
FROM StudentDetails d RIGHT JOIN StudentStipend s
ON (d.StudId = s.StudId);

#8 Fetch records from StudentDetails who have a stipend record
SELECT * FROM StudentDetails
WHERE StudId IN (
SELECT StudId FROM StudentStipend);

#9 Number of students working in project P1
SELECT COUNT(*) FROM StudentStipend
WHERE Project = 'P1';

#10 Fetch duplicate records
SELECT Name, COUNT(Name)
FROM StudentDetails
GROUP BY Name
HAVING COUNT(Name) > 1;

#11 Remove duplicates from table without using temporary table
Delete s1 FROM StudentDetails s1
INNER JOIN StudentDetails s2
WHERE
	s1.StudId > s2.StudId AND
    s1.Name = s2.Name;
    
#12 Fetch all students who have an enrollment No.
SELECT * FROM StudentDetails
WHERE EnrollmentNo IS NOT NULL;

#13 Create new table with data and structure copied from another table
CREATE TABLE newtable AS SELECT * FROM StudentDetails;
SELECT * FROM newtable;

#14 Fetch a joint record between two tables using intersect (intersect does not exist in MYSQL)
SELECT * FROM StudentDetails
WHERE StudId IN (
SELECT StudId FROM StudentStipend);

#15 Fetch records that exist in one table but not the other using minus (minus does not exist in MYSQL)
SELECT d.StudId FROM StudentDetails d
LEFT JOIN StudentStipend s USING(StudId)
WHERE s.StudId IS NULL;

#16 Fetch count of students project-wise sort by project's count in descending order
SELECT Project, COUNT(*) FROM StudentStipend
GROUP BY Project
ORDER BY COUNT(*) DESC;

#17 Create an empty table with the same structure as another table
CREATE TABLE newschema LIKE StudentStipend;
SELECT * FROM newschema;

#18 Return the current date and time
SELECT NOW();

#19 Fetch even rows
SELECT * FROM (
SELECT *, ROW_NUMBER() OVER(ORDER BY StudId) rownum
FROM StudentDetails) t
WHERE rownum MOD 2 = 0;

#20 Fetch student details who joined in 2018
SELECT * FROM StudentDetails
WHERE YEAR(DateOfJoining) = '2018';

#21 Find the nth highest stipend from the table
SET @n = 2;

SELECT Stipend FROM (
SELECT Stipend, ROW_NUMBER() OVER(ORDER BY Stipend) rownum
FROM StudentStipend) t
WHERE rownum = @n;

#22 Fetch top n records using limit
PREPARE stmt FROM 'SELECT * FROM StudentDetails LIMIT ?';
EXECUTE stmt USING @n;

#23 Fetch only the first name
SELECT SUBSTRING_INDEX(Name, ' ', 1) AS first_name
FROM StudentDetails;

#24 Fetch only odd rows
SELECT * FROM (
SELECT *, ROW_NUMBER() OVER(ORDER BY StudId) rownum
FROM StudentDetails) t
WHERE rownum MOD 2 = 1;

#25 Find the 3rd highest stipend without using top/limit
SELECT Stipend FROM (
SELECT Stipend, ROW_NUMBER() OVER(ORDER BY Stipend DESC) rownum
FROM StudentStipend) t
WHERE rownum = 3;