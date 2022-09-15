USE exercises;

CREATE TABLE Departments (
	department_id INT PRIMARY KEY NOT NULL,
	department_name VARCHAR(30) NOT NULL,
	location_id INT NOT NULL
);

CREATE TABLE Employees (
	employee_id INT NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL,
	phone_number VARCHAR(20) NOT NULL,
	hire_date DATE NOT NULL,
	job_id VARCHAR(10) NOT NULL,
	salary INT NOT NULL,
	commission_pct INT,
	manager_id INT,
	department_id INT NOT NULL,
	PRIMARY KEY (employee_id),
	FOREIGN KEY (department_id) REFERENCES Departments(department_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO Departments
	VALUES (20, 'Marketing', 180),
			(30, 'Purchasing', 1700),
            (40, 'Human Resources', 2400),
            (50, 'Shipping', 1500),
            (60, 'IT', 1400),
            (70, 'Public Relations', 2700),
            (80, 'Sales', 2500),
            (90, 'Executive', 1700),
            (100, 'Finance', 1700),
            (110, 'Accounting', 1700),
            (120, 'Treasury', 1700),
            (130, 'Corporate Tax', 1700),
            (140, 'Control and Credit', 1700),
            (150, 'Shareholder Services', 1700),
            (160, 'Benefits', 1700),
            (170, 'Payroll', 1700);
            
INSERT INTO Employees
	VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', '1987-06-17', 'AD_PRES', 24000, null, null, 20),
			(101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '1989-11-21', 'AD_VP', 17000, null, 100, 20),
            (102, 'Lex', 'DeHaan', 'LDEHAAN', '515.123.4569', '1993-09-12', 'AD_VP', 17000, null, 100, 30),
            (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '1990-09-30', 'IT_PROG', 9000, null, 102, 60),
            (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '1991-05-21', 'IT_PROG', 6000, null, 103, 60),
            (105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', '1997-06-25', 'IT_PROG', 4800, null, 103, 60),
            (106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4569', '1998-02-05', 'IT_PROG', 4800, null, 103, 40),
            (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.4560', '1999-02-09', 'IT_PROG', 4800, null, 103, 40),
            (108, 'Nancy', 'Greenberg', 'NGREENBERG', '515.423.5567', '1994-08-12', 'FI_MGR', 12000, null, 101, 100),
            (109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '1994-08-12', 'FI_ACCOUNT', 9000, null, 108, 170),
            (110, 'John', 'Chen', 'JCHEN', '515.124.4269', '1997-04-09', 'FI_ACCOUNT', 8200, null, 108, 170);

#Verification
SELECT * FROM Departments;
SELECT * FROM Employees;

#1 Select first name, last name, job id and salary for employees that start with 'S'
SELECT first_name, last_name, job_id, salary
FROM Employees
WHERE first_name LIKE 'S%';

#2 Select employee with the highest salary
SELECT * FROM Employees
ORDER BY salary DESC
LIMIT 1;

#3 Second highest salary
SELECT * FROM
(SELECT *, RANK() OVER(ORDER BY salary DESC) sal_rank
FROM Employees) t
WHERE sal_rank = 2;

#4 Second or third highest salary
SELECT * FROM
(SELECT *, DENSE_RANK() OVER(ORDER BY salary DESC) sal_rank
FROM Employees) t
WHERE sal_rank = 2
OR sal_rank =3;

#5 Employees, their corresponding manager and their salaries
SELECT e.employee_id, CONCAT(e.first_name, " ", e.last_name) full_name, e.manager_id, CONCAT(m.first_name, " ", m.last_name) manager_name, m.salary manager_salary
FROM Employees e
JOIN Employees m ON (e.manager_id = m.employee_id);

#6 Count of employees under each manager in descending order
SELECT manager_id, COUNT(employee_id)
FROM Employees
GROUP BY manager_id
ORDER BY COUNT(employee_id) DESC;

#7 Count of employees in each department
SELECT COUNT(employee_id), department_id
FROM Employees
GROUP BY department_id;

#8 Count of employees hired year wise
SELECT COUNT(employee_id), YEAR(hire_date)
FROM Employees
GROUP BY YEAR(hire_date);

#9 Salary range of employees
SELECT MAX(salary) max, MIN(salary) min
FROM Employees;

#10 Divide people into 3 groups based on their salaries
SELECT *, NTILE(3) OVER(ORDER BY salary DESC) third_table
FROM Employees;

#11 Employees whose first names contain 'an'
SELECT first_name FROM Employees
WHERE first_name LIKE '%an%';

#12 Display phone numbers in the format (---)(---)(----)
SELECT first_name, 
CONCAT('(', SUBSTRING(phone_number, 1, 3), ')-(', SUBSTRING(phone_number, 5, 3), ')-(', SUBSTRING(phone_number, 9, 4), ')') as phone
FROM Employees;

#13 Find employees who joined in August, 1994
SELECT * FROM Employees
WHERE YEAR(hire_date) = 1994
AND MONTH(hire_date) = 08;

#14 Employees with salary higher than average
SELECT * FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

#15 Maximum salary for each department
SELECT MAX(salary), department_id
FROM Employees
GROUP BY department_id;

#16 5 least earning employees
SELECT * FROM Employees
ORDER BY salary ASC
LIMIT 5;

#17 Employees hired in the 80s
SELECT * FROM Employees
WHERE YEAR(hire_date) BETWEEN 1980 AND 1989;

#18 First name and first name in reverse order
SELECT first_name, REVERSE(first_name)
FROM Employees;

#19 Employees hired after the 15th day of the month
SELECT * FROM Employees
WHERE DAY(hire_date) > 15;

#20 Managers and reporting employees who work in different departments
SELECT CONCAT(m.first_name, " ", m.last_name) manager_name, CONCAT(e.first_name, " ", e.last_name) employee_name
FROM Employees e
JOIN Employees m ON (e.manager_id = m.employee_id)
WHERE m.department_id <> e.department_id;

# Bonus Display the average salary for a department
delimiter ^^
CREATE PROCEDURE average_dept_sal(in id int)
BEGIN
SELECT CONCAT('$', FORMAT(AVG(salary), 2)) Avg_Salary
FROM Employees
WHERE department_id = id;
END^^

CALL average_dept_sal(60);

# Bonus 2 Set the commission percentage based on department when new row is inserted
delimiter //
CREATE TRIGGER set_comm_pct
BEFORE INSERT ON Employees FOR EACH ROW
BEGIN
IF new.department_id < 50 THEN
SET new.commission_pct = 10;
ELSEIF new.department_id BETWEEN 50 AND 100 THEN
SET new.commission_pct = 15;
ELSEIF new.department_id > 100 THEN
SET new.commission_pct = 20;
END IF;
END//

INSERT INTO Employees
VALUES (111, 'James', 'Bond', 'JBOND', '512.476.8798', '1995-09-12', 'FI_ACCOUNT', 8000, null, 108, 170),
		(112, 'Caitlin', 'Jones', 'CJONES', '512.246.4784', '1993-04-01', 'IT_PROG', 9000, null, 103, 60),
        (113, 'Jeffrey', 'Blum', 'JBLUM', '512.756.9376', '2001-11-22', 'IT_PROG', 8500, null, 103, 40);

SELECT * FROM Employees;