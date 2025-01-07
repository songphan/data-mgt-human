/*
SQL Functions
Page 79-100*/

--Arithmetric Operators
SELECT 1 + 2;
SELECT (5*2)%3;
SELECT salary + (salary *10/100) As New_Salary FROM employee;

-- Comparison Operators
SELECT name FROM employee WHERE job = binary 'programmer';
SELECT name, salary FROM employee WHERE salary BETWEEN 15000 AND 19999;
SELECT * FROM employee WHERE job in ('DBA', 'System Administrator');

--Logical Operators
SELECT name, salary FROM employee WHERE job = 'Programmer' AND salary >= 15000;
SELECT * FROM employee WHERE job = 'Programmer' OR salary >= 10000;
SELECT * FROM employee WHERE job= 'Programmer' XOR salary >= 10000;

--Control Flow Functions
SELECT name, IF(job= 'Programmer', "Programming skill", "Non programming skill") AS Skill FROM employee;
SELECT name, salary, CASE
	WHEN salary < 15000 then "Low Salary"
	WHEN salary < 17000 then "Medium Salary"
	ELSE "High Salary"
	END AS Result
	FROM employee;
	
--String Functions
SELECT concat(name, ":", job), length(name)
	FROM employee;
SELECT upper(name), lower(job)
	FROM employee;
SELECT replace(job, 'DBA', 'Database Administrator')
	FROM employee;
SELECT concat(substring(workdate, 9, 2), "/", substring(workdate, 6, 2 ), "/", substring(workdate, 1,4)) AS Day_Month_Year
	FROM assignment;
SELECT concat("    ", name) AS Name_Before, length(concate("    ",name)) AS Lengh_Before, trim(concat("    ", name)) AS Name_After, length(trim(concat("    ", name))) AS Length_After
	FROM employee;
SELECT name FROM employee WHERE name LIKE "%o%";
SELECT strcmp('somchai', 'somchai'), strcmp('somchai', 'somjai');

--Numeric functions
SELECT abs(salary) FROM employee;
SELECT employeeID, hours, ceiling(hours), floor(hours)
	FROM assignment;
SELECT 10 div 3 AS Divide, mod(10,3) AS Remainder;
SELECT pow(2,0) AS 2_Power_0, pow(2,10) AS 2_Power_10;
SELECT rand() AS Random1, rand() AS Random2, rand() AS Random3;
SELECT rand(77) AS Random1, rand(77) AS Random2, rand(77) AS Random3;
SELECT round(5.654), round(5.654,1), round(5.654,2);
SELECT sqrt(2) AS SquareRoot_2;

-- Date and time functions
SELECT curdate() AS Date, curtime() AS Time, now() AS Now;
SELECT date_format(curdate(), '%W %D of &M &Y');
SELECT time_format(curtime(), '%H Hours %i Minutes %S Seconds');
SELECT datediff(curdate(),'2017-01-01');

-- Group functions
SELECT min(salary), max(salary) FROM employee;
SELECT sum(salary), avg(salary) FROM employee;
SELECT departmentID, sum(salary) AS Personnel_budget
	FROM employee
	GROUP BY departmentID;


