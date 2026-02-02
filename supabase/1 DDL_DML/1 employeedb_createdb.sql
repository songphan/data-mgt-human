-- ==============================================
-- 1. สร้างตาราง (CREATE TABLE)
-- ==============================================
-- Supabase: ไม่ต้องใช้ CREATE DATABASE / USE
-- เพราะแต่ละ Project ใน Supabase คือ 1 ฐานข้อมูลอยู่แล้ว
-- ให้ไปที่ SQL Editor ใน Supabase แล้วรันคำสั่งเหล่านี้

-- ----- MySQL (เดิม) -----
-- DROP DATABASE IF EXISTS Employee;
-- CREATE DATABASE Employee;
-- USE Employee;
-- ไม่จำเป็นใน Supabase

-- ลบตารางเก่า (ถ้ามี) ตามลำดับ Foreign Key
DROP TABLE IF EXISTS assignment;
DROP TABLE IF EXISTS employeeskills;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS department;

-- ตาราง department (สร้างก่อน เพราะ employee อ้างอิงถึง)
CREATE TABLE department (
    departmentid SERIAL PRIMARY KEY,
                    -- MySQL ใช้: int NOT NULL AUTO_INCREMENT
                    -- Supabase ใช้: SERIAL (นับอัตโนมัติ)
    name VARCHAR(100)
);

-- ตาราง employee
CREATE TABLE employee (
    employeeid SERIAL PRIMARY KEY,
    name VARCHAR(80),
    job VARCHAR(30),
    salary INT,
    departmentid INT NOT NULL,

    -- Foreign Key: เชื่อมกับตาราง department
    FOREIGN KEY (departmentid) REFERENCES department(departmentid)
);

-- ตาราง employeeskills (Composite Primary Key)
CREATE TABLE employeeskills (
    employeeid INT NOT NULL,
    skill VARCHAR(15) NOT NULL,

    PRIMARY KEY (employeeid, skill),

    -- Foreign Key: เชื่อมกับตาราง employee
    FOREIGN KEY (employeeid) REFERENCES employee(employeeid)
);

-- ตาราง client
CREATE TABLE client (
    clientid SERIAL PRIMARY KEY,
    name VARCHAR(40),
    address VARCHAR(100),
    contactperson VARCHAR(80),
    contactnumber CHAR(12)
);

-- ตาราง assignment (Composite Primary Key)
CREATE TABLE assignment (
    clientid INT NOT NULL,
    employeeid INT NOT NULL,
    workdate DATE NOT NULL,
    hours REAL,
                    -- MySQL ใช้: FLOAT
                    -- Supabase/PostgreSQL ใช้: REAL (เหมือนกัน)

    PRIMARY KEY (clientid, employeeid, workdate),

    -- Foreign Keys
    FOREIGN KEY (clientid) REFERENCES client(clientid),
    FOREIGN KEY (employeeid) REFERENCES employee(employeeid)
);
