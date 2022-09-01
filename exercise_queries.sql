CREATE DATABASE exercises;

USE exercises;

CREATE TABLE employeeinfo (
	EmpID INT NOT NULL,
	EmpFname VARCHAR(20) NOT NULL,
	EmpLname VARCHAR(25) NOT NULL,
	Department VARCHAR(20) NOT NULL,
	Project VARCHAR(2) NOT NULL,
	Address VARCHAR(100) NOT NULL,
	DOB DATE NOT NULL,
	Gender CHAR(1) NOT NULL,
	PRIMARY KEY (EmpID)
);

CREATE TABLE employeeposition (
	EmpID INT NOT NULL,
    EmpPosition VARCHAR(10) NOT NULL,
	DateOfJoining DATE NOT NULL,
    Salary INT NOT NULL,
    PRIMARY KEY (EmpID),
    FOREIGN KEY (EmpID) REFERENCES employeeinfo (EmpID)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO employeeinfo
	VALUES(1, 'Sanjay', 'Mehra', 'HR', 'P1', 'Hyderabad(HYD)', '1976-01-12', 'M'),
			(2, 'Ananya', 'Mishra', 'Admin', 'P2', 'Delhi(DEL)', '1968-02-05', 'F'),
            (3, 'Rohan', 'Diwan', 'Account', 'P3', 'Mumbai(BOM)', '1980-01-01', 'M'),
            (4, 'Sonia', 'Kulkarni', 'HR', 'P1', 'Hyderabad(HYD)', '1992-02-05', 'F'),
            (5, 'Ankit', 'Kapoor', 'Admin', 'P2', 'Delhi(DEL)', '1994-03-07', 'M');
            
INSERT INTO employeeposition
	VALUES(1, 'Manager', '2022-01-05', 500000),
			(2, 'Executive', '2022-02-05', 75000),
            (3, 'Manager', '2022-05-01', 90000),
            (4, 'Lead', '2022-02-05', 85000),
            (5, 'Executive', '2022-01-05', 300000);

#Verification           
SELECT * FROM employeeinfo;
SELECT * FROM employeeposition;

#1
SELECT UPPER(EmpFname) as name FROM employeeinfo;

#2
SELECT COUNT(EmpID) FROM employeeinfo WHERE department = 'HR';

#3
SELECT CURDATE();

#4
SELECT SUBSTRING(EmpLname, 1, 4) as firstfour FROM employeeinfo;

#5
SELECT SUBSTRING_INDEX(Address, '(', 1) as placename FROM employeeinfo;

#6
CREATE TABLE newtable AS SELECT * FROM employeeinfo;
SELECT * FROM newtable;

#7
SELECT EmpID, Salary FROM employeeposition
WHERE Salary BETWEEN 50000 AND 100000;

#8
SELECT EmpFname FROM employeeinfo
WHERE EmpFname LIKE 'S%';

#9
SET @n = 4;
SELECT  * FROM employeeinfo
ORDER BY EmpID
LIMIT @n;
#This does not work, I instead used a prepared statement

PREPARE stmt FROM 'SELECT * FROM employeeposition LIMIT ?';
EXECUTE stmt USING @n;

#10
SELECT CONCAT(EmpFname, ' ', EmpLname) AS FullName
FROM employeeinfo;

#11
SELECT Count(*) FROM employeeinfo
WHERE DOB BETWEEN '1970-02-05' AND '1975-12-31';

#12
SELECT * FROM employeeinfo
ORDER BY EmpLname DESC, Department ASC;

#13
SELECT * FROM employeeinfo
WHERE EmpLname LIKE '%a' AND LENGTH(EmpLname) >= 5;

#14
SELECT * FROM employeeinfo
WHERE EmpFname != 'Sanjay' AND EmpFname != 'Sonia';

#15
SELECT * FROM employeeinfo
WHERE Address = 'Delhi(DEL)';

#16
SELECT * FROM employeeposition
WHERE EmpPosition = 'Manager';

#17
SELECT Count(EmpID), Department FROM employeeinfo
GROUP BY Department
ORDER BY Department ASC;

#18
(SELECT COUNT(EmpID) FROM employeeinfo
WHERE EmpID MOD 2 = 0)
UNION
(SELECT COUNT(EmpID) FROM employeeinfo
WHERE EmpID MOD 2 = 1);

DELETE FROM employeeinfo WHERE EmpID = 6;

#19
SELECT * FROM employeeinfo AS i 
JOIN employeeposition AS p 
ON (i.EmpID = p.EmpID)
WHERE p.DateOfJoining IS NOT NULL;

#20
(SELECT Salary
FROM employeeposition
ORDER BY Salary DESC
LIMIT 2)
UNION
(SELECT Salary FROM employeeposition
ORDER BY Salary ASC
LIMIT 2);

#21
SET @n = 3;

SELECT * FROM (
SELECT EmpID, EmpPosition, DateOfJoining, Salary, ROW_NUMBER() OVER(ORDER BY Salary DESC) rownum
FROM employeeposition) t
WHERE rownum = @n;

#22
INSERT INTO employeeinfo
	VALUES(6, 'Sanjay', 'Mehra', 'HR', 'P1', 'Hyderabad(HYD)', '1976-01-12', 'M');
    
SELECT EmpFname, Count(EmpFname), EmpLname, COUNT(EmpLname)
FROM employeeinfo
GROUP BY EmpFname, EmpLname
HAVING (COUNT(EmpFname) > 1)
AND (COUNT(EmpLname) >1);

#23
SELECT * FROM employeeinfo
ORDER BY Department;

#24
SELECT * FROM
(SELECT * FROM employeeinfo
ORDER BY EmpID DESC
LIMIT 3) as sub
ORDER BY EmpID ASC;

#25
SELECT Salary
FROM employeeposition
ORDER BY Salary DESC
LIMIT 1
OFFSET 2;

#26
(SELECT * FROM employeeinfo
ORDER BY EmpID ASC
LIMIT 1)
UNION
(SELECT * FROM employeeinfo
ORDER BY EmpID DESC
LIMIT 1);

#27
ALTER TABLE employeeinfo
ADD COLUMN email VARCHAR(30) AFTER EmpLname;

UPDATE employeeinfo
SET email = 'sanjaym@gmail.com'
WHERE EmpID = 1;

INSERT INTO employeeinfo
	VALUES(6, 'Hetsvi', 'Navnitlal', 'hetsvijanya.com', 'Engineer', 'P3', 'Ahmedabad(AMB)', '1999-04-23', 'F');

DELETE FROM employeeinfo
WHERE email NOT LIKE '%@%.%';

#28
SELECT COUNT(EmpID), Department FROM employeeinfo
GROUP BY Department
HAVING COUNT(EmpID) < 2;

#29
SELECT EmpPosition, SUM(Salary)
FROM employeeposition
GROUP BY EmpPosition;

#30
SELECT * FROM
(SELECT *, NTILE(2) OVER(ORDER BY EmpID) halftable FROM employeeinfo) AS t
WHERE halftable = 1;














