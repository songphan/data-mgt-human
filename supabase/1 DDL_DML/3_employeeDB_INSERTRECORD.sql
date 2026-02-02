-- ==============================================
-- 3. เพิ่มข้อมูล (INSERT INTO)
-- ==============================================
-- ⚠️ ต้อง INSERT ตาราง department ก่อน employee
--    เพราะ employee มี Foreign Key อ้างถึง department

-- ----- ตาราง department -----
INSERT INTO department VALUES
    (42, 'Finance'),
    (128, 'Research and development'),
    (DEFAULT, 'Human Resources'),
    (DEFAULT, 'Marketing'),
    (155, 'Business development');
    -- MySQL ใช้: Null สำหรับ AUTO_INCREMENT
    -- Supabase ใช้: DEFAULT สำหรับ SERIAL

-- ----- ตาราง employee -----
INSERT INTO employee VALUES
    (1111, 'Somchai', 'Programmer', 15000, 128),
    (DEFAULT, 'Mana', 'Sale', 12000, 155),
    (DEFAULT, 'Wichit', 'DBA', 13500, 42),
    (DEFAULT, 'Somjai', 'Programmer', 16500, 128),
    (DEFAULT, 'Aphisit', 'System administrator', 12000, 42),
    (DEFAULT, 'Somjit', 'Sale Manager', 16500, 155);
    -- MySQL ใช้: Null → Supabase ใช้: DEFAULT

-- ----- ตาราง employeeskills -----
INSERT INTO employeeskills VALUES
    (1111, 'C'),
    (1111, 'Java'),
    (1111, 'Perl'),
    (1112, 'DB2'),
    (1113, 'Java'),
    (1113, 'VB'),
    (1114, 'Linux'),
    (1114, 'NT'),
    (1115, 'PHP'),
    (1115, 'JSP');

-- ----- ตาราง client -----
INSERT INTO client VALUES
    (DEFAULT, 'ABC Company Limited', '1 Silom Rd.', 'Vera', '02-9555123'),
    (DEFAULT, 'Imperial Industry', '100 Samutprakarn', 'Mongkol', '02-9555987');

-- ----- ตาราง assignment -----
INSERT INTO assignment VALUES
    (1, 1111, '2017-04-27', 8.5),
    (2, 1112, '2017-05-26', 7);

-- ----- นำเข้าข้อมูลจากไฟล์ -----
-- MySQL:     LOAD DATA INFILE 'C:\...\table_employeeSkills.txt'
--                INTO TABLE employeeskills;
-- Supabase:  ไม่รองรับ LOAD DATA INFILE
--            วิธีนำเข้าข้อมูลจากไฟล์:
--   1) ใช้ปุ่ม "Import data via CSV" ใน Table Editor
--   2) หรือใช้คำสั่ง COPY (ต้องรันผ่าน psql CLI):
--      \copy employeeskills FROM '/path/to/file.csv' WITH (FORMAT csv, HEADER true);
