-- ==============================================
-- 8. Views, Constraints, and Indexes
-- ==============================================

-- =====================================================
-- PART A: Constraints (ข้อจำกัดของข้อมูล)
-- =====================================================

-- ----- NOT NULL: ห้ามเป็นค่าว่าง -----

CREATE TABLE book (
    bookid SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,         -- ชื่อหนังสือต้องมีเสมอ
    author VARCHAR(100) NOT NULL,        -- ชื่อผู้แต่งต้องมีเสมอ
    isbn CHAR(13),                       -- ISBN อาจไม่มีก็ได้
    published_year INT
);

-- ทดสอบ: จะ error เพราะ title เป็น NOT NULL
INSERT INTO book (author, isbn) VALUES ('Unknown', '9781234567890');

-- ทดสอบ: สำเร็จ
INSERT INTO book (title, author) VALUES ('สามก๊ก', 'เจ้าพระยาพระคลัง (หน)');

-- ----- UNIQUE: ค่าห้ามซ้ำ -----

CREATE TABLE library_member (
    memberid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,           -- อีเมลห้ามซ้ำ
    phone CHAR(10) UNIQUE               -- เบอร์โทรห้ามซ้ำ
);

-- สำเร็จ
INSERT INTO library_member (name, email, phone)
    VALUES ('สมชาย', 'somchai@example.com', '0812345678');

-- จะ error เพราะ email ซ้ำ
INSERT INTO library_member (name, email, phone)
    VALUES ('สมหญิง', 'somchai@example.com', '0899999999');

-- ----- CHECK: ตรวจสอบเงื่อนไข -----

CREATE TABLE artifact (
    artifactid SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    year_discovered INT CHECK (year_discovered >= 0),
        -- ปี ค.ศ. ที่ค้นพบต้องไม่ติดลบ
    condition VARCHAR(20) CHECK (condition IN ('Excellent', 'Good', 'Fair', 'Poor')),
        -- สถานะต้องเป็นค่าใดค่าหนึ่งเท่านั้น
    weight_kg REAL CHECK (weight_kg > 0)
        -- น้ำหนักต้องมากกว่า 0
);

-- สำเร็จ
INSERT INTO artifact (name, year_discovered, condition, weight_kg)
    VALUES ('พระพุทธรูปสมัยสุโขทัย', 1950, 'Good', 12.5);

-- จะ error: condition ไม่ใช่ค่าที่กำหนด
INSERT INTO artifact (name, year_discovered, condition, weight_kg)
    VALUES ('ศิลาจารึก', 1833, 'Damaged', 45.0);

-- จะ error: year_discovered ติดลบ
INSERT INTO artifact (name, year_discovered, condition, weight_kg)
    VALUES ('เครื่องปั้นดินเผา', -500, 'Fair', 2.3);

-- ----- DEFAULT: ค่าเริ่มต้น -----

CREATE TABLE document (
    docid SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    status VARCHAR(20) DEFAULT 'Draft',
        -- ถ้าไม่ระบุ จะเป็น 'Draft' อัตโนมัติ
    created_at TIMESTAMPTZ DEFAULT NOW(),
        -- ถ้าไม่ระบุ จะบันทึกเวลาปัจจุบัน
    language VARCHAR(20) DEFAULT 'Thai'
);

-- ไม่ต้องระบุ status, created_at, language — ใช้ค่า default
INSERT INTO document (title) VALUES ('รายงานการวิจัย');
SELECT * FROM document;

-- ----- Constraints ระดับตาราง (Table-level) -----

CREATE TABLE exhibition (
    exhibitionid SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    venue VARCHAR(100),

    -- CHECK ที่เปรียบเทียบหลายคอลัมน์ต้องเขียนระดับตาราง
    CONSTRAINT valid_dates CHECK (end_date >= start_date),

    -- UNIQUE หลายคอลัมน์ร่วมกัน
    CONSTRAINT unique_exhibition UNIQUE (name, start_date)
);

-- สำเร็จ
INSERT INTO exhibition (name, start_date, end_date, venue)
    VALUES ('นิทรรศการศิลป์ร่วมสมัย', '2026-03-01', '2026-03-31', 'หอศิลป์กรุงเทพฯ');

-- จะ error: end_date ก่อน start_date
INSERT INTO exhibition (name, start_date, end_date, venue)
    VALUES ('นิทรรศการภาพถ่าย', '2026-06-15', '2026-05-01', 'พิพิธภัณฑ์แห่งชาติ');


-- =====================================================
-- PART B: Foreign Key กับ CASCADE (ลบ/แก้ไขแบบต่อเนื่อง)
-- =====================================================

-- สร้างตัวอย่างใหม่เพื่อแสดง CASCADE

DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS library_book;
DROP TABLE IF EXISTS borrower;

CREATE TABLE borrower (
    borrowerid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE library_book (
    bookid SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    total_copies INT DEFAULT 1
);

CREATE TABLE loan (
    loanid SERIAL PRIMARY KEY,
    borrowerid INT NOT NULL,
    bookid INT NOT NULL,
    loan_date DATE DEFAULT CURRENT_DATE,
    return_date DATE,

    -- ON DELETE CASCADE: ถ้าลบ borrower → ลบ loan ที่เกี่ยวข้องด้วย
    FOREIGN KEY (borrowerid) REFERENCES borrower(borrowerid)
        ON DELETE CASCADE,

    -- ON DELETE SET NULL: ถ้าลบ book → set bookid เป็น NULL
    -- (ต้องเอา NOT NULL ออกจาก bookid ถ้าจะใช้ SET NULL)

    -- ตัวอย่างนี้ใช้ CASCADE ทั้งคู่
    FOREIGN KEY (bookid) REFERENCES library_book(bookid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        -- ON UPDATE CASCADE: ถ้าเปลี่ยน bookid → อัปเดตใน loan ด้วย
);

INSERT INTO borrower (name, email) VALUES
    ('สมศรี', 'somsri@example.com'),
    ('วิชัย', 'wichai@example.com');

INSERT INTO library_book (title) VALUES
    ('ข้างหลังภาพ'),
    ('สี่แผ่นดิน');

INSERT INTO loan (borrowerid, bookid, loan_date) VALUES
    (1, 1, '2026-01-15'),
    (1, 2, '2026-01-20'),
    (2, 1, '2026-01-18');

-- ดูข้อมูลก่อนลบ
SELECT * FROM loan;

-- ลบ borrower id=1 → loan ที่ borrowerid=1 จะถูกลบอัตโนมัติ
DELETE FROM borrower WHERE borrowerid = 1;

-- loan เหลือแค่ของ borrowerid=2
SELECT * FROM loan;

-- ----- ตัวเลือก ON DELETE -----
-- ON DELETE CASCADE    → ลบ record ที่อ้างถึงด้วย
-- ON DELETE SET NULL   → ตั้งค่า FK เป็น NULL
-- ON DELETE RESTRICT   → ห้ามลบ ถ้ายังมี record อ้างอยู่ (default)
-- ON DELETE SET DEFAULT → ตั้งค่า FK เป็น DEFAULT
-- ON DELETE NO ACTION  → เหมือน RESTRICT (ตรวจสอบท้ายสุด)


-- =====================================================
-- PART C: Views (มุมมอง / ตารางเสมือน)
-- =====================================================

-- ใช้ตาราง employee จากไฟล์ก่อนหน้า

-- ----- สร้าง View พื้นฐาน -----

-- แสดงรายชื่อพนักงานพร้อมชื่อแผนก (แทนที่จะ JOIN ทุกครั้ง)
CREATE OR REPLACE VIEW employee_detail AS
    SELECT e.employeeid,
           e.name AS employee_name,
           e.job,
           e.salary,
           d.name AS department_name
    FROM employee e
    INNER JOIN department d ON e.departmentid = d.departmentid;

-- ใช้ View เหมือนตารางปกติ
SELECT * FROM employee_detail;
SELECT * FROM employee_detail WHERE job = 'Programmer';
SELECT * FROM employee_detail ORDER BY salary DESC;

-- ----- View แสดงสรุปข้อมูล -----

CREATE OR REPLACE VIEW department_summary AS
    SELECT d.departmentid,
           d.name AS department_name,
           COUNT(e.employeeid) AS total_employees,
           COALESCE(SUM(e.salary), 0) AS total_salary,
           COALESCE(ROUND(AVG(e.salary)), 0) AS avg_salary
    FROM department d
    LEFT JOIN employee e ON d.departmentid = e.departmentid
    GROUP BY d.departmentid, d.name;

SELECT * FROM department_summary;

-- ----- View แสดง assignment พร้อมชื่อ -----

CREATE OR REPLACE VIEW assignment_detail AS
    SELECT a.workdate,
           a.hours,
           e.name AS employee_name,
           c.name AS client_name
    FROM assignment a
    INNER JOIN employee e ON a.employeeid = e.employeeid
    INNER JOIN client c ON a.clientid = c.clientid;

SELECT * FROM assignment_detail;

-- ----- View แสดงพนักงานที่เงินเดือนสูงกว่าค่าเฉลี่ย -----

CREATE OR REPLACE VIEW high_salary_employees AS
    SELECT employeeid, name, job, salary
    FROM employee
    WHERE salary > (SELECT AVG(salary) FROM employee);

SELECT * FROM high_salary_employees;

-- ----- ลบ View -----

DROP VIEW IF EXISTS high_salary_employees;

-- ----- ข้อควรรู้เกี่ยวกับ View -----
-- 1. View ไม่เก็บข้อมูลจริง — ดึงจากตารางต้นทางทุกครั้ง
-- 2. ถ้าข้อมูลในตารางเปลี่ยน View ก็เปลี่ยนตาม
-- 3. View ที่ซับซ้อน (มี JOIN, GROUP BY, DISTINCT) จะ INSERT/UPDATE ไม่ได้
-- 4. View ช่วยซ่อนความซับซ้อนของ query
-- 5. View ช่วยจำกัดการเข้าถึงข้อมูลบางคอลัมน์ (ด้านความปลอดภัย)


-- =====================================================
-- PART D: Indexes (ดัชนี)
-- =====================================================

-- ----- สร้าง Index -----

-- Index บนคอลัมน์ที่ค้นหาบ่อย
CREATE INDEX idx_employee_job ON employee(job);

-- Index บนคอลัมน์ที่ใช้ JOIN หรือ WHERE บ่อย
CREATE INDEX idx_employee_dept ON employee(departmentid);

-- Index บนหลายคอลัมน์ (Composite Index)
CREATE INDEX idx_assignment_date ON assignment(employeeid, workdate);

-- ----- ดู Index ทั้งหมดของตาราง -----

-- แสดง index ทั้งหมดในตาราง employee
SELECT indexname, indexdef
    FROM pg_indexes
    WHERE tablename = 'employee';

-- ----- ลบ Index -----

DROP INDEX IF EXISTS idx_employee_job;

-- ----- Unique Index (ค่าไม่ซ้ำ + เป็น index) -----

CREATE UNIQUE INDEX idx_member_email ON library_member(email);
    -- ทำหน้าที่เหมือน UNIQUE constraint + เพิ่มความเร็วในการค้นหา

-- ----- ข้อควรรู้เกี่ยวกับ Index -----
-- 1. Primary Key จะสร้าง index อัตโนมัติ (ไม่ต้องสร้างเอง)
-- 2. UNIQUE constraint จะสร้าง unique index อัตโนมัติ
-- 3. ควรสร้าง index บนคอลัมน์ที่:
--    - ใช้ใน WHERE บ่อย
--    - ใช้ใน JOIN บ่อย
--    - ใช้ใน ORDER BY บ่อย
-- 4. ไม่ควรสร้าง index มากเกินไป เพราะ:
--    - ใช้พื้นที่เพิ่ม
--    - INSERT/UPDATE/DELETE จะช้าลง (ต้องอัปเดต index ด้วย)
-- 5. ตารางเล็ก ๆ (ไม่กี่ร้อยแถว) ไม่จำเป็นต้องมี index เพิ่ม
