-- ==============================================
-- 5. สืบค้นข้อมูล (SELECT Queries)
-- ==============================================

-- ----- สืบค้นข้อมูลทั้งหมดในตาราง -----
SELECT * FROM employee;
SELECT * FROM department;
    -- เหมือน MySQL ✓

-- ----- สืบค้นเฉพาะบางคอลัมน์ -----
SELECT employeeid, name, salary FROM employee;
SELECT name, address FROM client;
    -- เหมือน MySQL ✓

-- ----- ตั้งชื่อเล่นให้คอลัมน์ (Alias) -----
SELECT employeeid AS employee_id,
       name AS employee_name,
       salary AS employee_salary
    FROM employee;
    -- เหมือน MySQL ✓

-- ----- สืบค้นแบบมีเงื่อนไข (WHERE) -----
SELECT * FROM employee WHERE departmentid = 128;
SELECT * FROM employee WHERE job = 'DBA';
    -- เหมือน MySQL ✓

-- ----- ค่าที่ไม่ซ้ำ (DISTINCT) -----
SELECT job FROM employee;
SELECT DISTINCT job FROM employee;
SELECT COUNT(job) FROM employee;
SELECT COUNT(DISTINCT job) FROM employee;
    -- เหมือน MySQL ✓

-- ----- จัดกลุ่มข้อมูล (GROUP BY) -----
SELECT job, COUNT(job)
    FROM employee
    GROUP BY job;

SELECT departmentid, COUNT(departmentid)
    FROM employee
    GROUP BY departmentid;

-- ----- จัดกลุ่มแบบมีเงื่อนไข (GROUP BY + HAVING) -----
SELECT job, COUNT(job)
    FROM employee
    GROUP BY job
    HAVING COUNT(job) = 1;
    -- ⚠️ ไฟล์เดิมไม่มี GROUP BY → PostgreSQL บังคับต้องมี

-- ----- เรียงลำดับ (ORDER BY) -----
SELECT * FROM employee ORDER BY salary;
SELECT * FROM employee ORDER BY salary DESC;
    -- เหมือน MySQL ✓

-- ----- จำกัดจำนวนผลลัพธ์ (LIMIT / OFFSET) -----
SELECT * FROM employee LIMIT 5;
    -- เหมือน MySQL ✓

-- MySQL:     SELECT * FROM employee LIMIT 1, 3;
-- Supabase:
SELECT * FROM employee LIMIT 3 OFFSET 1;
    -- MySQL ใช้: LIMIT offset, count
    -- PostgreSQL ใช้: LIMIT count OFFSET offset
    -- (สลับตำแหน่งตัวเลข!)

-- MySQL:     SELECT * FROM employee LIMIT 0, 1;
-- Supabase:
SELECT * FROM employee LIMIT 1 OFFSET 0;

-- =====================================================
-- JOIN (เชื่อมตาราง)
-- =====================================================

-- ----- Implicit Join (old-style) — ใช้ได้ทั้ง MySQL และ Supabase -----
SELECT employee.name, department.name
    FROM employee, department
    WHERE employee.departmentid = department.departmentid;

SELECT assignment.clientid, employee.name
    FROM employee, assignment
    WHERE employee.employeeid = assignment.employeeid;

-- ----- ใช้ Alias ย่อชื่อตาราง -----
SELECT e.name, d.name
    FROM employee e, department d
    WHERE e.departmentid = d.departmentid;

SELECT a.clientid, e.name
    FROM employee e, assignment a
    WHERE e.employeeid = a.employeeid;

-- ----- Explicit JOIN (แนะนำให้ใช้แบบนี้แทน) -----
-- เขียนแบบ Explicit JOIN อ่านง่ายกว่า:
SELECT e.name, d.name
    FROM employee e
    INNER JOIN department d ON e.departmentid = d.departmentid;

-- ----- Join หลายตาราง -----
SELECT client.name AS clientname,
       employee.name AS employeename
    FROM employee
    INNER JOIN assignment ON employee.employeeid = assignment.employeeid
    INNER JOIN client ON assignment.clientid = client.clientid;

SELECT client.name AS clientname,
       employee.name AS employeename,
       department.name AS departmentname
    FROM employee
    INNER JOIN assignment ON employee.employeeid = assignment.employeeid
    INNER JOIN client ON assignment.clientid = client.clientid
    INNER JOIN department ON employee.departmentid = department.departmentid;

-- ----- Self Join -----
SELECT e2.name
    FROM employee e1, employee e2
    WHERE e1.departmentid = e2.departmentid
    AND e1.name = 'Somchai'
    AND e2.name != 'Somchai';

SELECT e2.name, e2.salary
    FROM employee e1, employee e2
    WHERE e1.salary = e2.salary
    AND e1.name = 'Somjai'
    AND e2.name != 'Somjai';
    -- เหมือน MySQL ✓

-- ----- LEFT JOIN -----
SELECT *
    FROM employee
    LEFT JOIN assignment ON employee.employeeid = assignment.employeeid;

-- ----- RIGHT JOIN -----
SELECT *
    FROM employee
    RIGHT JOIN assignment ON employee.employeeid = assignment.employeeid;

-- ----- LEFT JOIN + เงื่อนไข (หาพนักงานที่ยังไม่มี assignment) -----
SELECT *
    FROM employee
    LEFT JOIN assignment ON employee.employeeid = assignment.employeeid
    WHERE assignment.clientid IS NULL;
    -- เหมือน MySQL ✓  (ใช้ IS NULL ไม่ใช่ = Null)

-- =====================================================
-- Subqueries (แบบสอบถามย่อย)
-- =====================================================

-- หาพนักงานที่ยังไม่มี assignment
SELECT name
    FROM employee
    WHERE employeeid NOT IN (
        SELECT employeeid FROM assignment
    );

-- หาพนักงานที่เงินเดือนสูงสุด
SELECT name
    FROM employee
    WHERE salary = (
        SELECT MAX(salary) FROM employee
    );

-- หา Programmer ที่มี assignment
SELECT employee.name
    FROM employee
    INNER JOIN assignment ON employee.employeeid = assignment.employeeid
    WHERE employee.employeeid IN (
        SELECT employeeid FROM employee
        WHERE job = 'Programmer'
    );
    -- เหมือน MySQL ✓
