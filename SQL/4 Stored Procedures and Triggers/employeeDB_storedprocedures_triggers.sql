/*
SQL Stored Procedures and Trigger
*/
-- Non-parametric procedure
DELIMITER $
DROP PROCEDURE IF EXISTS show_time;
CREATE PROCEDURE show_time()
	BEGIN
		SELECT 'Local time is: ', now();
	END$
DELIMITER ;
CALL show_time();

--Parametric procedure
--1 Filter employee by minimum salary
DELIMITER $
DROP PROCEDURE IF EXISTS employee_by_salary;
CREATE PROCEDURE employee_by_salary(sal INT)
	BEGIN
		SELECT employeeID, name, job, salary
			FROM employee
			WHERE salary >= sal;
	END$
DELIMITER ;
CALL employee_by_salary(12000);
CALL employee_by_salary(15000);

--2 Filter employee by minimum salary and job
DELIMITER $
DROP PROCEDURE IF EXISTS employee_by_salary_job;
CREATE PROCEDURE employee_by_salary_job(emp_sal INT, emp_job Varchar(30))
	BEGIN
		SELECT employeeID, name, job, salary
			FROM employee
			WHERE salary >= emp_sal and job = emp_job;
	END$
DELIMITER ;
CALL employee_by_salary_job(12000,'Programmer');
CALL employee_by_salary_job(15000,'Programmer');

--Create and define parameters/variables
DELIMITER $
DROP PROCEDURE IF EXISTS example_variables;
CREATE PROCEDURE example_variables(name Varchar(10))
	BEGIN
	DECLARE a char(12) DEFAULT 'Hello Khun ';
	DECLARE x, y INT;
	SELECT CONCAT(a, name);
	SET x=1;
	SET y=2;
	SELECT x+y;
	END$
DELIMITER ;
CALL example_variables('Chanchai');

-- Conditional statements
-- IF statements
DROP PROCEDURE IF EXISTS IF_get_day;
DELIMITER $
CREATE PROCEDURE IF_get_day()
	BEGIN
	DECLARE day INT;
	SET day = DATE_FORMAT(CURDATE(), '%w');
	IF day = 0 THEN SELECT 'Today is Sunday' AS DAY;
	ELSEIF day = 1 THEN SELECT 'Today is Monday' AS DAY;
	ELSEIF day = 2 THEN SELECT 'Today is Tuesday' AS DAY;
	ELSEIF day = 3 THEN SELECT 'Today is Wednesday' AS DAY;
	ELSEIF day = 4 THEN SELECT 'Today is Thursday' AS DAY;
	ELSEIF day = 5 THEN SELECT 'Today is Friday' AS DAY;
	ELSE SELECT 'Today is Saturday' AS DAY;
	END IF;
	END$
DELIMITER ;
CALL IF_get_day();

-- CASE statements
DROP PROCEDURE IF EXISTS get_day2;
DELIMITER $
CREATE PROCEDURE get_day2()
	BEGIN
	DECLARE day INT;
	SET day = date_format(curdate(), '%w');
	CASE day
	WHEN 0 THEN SELECT 'Today is Sunday' AS DAY;
	WHEN 1 THEN SELECT 'Today is Monday' AS DAY;
	WHEN 2 THEN SELECT 'Today is Tuesday' AS DAY;
	WHEN 3 THEN SELECT 'Today is Wednesday' AS DAY;
	WHEN 4 THEN SELECT 'Today is Thursday' AS DAY;
	WHEN 5 THEN SELECT 'Today is Friday' AS DAY;
	ELSE SELECT 'Today is Saturday' AS DAY;
	END CASE;
	END$
DELIMITER ;
CALL get_day2();

-- Looping statements
-- Loop statement
USE employee;
delimiter $
CREATE PROCEDURE loop_leave()
	BEGIN
	DECLARE counter INT DEFAULT 0;
	simple_loop: Loop
		SET counter=counter+10;
		SELECT counter;
		IF counter=50 THEN
			LEAVE simple_loop;
		END IF;
	END LOOP;
	END$
DELIMITER ;
CALL loop_leave;

--Do While statement
DELIMITER $
CREATE PROCEDURE dowhile()
	BEGIN
	DECLARE sum INT DEFAULT 0;
	DECLARE count INT DEFAULT 0;
	WHILE count <= 100 DO
		SET sum = sum + count;
		SET count = count + 2;
	END WHILE;
	SELECT sum;
	END$
DELIMITER ;
CALL dowhile();

-- Do Repeat statement
USE employee;
DELIMITER $
CREATE PROCEDURE dorepeat()
	BEGIN
	DECLARE sum INT DEFAULT 0;
	DECLARE count INT DEFAULT 1;
	REPEAT
		SET sum = sum + count;
		SET count = count + 2;
	UNTIL count > 100 END REPEAT;
	SELECT sum;
END$
DELIMITER ;
CALL dorepeat();

--Trigger
--Example 1
DROP TABLE IF EXISTS t;
CREATE TABLE t(percent INT, date DATETIME);
DELIMITER $
CREATE TRIGGER check_percent BEFORE INSERT ON t
	FOR EACH ROW
	BEGIN
	SET NEW.date = now();
	IF NEW.percent <0 THEN SET NEW.percent = 0;
	ELSEIF NEW.percent > 100 THEN SET NEW.percent = 100;
	END IF;
	END$
DELIMITER ;
INSERT INTO t(percent) VALUES(-5);
INSERT INTO t(percent) VALUES(45);
INSERT INTO t(percent) VALUES(150);
SELECT * FROM t;

--Example 2
DROP TABLE IF EXISTS test1, test2, test3;
CREATE TABLE test1(a1 INT);
CREATE TABLE test2(a2 INT);
CREATE TABLE test3(a3 INT NOT NULL AUTO_INCREMENT PRIMARY KEY);
DELIMITER $
CREATE TRIGGER testref BEFORE INSERT ON test1
	FOR EACH ROW
	BEGIN
	INSERT INTO test2 SET a2=NEW.a1;
	DELETE FROM test3 WHERE a3=NEW.a1;
END$
DELIMITER ;
INSERT INTO test3(a3) VALUES (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL);
INSERT INTO test1 VALUES (1), (3), (1), (7), (1), (8), (4), (4);
SELECT * FROM test1;
SELECT * FROM test2;
SELECT * FROM test3;

--Example 3
DROP TABLE IF EXISTS customer;
CREATE TABLE customer(
	id INT,
	name VARCHAR(30),
	address VARCHAR(50),
	email VARCHAR(25),
	tel VARCHAR(15));
INSERT INTO customer VALUES
	(1, 'SingCorp', 'Bangkok, Thailand', 'cc@singcorp.co.th', '66801234567'),
	(2, 'Barbeque Kitchen', 'London, England', 'bk@bk.com', '44801873652'),
	(3, 'Crazy Cats', 'Sydney, Australia', 'czycts@gmail.com', '61814982745');
SELECT * FROM customer;

CREATE TABLE customer_log(
	id INT,
	name VARCHAR(30),
	address VARCHAR(50),
	email VARCHAR(25),
	tel VARCHAR(15),
	date_insert DATE,
	time_insert TIME);
SELECT * FROM customer_log;

DELIMITER $
CREATE TRIGGER customer_trigger AFTER DELETE ON customer
	FOR EACH ROW
	BEGIN
	INSERT INTO customer_log 
		VALUES(OLD.id, OLD.name, OLD.address, OLD.email, OLD.tel, curdate(), curtime());
	END$
DELIMITER ;

DELETE FROM customer WHERE id=2;
SELECT * FROM customer_log;
	