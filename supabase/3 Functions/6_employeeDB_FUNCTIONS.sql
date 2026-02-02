-- ==============================================
-- 6. ฟังก์ชัน SQL (SQL Functions)
-- ==============================================

-- =====================================================
-- PART A: Built-in Functions (ฟังก์ชันสำเร็จรูป)
-- =====================================================

-- =====================================================
-- Arithmetic Operators (ตัวดำเนินการทางคณิตศาสตร์)
-- =====================================================

SELECT 1 + 2;

SELECT (5 * 2) % 3;

SELECT salary + (salary * 10 / 100) AS new_salary FROM employee;

-- =====================================================
-- Comparison Operators (ตัวดำเนินการเปรียบเทียบ)
-- =====================================================

-- PostgreSQL เป็น case-sensitive อยู่แล้ว
SELECT name FROM employee WHERE job = 'programmer';
    -- ถ้าต้องการ case-insensitive ให้ใช้ ILIKE หรือ LOWER():
    -- SELECT name FROM employee WHERE LOWER(job) = 'programmer';

SELECT name, salary FROM employee
    WHERE salary BETWEEN 15000 AND 19999;

SELECT * FROM employee
    WHERE job IN ('DBA', 'System Administrator');

-- =====================================================
-- Logical Operators (ตัวดำเนินการทางตรรกะ)
-- =====================================================

SELECT name, salary FROM employee
    WHERE job = 'Programmer' AND salary >= 15000;

SELECT * FROM employee
    WHERE job = 'Programmer' OR salary >= 10000;

-- XOR: (A OR B) AND NOT (A AND B)
SELECT * FROM employee
    WHERE (job = 'Programmer' OR salary >= 10000)
    AND NOT (job = 'Programmer' AND salary >= 10000);

-- =====================================================
-- Control Flow (ฟังก์ชันควบคุม)
-- =====================================================

-- ใช้ CASE WHEN แทน IF()
SELECT name,
    CASE
        WHEN job = 'Programmer' THEN 'Programming skill'
        ELSE 'Non programming skill'
    END AS skill
    FROM employee;

SELECT name, salary,
    CASE
        WHEN salary < 15000 THEN 'Low Salary'
        WHEN salary < 17000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS result
    FROM employee;

-- =====================================================
-- String Functions (ฟังก์ชันข้อความ)
-- =====================================================

SELECT CONCAT(name, ':', job), LENGTH(name)
    FROM employee;
    -- ใช้ || ต่อ string ได้ด้วย:
    -- SELECT name || ':' || job, LENGTH(name) FROM employee;

SELECT UPPER(name), LOWER(job)
    FROM employee;

SELECT REPLACE(job, 'DBA', 'Database Administrator')
    FROM employee;

-- จัดรูปแบบวันที่ด้วย TO_CHAR
SELECT TO_CHAR(workdate, 'DD/MM/YYYY') AS day_month_year
    FROM assignment;

-- TRIM (ตัดช่องว่าง)
SELECT CONCAT('    ', name) AS name_before,
       LENGTH(CONCAT('    ', name)) AS length_before,
       TRIM(CONCAT('    ', name)) AS name_after,
       LENGTH(TRIM(CONCAT('    ', name))) AS length_after
    FROM employee;

-- LIKE (ค้นหาแบบ pattern)
SELECT name FROM employee WHERE name LIKE '%o%';
    -- ILIKE = case-insensitive version:
    -- SELECT name FROM employee WHERE name ILIKE '%O%';

-- เปรียบเทียบ string
SELECT
    CASE WHEN 'somchai' = 'somchai'  THEN 0
         WHEN 'somchai' < 'somchai'  THEN -1
         ELSE 1
    END AS compare1,
    CASE WHEN 'somchai' = 'somjai'   THEN 0
         WHEN 'somchai' < 'somjai'   THEN -1
         ELSE 1
    END AS compare2;
    -- ผลลัพธ์: 0 (เท่ากัน), -1 (น้อยกว่า)

-- =====================================================
-- Numeric Functions (ฟังก์ชันตัวเลข)
-- =====================================================

SELECT ABS(salary) FROM employee;

SELECT employeeid, hours, CEILING(hours), FLOOR(hours)
    FROM assignment;

SELECT 10 / 3 AS divide, MOD(10, 3) AS remainder;
    -- integer / integer = integer (ปัดเศษทิ้งอัตโนมัติ)

SELECT POW(2, 0) AS power_0, POW(2, 10) AS power_10;

SELECT RANDOM() AS random1, RANDOM() AS random2, RANDOM() AS random3;

-- ตั้ง seed สำหรับ random (ค่าระหว่าง -1.0 ถึง 1.0)
SELECT SETSEED(0.77);
SELECT RANDOM() AS random1, RANDOM() AS random2, RANDOM() AS random3;

SELECT ROUND(5.654), ROUND(5.654, 1), ROUND(5.654, 2);

SELECT SQRT(2) AS squareroot_2;

-- =====================================================
-- Date and Time Functions (ฟังก์ชันวันที่และเวลา)
-- =====================================================

SELECT CURRENT_DATE AS date,
       CURRENT_TIME AS time,
       NOW() AS now;

-- จัดรูปแบบวันที่ด้วย TO_CHAR
SELECT TO_CHAR(CURRENT_DATE, 'Day DDth of Month YYYY') AS formatted_date;
    -- ตัวอย่าง: 'Monday 02nd of February  2026'

SELECT TO_CHAR(CURRENT_TIME, 'HH24 "Hours" MI "Minutes" SS "Seconds"') AS formatted_time;
    -- ตัวอย่าง: '13 Hours 30 Minutes 45 Seconds'

-- หาจำนวนวันระหว่างสองวันที่
SELECT CURRENT_DATE - DATE '2017-01-01' AS days_diff;

-- =====================================================
-- Aggregate Functions (ฟังก์ชันรวมกลุ่ม)
-- =====================================================

SELECT MIN(salary), MAX(salary) FROM employee;

SELECT SUM(salary), AVG(salary) FROM employee;

SELECT departmentid, SUM(salary) AS personnel_budget
    FROM employee
    GROUP BY departmentid;


-- =====================================================
-- PART B: User-Defined Functions (ฟังก์ชันที่สร้างเอง)
-- =====================================================
-- ⚠️ ความแตกต่างหลักระหว่าง MySQL กับ PostgreSQL:
--   - MySQL ใช้ PROCEDURE → PostgreSQL ใช้ FUNCTION
--   - MySQL ต้องใช้ DELIMITER → PostgreSQL ใช้ $$ ครอบ body แทน
--   - MySQL ใช้ CALL → PostgreSQL ใช้ SELECT function()
--   - MySQL ใช้ DECLARE ใน BEGIN...END → PostgreSQL ใช้ DECLARE ก่อน BEGIN
--   - MySQL ใช้ SET var = value → PostgreSQL ใช้ var := value

-- =====================================================
-- Non-parametric Function (ไม่มีพารามิเตอร์)
-- =====================================================

DROP FUNCTION IF EXISTS show_time();
CREATE OR REPLACE FUNCTION show_time()
RETURNS TABLE(message TEXT, current_time_value TIMESTAMP)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT 'Local time is: '::TEXT, NOW();
END;
$$;

SELECT * FROM show_time();

-- =====================================================
-- Parametric Functions (มีพารามิเตอร์)
-- =====================================================

-- 1) กรองพนักงานตามเงินเดือนขั้นต่ำ

DROP FUNCTION IF EXISTS employee_by_salary(INT);
CREATE OR REPLACE FUNCTION employee_by_salary(sal INT)
RETURNS TABLE(emp_id INT, emp_name VARCHAR, emp_job VARCHAR, emp_salary INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT employeeid, name, job, salary
            FROM employee
            WHERE salary >= sal;
END;
$$;

SELECT * FROM employee_by_salary(12000);
SELECT * FROM employee_by_salary(15000);

-- 2) กรองพนักงานตามเงินเดือนและตำแหน่ง

DROP FUNCTION IF EXISTS employee_by_salary_job(INT, VARCHAR);
CREATE OR REPLACE FUNCTION employee_by_salary_job(emp_sal INT, emp_job VARCHAR(30))
RETURNS TABLE(out_id INT, out_name VARCHAR, out_job VARCHAR, out_salary INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT employeeid, name, job, salary
            FROM employee
            WHERE salary >= emp_sal AND job = emp_job;
END;
$$;

SELECT * FROM employee_by_salary_job(12000, 'Programmer');
SELECT * FROM employee_by_salary_job(15000, 'Programmer');

-- =====================================================
-- Variables (ตัวแปร)
-- =====================================================

-- MySQL:  DECLARE อยู่ใน BEGIN...END, ใช้ DEFAULT กำหนดค่าเริ่มต้น
-- PostgreSQL: DECLARE อยู่ก่อน BEGIN, ใช้ := กำหนดค่าเริ่มต้น

DROP FUNCTION IF EXISTS example_variables(VARCHAR);
CREATE OR REPLACE FUNCTION example_variables(p_name VARCHAR(10))
RETURNS TABLE(greeting TEXT, sum_result INT)
LANGUAGE plpgsql
AS $$
DECLARE
    a CHAR(12) := 'Hello Khun ';
    x INT;
    y INT;
BEGIN
    x := 1;
    y := 2;
    RETURN QUERY SELECT CONCAT(a, p_name)::TEXT, x + y;
END;
$$;

SELECT * FROM example_variables('Chanchai');

-- =====================================================
-- Conditional Statements (คำสั่งเงื่อนไข)
-- =====================================================

-- ----- IF Statement -----
-- MySQL: ELSEIF → PostgreSQL: ELSIF

DROP FUNCTION IF EXISTS if_get_day();
CREATE OR REPLACE FUNCTION if_get_day()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    day_num INT;
BEGIN
    day_num := EXTRACT(DOW FROM CURRENT_DATE)::INT;

    IF day_num = 0 THEN RETURN 'Today is Sunday';
    ELSIF day_num = 1 THEN RETURN 'Today is Monday';
    ELSIF day_num = 2 THEN RETURN 'Today is Tuesday';
    ELSIF day_num = 3 THEN RETURN 'Today is Wednesday';
    ELSIF day_num = 4 THEN RETURN 'Today is Thursday';
    ELSIF day_num = 5 THEN RETURN 'Today is Friday';
    ELSE RETURN 'Today is Saturday';
    END IF;
END;
$$;

SELECT if_get_day();

-- ----- CASE Statement -----

DROP FUNCTION IF EXISTS get_day2();
CREATE OR REPLACE FUNCTION get_day2()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    day_num INT;
BEGIN
    day_num := EXTRACT(DOW FROM CURRENT_DATE)::INT;

    CASE day_num
        WHEN 0 THEN RETURN 'Today is Sunday';
        WHEN 1 THEN RETURN 'Today is Monday';
        WHEN 2 THEN RETURN 'Today is Tuesday';
        WHEN 3 THEN RETURN 'Today is Wednesday';
        WHEN 4 THEN RETURN 'Today is Thursday';
        WHEN 5 THEN RETURN 'Today is Friday';
        ELSE RETURN 'Today is Saturday';
    END CASE;
END;
$$;

SELECT get_day2();

-- =====================================================
-- Looping Statements (คำสั่งวนซ้ำ)
-- =====================================================

-- ----- LOOP + EXIT (วนซ้ำแบบไม่มีเงื่อนไข) -----
-- MySQL: LEAVE label → PostgreSQL: EXIT label

DROP FUNCTION IF EXISTS loop_leave();
CREATE OR REPLACE FUNCTION loop_leave()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    counter INT := 0;
BEGIN
    <<simple_loop>>
    LOOP
        counter := counter + 10;
        IF counter = 50 THEN
            EXIT simple_loop;
        END IF;
    END LOOP;
    RETURN counter;
END;
$$;

SELECT loop_leave();

-- ----- WHILE Loop -----
-- MySQL: WHILE...DO...END WHILE → PostgreSQL: WHILE...LOOP...END LOOP

DROP FUNCTION IF EXISTS dowhile();
CREATE OR REPLACE FUNCTION dowhile()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total INT := 0;
    count INT := 0;
BEGIN
    WHILE count <= 100 LOOP
        total := total + count;
        count := count + 2;
    END LOOP;
    RETURN total;
END;
$$;

SELECT dowhile();

-- ----- LOOP + EXIT WHEN (แทน REPEAT...UNTIL) -----
-- MySQL มี REPEAT...UNTIL → PostgreSQL ใช้ LOOP + EXIT WHEN แทน

DROP FUNCTION IF EXISTS dorepeat();
CREATE OR REPLACE FUNCTION dorepeat()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total INT := 0;
    count INT := 1;
BEGIN
    LOOP
        total := total + count;
        count := count + 2;
        EXIT WHEN count > 100;
    END LOOP;
    RETURN total;
END;
$$;

SELECT dorepeat();
