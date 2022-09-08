USE exercises;

CREATE TABLE EmployeeDetails (
	EmpId INT NOT NULL,
    FullName VARCHAR(30) NOT NULL,
    ManagerId INT NOT NULL,
    DateOfJoining DATE NOT NULL,
    City VARCHAR(30) NOT NULL,
    PRIMARY KEY (EmpId)
);

CREATE TABLE EmployeeSalary (
	EmpId INT NOT NULL,
    Project VARCHAR(2) NOT NULL,
    Salary INT NOT NULL,
    Variable INT,
    PRIMARY KEY (EmpId),
    FOREIGN KEY (EmpId) REFERENCES EmployeeDetails(EmpId)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO EmployeeDetails
	VALUES (121, "John Snow", 321, "2014-01-31", "Toronto"),
			(321, "Walter White", 986, "2015-01-30", "California"),
            (421, "Kuldeep Rana", 876, "2016-11-27", "New Delhi");
            
INSERT INTO EmployeeSalary
	VALUES (121, "P1", 8000, 500),
			(321, "P2", 10000, 1000),
            (421, "P1", 12000, 0);
            
#Verification
SELECT * FROM EmployeeDetails;
SELECT * FROM EmployeeSalary;

#Reset
DROP TABLE EmployeeDetails;
DROP TABLE EmployeeSalary;

#1
SELECT * FROM EmployeeDetails
WHERE City = "California" OR ManagerId = 321;

#2
SELECT * FROM EmployeeDetails
WHERE FullName LIKE "__hn%";

#3
SELECT * FROM EmployeeDetails d
JOIN EmployeeSalary s ON (d.EmpId = s.EmpId)
WHERE d.EmpId IN (SELECT EmpId FROM EmployeeDetails) AND
d.EmpId IN (SELECT EmpId FROM EmployeeSalary);

#4
SET @n = 'n';

SELECT SUM(Count) FROM
(SELECT FullName, (CHAR_LENGTH(FullName)) - (CHAR_LENGTH(REPLACE( FullName, @n, ""))) AS Count
FROM EmployeeDetails) t;

#5
SELECT d.FullName, s.Salary FROM EmployeeDetails d
JOIN EmployeeSalary s ON (d.EmpId = s.EmpID)
WHERE s.Salary >= 5000
AND s.Salary <= 10000;

#6
SELECT * FROM EmployeeDetails
WHERE EmpId IN (SELECT EmpId FROM EmployeeSalary WHERE Salary IS NOT NULL);

#7
SELECT d.*, s.Salary FROM EmployeeDetails d
LEFT JOIN EmployeeSalary s ON (d.EmpId = s.EmpId);

#8
SELECT * FROM EmployeeDetails
WHERE EmpId IN (SELECT ManagerId FROM EmployeeDetails);

#9
/* Insert new record with same fullname */

INSERT INTO EmployeeDetails VALUES (122, 'John Snow', 321, '2014-01-31', 'Toronto');

/* Find Duplicates */

SELECT FullName
FROM EmployeeDetails
GROUP BY FullName
HAVING COUNT(Fullname) > 1;

/* Delete Duplicates */

DELETE e1 FROM EmployeeDetails e1
INNER JOIN EmployeeDetails e2
WHERE
	e1.EmpId < e2.EmpId AND
    e1.FullName = e2.FullName;

#10
SELECT * FROM
(SELECT Salary, ROW_NUMBER() OVER(ORDER BY Salary DESC) rownum
FROM EmployeeSalary) t
WHERE rownum = @n;

#11
SELECT * FROM
(SELECT Salary, ROW_NUMBER() OVER(ORDER BY Salary DESC) rownum
FROM EmployeeSalary)
WHERE rownum = 3;

#Bonus - Average Salary for employees who are not managers
SELECT AVG(Salary)
FROM EmployeeSalary
WHERE EmpId NOT IN (SELECT ManagerId FROM EmployeeDetails);

#Bonus - Delete Duplicates using function
/* Insert new record with same fullname */

INSERT INTO EmployeeDetails VALUES (122, 'John Snow', 321, '2014-01-31', 'Toronto');
INSERT INTO EmployeeSalary VALUES (122, 'P1', 8000, 500);

/* Find Duplicates */

SELECT FullName
FROM EmployeeDetails
GROUP BY FullName
HAVING COUNT(Fullname) > 1;

/* Create function */

DELIMITER //
CREATE FUNCTION remove_employee(Fullname VARCHAR(30))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
DELETE FROM EmployeeDetails
WHERE FullName = FullName;
RETURN FullName;
END; //

/* Remove using function */

SELECT remove_employee(FullName) 
FROM EmployeeDetails
WHERE FullName IN (
SELECT FullName
FROM EmployeeDetails
GROUP BY FullName
HAVING COUNT(Fullname) > 1
);

/* Does not run, concurrency issues */
