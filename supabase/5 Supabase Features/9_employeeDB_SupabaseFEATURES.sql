-- ==============================================
-- 9. Supabase / PostgreSQL Features
-- ==============================================
-- ฟีเจอร์เหล่านี้เป็นของ PostgreSQL ที่ MySQL ไม่มี
-- และมีประโยชน์มากเมื่อใช้งานผ่าน Supabase

-- =====================================================
-- PART A: RETURNING (ดูผลลัพธ์ทันทีหลัง INSERT/UPDATE/DELETE)
-- =====================================================

-- ปัญหา: เมื่อ INSERT ด้วย SERIAL จะไม่รู้ว่าได้ ID อะไร
-- ปกติต้อง INSERT แล้วค่อย SELECT ตามหา

-- แบบเดิม (2 คำสั่ง):
INSERT INTO department (name) VALUES ('Public Relations');
SELECT * FROM department ORDER BY departmentid DESC LIMIT 1;

-- แบบ RETURNING (คำสั่งเดียว — ได้ผลลัพธ์ทันที):
INSERT INTO department (name) VALUES ('International Affairs')
    RETURNING *;
    -- แสดงทั้งแถวที่เพิ่งใส่ พร้อม departmentid ที่สร้างอัตโนมัติ

-- RETURNING เลือกเฉพาะบางคอลัมน์ก็ได้:
INSERT INTO employee (name, job, salary, departmentid)
    VALUES ('Priya', 'Researcher', 18000, 128)
    RETURNING employeeid, name;

-- ใช้กับ UPDATE ก็ได้:
UPDATE employee SET salary = salary + 1000
    WHERE job = 'Programmer'
    RETURNING employeeid, name, salary AS new_salary;

-- ใช้กับ DELETE ก็ได้ (ดูว่าลบอะไรไป):
DELETE FROM department WHERE name = 'Public Relations'
    RETURNING *;


-- =====================================================
-- PART B: UPSERT (INSERT หรือ UPDATE อัตโนมัติ)
-- =====================================================

-- สถานการณ์: ต้องการเพิ่มข้อมูล แต่ถ้ามีอยู่แล้วให้อัปเดตแทน
-- เช่น ระบบสมาชิกห้องสมุด — ถ้า email มีแล้ว ให้อัปเดตชื่อ

DROP TABLE IF EXISTS member;
CREATE TABLE member (
    memberid SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    visit_count INT DEFAULT 1,
    last_visit DATE DEFAULT CURRENT_DATE
);

-- เพิ่มสมาชิกใหม่
INSERT INTO member (email, name) VALUES ('somsak@example.com', 'สมศักดิ์');

-- เพิ่มอีกครั้งด้วย email เดิม → ปกติจะ error (UNIQUE violation)
-- แต่ใช้ ON CONFLICT → อัปเดตแทน
INSERT INTO member (email, name)
    VALUES ('somsak@example.com', 'สมศักดิ์ ใจดี')
    ON CONFLICT (email) DO UPDATE
    SET name = EXCLUDED.name,
        visit_count = member.visit_count + 1,
        last_visit = CURRENT_DATE
    RETURNING *;
    -- EXCLUDED หมายถึง ข้อมูลที่พยายามจะ INSERT
    -- member.visit_count หมายถึง ค่าเดิมในตาราง

-- ถ้าต้องการไม่ทำอะไรเลย (skip ถ้าซ้ำ):
INSERT INTO member (email, name) VALUES ('somsak@example.com', 'สมศักดิ์')
    ON CONFLICT (email) DO NOTHING;

SELECT * FROM member;


-- =====================================================
-- PART C: CTE — Common Table Expressions (WITH ... AS)
-- =====================================================

-- CTE ช่วยแบ่ง query ซับซ้อนเป็นขั้นตอนที่อ่านง่าย
-- เหมือนการตั้งชื่อให้ subquery

-- ตัวอย่าง 1: หาพนักงานที่เงินเดือนสูงกว่าค่าเฉลี่ยของแผนกตัวเอง

WITH dept_avg AS (
    -- ขั้นตอน 1: หาค่าเฉลี่ยเงินเดือนแต่ละแผนก
    SELECT departmentid, AVG(salary) AS avg_salary
    FROM employee
    GROUP BY departmentid
)
-- ขั้นตอน 2: เปรียบเทียบเงินเดือนพนักงานกับค่าเฉลี่ยแผนก
SELECT e.name, e.salary, e.departmentid,
       ROUND(da.avg_salary) AS dept_avg_salary
FROM employee e
INNER JOIN dept_avg da ON e.departmentid = da.departmentid
WHERE e.salary > da.avg_salary;

-- ตัวอย่าง 2: หา 3 แผนกที่ใช้งบเงินเดือนมากที่สุด + แสดงพนักงาน

WITH top_departments AS (
    -- ขั้นตอน 1: หาแผนกที่ใช้งบสูงสุด 3 อันดับ
    SELECT departmentid, SUM(salary) AS total_salary
    FROM employee
    GROUP BY departmentid
    ORDER BY total_salary DESC
    LIMIT 3
)
-- ขั้นตอน 2: แสดงพนักงานในแผนกเหล่านั้น
SELECT e.name, e.job, e.salary, d.name AS department_name
FROM employee e
INNER JOIN department d ON e.departmentid = d.departmentid
WHERE e.departmentid IN (SELECT departmentid FROM top_departments);

-- ตัวอย่าง 3: CTE หลายขั้นตอน

WITH programmers AS (
    SELECT * FROM employee WHERE job = 'Programmer'
),
programmer_skills AS (
    SELECT p.name, es.skill
    FROM programmers p
    INNER JOIN employeeskills es ON p.employeeid = es.employeeid
)
SELECT * FROM programmer_skills;

-- เปรียบเทียบ CTE กับ Subquery:
-- Subquery (อ่านยาก):
SELECT name FROM employee
    WHERE departmentid IN (
        SELECT departmentid FROM employee
        GROUP BY departmentid
        HAVING COUNT(*) > 1
    );

-- CTE (อ่านง่ายกว่า):
WITH large_departments AS (
    SELECT departmentid
    FROM employee
    GROUP BY departmentid
    HAVING COUNT(*) > 1
)
SELECT name FROM employee
WHERE departmentid IN (SELECT departmentid FROM large_departments);


-- =====================================================
-- PART D: JSONB (เก็บข้อมูลกึ่งโครงสร้างในตาราง)
-- =====================================================

-- PostgreSQL สามารถเก็บ JSON ในคอลัมน์ได้
-- เหมาะกับข้อมูลที่โครงสร้างไม่แน่นอน เช่น metadata

DROP TABLE IF EXISTS digital_archive;
CREATE TABLE digital_archive (
    itemid SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    metadata JSONB
        -- JSONB = JSON แบบ Binary (ค้นหาได้เร็วกว่า JSON)
);

INSERT INTO digital_archive (title, item_type, metadata) VALUES
    ('จารึกพ่อขุนรามคำแหง',
     'inscription',
     '{"material": "stone", "era": "Sukhothai",
       "language": ["Thai", "Khmer"],
       "dimensions": {"height_cm": 111, "width_cm": 35}}'
    ),
    ('ภาพถ่ายวัดพระแก้ว พ.ศ. 2500',
     'photograph',
     '{"format": "black_and_white", "photographer": "unknown",
       "location": "Bangkok",
       "tags": ["temple", "architecture", "historical"]}'
    ),
    ('บันทึกเสียงเพลงพื้นบ้านอีสาน',
     'audio',
     '{"duration_min": 45, "format": "WAV",
       "region": "Isan",
       "performers": ["สมบัติ", "บุญมี"],
       "genre": ["folk", "morlam"]}'
    );

-- ----- ดึงค่าจาก JSONB -----

-- ใช้ -> เพื่อดึงค่า (ได้ JSON)
SELECT title, metadata -> 'material' AS material
    FROM digital_archive;

-- ใช้ ->> เพื่อดึงค่าเป็น text
SELECT title, metadata ->> 'material' AS material
    FROM digital_archive;

-- ดึงค่าซ้อน (nested)
SELECT title, metadata -> 'dimensions' ->> 'height_cm' AS height
    FROM digital_archive;

-- ----- ค้นหาด้วย JSONB -----

-- หาจากค่าใน JSONB
SELECT title FROM digital_archive
    WHERE metadata ->> 'era' = 'Sukhothai';

-- หาจาก array ใน JSONB (ใช้ @> เช็คว่า "มีค่านี้อยู่ไหม")
SELECT title FROM digital_archive
    WHERE metadata -> 'tags' @> '"temple"';

SELECT title FROM digital_archive
    WHERE metadata -> 'language' @> '"Khmer"';

-- หาจากค่าตัวเลขใน JSONB
SELECT title FROM digital_archive
    WHERE (metadata ->> 'duration_min')::INT > 30;

-- ----- เพิ่ม/แก้ไขค่าใน JSONB -----

-- เพิ่ม key ใหม่
UPDATE digital_archive
    SET metadata = metadata || '{"condition": "good"}'
    WHERE itemid = 1
    RETURNING title, metadata;

-- ลบ key
UPDATE digital_archive
    SET metadata = metadata - 'condition'
    WHERE itemid = 1;

-- ----- ข้อควรรู้เกี่ยวกับ JSONB -----
-- 1. ใช้ JSONB (ไม่ใช่ JSON) เพราะค้นหาได้เร็วกว่า
-- 2. สร้าง GIN index ได้เพื่อเพิ่มความเร็ว:
--    CREATE INDEX idx_archive_metadata ON digital_archive USING GIN (metadata);
-- 3. เหมาะกับข้อมูลที่โครงสร้างไม่แน่นอน (แต่ละ record อาจมี field ต่างกัน)
-- 4. ไม่เหมาะแทนที่ตารางปกติ — ใช้สำหรับ metadata หรือข้อมูลเสริม


-- =====================================================
-- PART E: Full-Text Search (ค้นหาข้อความเต็มรูปแบบ)
-- =====================================================

-- LIKE '%keyword%' ค้นหาได้ แต่ช้าและไม่ฉลาด
-- Full-Text Search รองรับ: คำหลายคำ, คำที่ใกล้เคียง, การจัดอันดับ

DROP TABLE IF EXISTS article;
CREATE TABLE article (
    articleid SERIAL PRIMARY KEY,
    title VARCHAR(300) NOT NULL,
    body TEXT NOT NULL,
    search_vector TSVECTOR
        -- คอลัมน์พิเศษสำหรับเก็บ "ดัชนีค้นหา"
);

INSERT INTO article (title, body) VALUES
    ('Introduction to Database Management',
     'Database management systems are essential for organizing and retrieving data efficiently. Relational databases use tables and SQL to manage structured data.'),
    ('Digital Humanities and Archives',
     'Digital humanities projects often involve managing large collections of texts, images, and metadata. Database technologies help preserve cultural heritage.'),
    ('Machine Learning in Libraries',
     'Libraries are using machine learning to improve search and cataloging. Natural language processing helps analyze texts and documents.'),
    ('Cultural Heritage Preservation',
     'Preserving cultural heritage requires careful management of digital archives. Metadata standards help organize collections across institutions.'),
    ('SQL for Humanities Research',
     'SQL provides powerful tools for querying and analyzing humanities data. Researchers use database queries to find patterns in historical texts.');

-- สร้าง search_vector จาก title + body
UPDATE article
    SET search_vector = to_tsvector('english', title || ' ' || body);

-- สร้าง GIN index เพื่อค้นหาเร็ว
CREATE INDEX idx_article_search ON article USING GIN (search_vector);

-- ----- ค้นหา -----

-- ค้นหาคำเดียว
SELECT title FROM article
    WHERE search_vector @@ to_tsquery('english', 'database');

-- ค้นหาหลายคำ (AND — ต้องมีทุกคำ)
SELECT title FROM article
    WHERE search_vector @@ to_tsquery('english', 'database & humanities');

-- ค้นหาหลายคำ (OR — มีคำใดคำหนึ่ง)
SELECT title FROM article
    WHERE search_vector @@ to_tsquery('english', 'library | archive');

-- ค้นหาโดยจัดอันดับความเกี่ยวข้อง (Ranking)
SELECT title,
       ts_rank(search_vector, to_tsquery('english', 'heritage & cultural')) AS rank
    FROM article
    WHERE search_vector @@ to_tsquery('english', 'heritage & cultural')
    ORDER BY rank DESC;

-- ค้นหาคำที่ขึ้นต้นด้วย (prefix search)
SELECT title FROM article
    WHERE search_vector @@ to_tsquery('english', 'manag:*');
    -- จะเจอ: management, managing, manage

-- ----- ข้อควรรู้เกี่ยวกับ Full-Text Search -----
-- 1. ใช้ TSVECTOR เก็บ "ดัชนีคำ" (ตัดคำ, ลบ stopwords, ทำ stemming)
-- 2. ใช้ TSQUERY สำหรับ "คำค้นหา"
-- 3. ใช้ @@ เป็นตัวเทียบ (match operator)
-- 4. สร้าง GIN index เพื่อให้ค้นหาเร็ว
-- 5. รองรับภาษาอังกฤษ (และอีกหลายภาษา) — ภาษาไทยต้องใช้ extension เพิ่ม
-- 6. เหมาะกับการค้นหาในเอกสาร, บทความ, รายการทรัพยากร


-- =====================================================
-- PART F: UUID Primary Keys (ใช้แทน SERIAL)
-- =====================================================

-- Supabase ตั้งค่า default ตาราง ใหม่ให้ใช้ UUID แทน SERIAL
-- UUID = ตัวระบุที่ไม่ซ้ำกันทั่วโลก เช่น '550e8400-e29b-41d4-a716-446655440000'

-- ข้อดีของ UUID:
-- 1. ไม่ซ้ำกันแม้ข้ามฐานข้อมูล (ดีสำหรับระบบกระจาย)
-- 2. ไม่สามารถเดา ID ถัดไปได้ (ปลอดภัยกว่า)
-- 3. สร้างฝั่ง client ได้เลย ไม่ต้องรอ server

-- ข้อเสียของ UUID:
-- 1. ใช้พื้นที่มากกว่า INT (16 bytes vs 4 bytes)
-- 2. อ่านยากกว่าตัวเลข

CREATE TABLE research_project (
    projectid UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        -- gen_random_uuid() สร้าง UUID อัตโนมัติ
    title VARCHAR(200) NOT NULL,
    lead_researcher VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO research_project (title, lead_researcher)
    VALUES ('Thai Manuscript Digitization', 'Dr. Somchai')
    RETURNING projectid, title;
    -- จะได้ projectid เป็น UUID เช่น 'a1b2c3d4-e5f6-...'

INSERT INTO research_project (title, lead_researcher)
    VALUES ('Oral History Collection', 'Dr. Wanida')
    RETURNING *;

SELECT * FROM research_project;


-- =====================================================
-- PART G: Row Level Security — RLS (ความปลอดภัยระดับแถว)
-- =====================================================

-- ⚠️ Supabase เปิด RLS เป็นค่าเริ่มต้นสำหรับตารางใหม่
-- ถ้าเปิด RLS แต่ไม่มี Policy → จะอ่าน/เขียนข้อมูลผ่าน API ไม่ได้
-- (แต่ยังใช้ได้ปกติผ่าน SQL Editor เพราะเป็น admin)

-- ----- เปิด RLS -----
ALTER TABLE research_project ENABLE ROW LEVEL SECURITY;

-- ----- สร้าง Policy: อนุญาตทุกคนอ่านได้ -----
CREATE POLICY "Allow public read"
    ON research_project
    FOR SELECT
    USING (true);
    -- USING (true) = ทุกแถวผ่านเงื่อนไข = อ่านได้ทั้งหมด

-- ----- สร้าง Policy: อนุญาตเฉพาะ authenticated users INSERT -----
CREATE POLICY "Allow authenticated insert"
    ON research_project
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');
    -- auth.role() เป็นฟังก์ชันของ Supabase
    -- ตรวจสอบว่าผู้ใช้ล็อกอินแล้วหรือยัง

-- ----- ดู Policy ทั้งหมด -----
SELECT policyname, cmd, qual
    FROM pg_policies
    WHERE tablename = 'research_project';

-- ----- ลบ Policy -----
DROP POLICY IF EXISTS "Allow public read" ON research_project;

-- ----- ปิด RLS (กลับไปเข้าถึงได้ทั้งหมด) -----
ALTER TABLE research_project DISABLE ROW LEVEL SECURITY;

-- ----- ข้อควรรู้เกี่ยวกับ RLS -----
-- 1. Supabase เปิด RLS อัตโนมัติเมื่อสร้างตารางผ่าน Dashboard
-- 2. ถ้าเปิด RLS แต่ไม่มี Policy → ไม่มีใครเข้าถึงได้ (ผ่าน API)
-- 3. SQL Editor ใน Supabase ทำงานเป็น admin → ไม่ถูก RLS บังคับ
-- 4. Policy แบบ SELECT ใช้ USING (เงื่อนไขอ่าน)
-- 5. Policy แบบ INSERT ใช้ WITH CHECK (เงื่อนไขเขียน)
-- 6. สำคัญมากเมื่อสร้าง Web App ที่เชื่อมกับ Supabase ผ่าน API


-- =====================================================
-- PART H: TIMESTAMPTZ (วันเวลาพร้อม Timezone)
-- =====================================================

-- Supabase ใช้ TIMESTAMPTZ เป็น default (ไม่ใช่ TIMESTAMP)
-- TIMESTAMPTZ = เก็บเวลาเป็น UTC แล้วแปลงตาม timezone ของผู้ใช้

-- เปรียบเทียบ TIMESTAMP กับ TIMESTAMPTZ:
SELECT
    NOW()::TIMESTAMP AS without_timezone,
    NOW()::TIMESTAMPTZ AS with_timezone;

-- ตั้ง timezone แล้วดูผล:
SET timezone = 'Asia/Bangkok';
SELECT NOW() AS bangkok_time;

SET timezone = 'America/New_York';
SELECT NOW() AS newyork_time;

-- กลับเป็น UTC:
SET timezone = 'UTC';
SELECT NOW() AS utc_time;

-- ----- ข้อควรรู้ -----
-- 1. ใช้ TIMESTAMPTZ เสมอ (ไม่ใช่ TIMESTAMP) เมื่อเก็บเวลาจริง
-- 2. Supabase เก็บเป็น UTC อยู่เบื้องหลัง
-- 3. แปลงเป็น timezone ที่ต้องการด้วย AT TIME ZONE:
SELECT NOW() AT TIME ZONE 'Asia/Bangkok' AS bangkok_time;
