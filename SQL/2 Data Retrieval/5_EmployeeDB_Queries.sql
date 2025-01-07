--Query all data in a table:

SELECT * FROM employee;
SELECT * FROM department;

--Query selected fields in a table:

SELECT employeeID, name, salary FROM employee;
SELECT name, address FROM client;

--Query selected fields and create an alias (change the column name) in a table:

SELECT employeeID AS employee_ID, name AS employee_Name, salary AS employee_salary 
	FROM employee;

--Query all data in a table with a criteria:

SELECT * FROM employee WHERE departmentID = 128;
SELECT * FROM employee WHERE job = 'DBA';

--Query redundant records:

SELECT job FROM employee;
SELECT DISTINCT job FROM employee;
SELECT COUNT(job) FROM employee;
SELECT COUNT(DISTINCT job) FROM employee;

--Grouping records yielded from a query without a criteria:

SELECT job, COUNT(job) 
	FROM employee 
	GROUP BY job;
SELECT departmentID, COUNT(departmentID) 
	FROM employee
	GROUP BY departmentID;

--Grouping records yielded from a query with a criteria:

SELECT job, COUNT(job) 
	FROM employee 
	HAVING COUNT(job)=1;
	
--Ordering query results:

SELECT * FROM employee ORDER BY salary;
SELECT * FROM employee ORDER by salary DESC;

--Limit the number of query results showed:
SELECT * FROM employee LIMIT 5;
SELECT * FROM employee LIMIT 1, 3;
SELECT * FROM employee LIMIT 0, 1;

--Join two tables;

SELECT employee.name, department.name
	FROM employee, department
	WHERE employee.departmentID = department.departmentID;
SELECT assignment.clientID, employee.name 
	FROM employee, assignment
	WHERE employee.employeeID = assignment.employeeID;
	
--Change table names when joining tables:
	
SELECT e.name, d.name
	FROM employee e, department d
	WHERE e.departmentID=d.departmentID;
SELECT a.clientID, e.name
	FROM employee e, assignment a
	WHERE e.employeeID = a.employeeID;
	
--Join more than two tables:
	
SELECT client.name AS ClientName, employee.name AS EmployeeName
	FROM employee, client, assignment
	WHERE employee.employeeID = assignment.employeeID
	AND assignment.clientID = client.clientID;
	
SELECT client.name AS ClientName, employee.name AS EmployeeName, department.name AS DepartmentName
	FROM employee, client, assignment, department
	WHERE employee.employeeID = assignment.employeeID
	AND assignment.clientID = client.clientID
	AND employee.departmentID = department.departmentID;

--Self join:
SELECT e2.name
	FROM employee e1, employee e2
	WHERE e1.departmentID = e2.departmentID
	AND e1.name = 'Somchai'
	AND e2.name != 'Somchai';
SELECT e2.name, e2.salary
	FROM employee e1, employee e2
	WHERE e1.salary = e2.salary
	AND e1.name = 'Somjai' AND e2.name != 'Somjai';

--Left join:

SELECT *
	FROM employee LEFT JOIN assignment
	ON employee.employeeID = assignment.employeeID;
	
--Right join:

SELECT *
	FROM employee RIGHT JOIN assignment
	ON employee.employeeID = assignment.employeeID;
	
--Left join with a condition:

SELECT *
	FROM employee LEFT JOIN assignment
	ON employee.employeeID = assignment.employeeID
	WHERE assignment.clientID is Null;
	
--Subqueries:

SELECT name
	FROM employee
	WHERE employeeID not in (SELECT employeeID
		FROM assignment);
SELECT name
	FROM employee
	WHERE salary = (SELECT max(salary)
		FROM employee);
SELECT employee.name
	FROM employee, assignment
	WHERE employee.employeeID = assignment.employeeID
	AND employee.employeeID in (SELECT employeeID
		FROM employee
		WHERE job = 'Programmer');
	
	
	
