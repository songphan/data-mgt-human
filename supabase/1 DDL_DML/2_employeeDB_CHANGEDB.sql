-- ==============================================
-- 2. แก้ไขโครงสร้างตาราง (ALTER TABLE / DROP)
-- ==============================================

-- ลบฐานข้อมูล (ไม่ใช้ใน Supabase)
-- MySQL:     DROP DATABASE employee;
-- Supabase:  ไม่มีคำสั่งนี้ — ถ้าต้องการลบทั้งโปรเจกต์
--            ให้ไปที่ Settings > General > Delete Project

-- ----- ลบตาราง (DROP TABLE) -----
DROP TABLE department;
    -- MySQL เดิมมี typo: "drop tabel" → ที่ถูกคือ "drop table"

-- ----- เปลี่ยนชื่อตาราง (RENAME) -----
ALTER TABLE department RENAME TO newdepartment;
    -- เหมือน MySQL ✓

-- ----- เปลี่ยนชนิดข้อมูลของคอลัมน์ -----
-- MySQL:     ALTER TABLE department MODIFY name TEXT;
-- Supabase:
ALTER TABLE department
    ALTER COLUMN name TYPE TEXT;

-- ----- เปลี่ยนชื่อคอลัมน์ -----
-- MySQL:     ALTER TABLE department CHANGE name dept_name VARCHAR(30);
-- Supabase:  แยกเป็น 2 คำสั่ง
--   1) เปลี่ยนชื่อ
ALTER TABLE department
    RENAME COLUMN name TO dept_name;
--   2) เปลี่ยนชนิดข้อมูล (ถ้าต้องการ)
ALTER TABLE department
    ALTER COLUMN dept_name TYPE VARCHAR(30);

-- ----- เพิ่มคอลัมน์ใหม่ -----
-- MySQL:     ALTER TABLE employee ADD picture BLOB;
-- Supabase:
ALTER TABLE employee ADD COLUMN picture BYTEA;
    -- MySQL ใช้: BLOB
    -- Supabase/PostgreSQL ใช้: BYTEA (Binary Data)
