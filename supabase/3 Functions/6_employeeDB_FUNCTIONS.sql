-- ==============================================
-- 6. ฟังก์ชัน SQL (SQL Functions)
-- ==============================================

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
-- Control Flow Functions (ฟังก์ชันควบคุม)
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
