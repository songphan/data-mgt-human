-- ==============================================
-- 7. Triggers (ทริกเกอร์)
-- ==============================================
-- ⚠️ ความแตกต่างหลักระหว่าง MySQL กับ PostgreSQL:
--   MySQL:      โค้ด trigger เขียนตรงใน CREATE TRIGGER ได้เลย
--   PostgreSQL: ต้องสร้าง FUNCTION แยกก่อน แล้วค่อยผูกกับ TRIGGER
--   - BEFORE trigger ต้อง RETURN NEW
--   - AFTER DELETE trigger ต้อง RETURN OLD

-- =====================================================
-- Example 1: ตรวจสอบค่า percent ก่อน INSERT
-- =====================================================

DROP TABLE IF EXISTS t;
CREATE TABLE t(
    percent INT,
    date TIMESTAMP
);

-- ขั้นตอนที่ 1: สร้าง Trigger Function
CREATE OR REPLACE FUNCTION check_percent_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.date := NOW();
    IF NEW.percent < 0 THEN
        NEW.percent := 0;
    ELSIF NEW.percent > 100 THEN
        NEW.percent := 100;
    END IF;
    RETURN NEW;
END;
$$;

-- ขั้นตอนที่ 2: ผูก Function กับ Trigger
CREATE TRIGGER check_percent
    BEFORE INSERT ON t
    FOR EACH ROW
    EXECUTE FUNCTION check_percent_func();

INSERT INTO t(percent) VALUES(-5);
INSERT INTO t(percent) VALUES(45);
INSERT INTO t(percent) VALUES(150);
SELECT * FROM t;

-- =====================================================
-- Example 2: INSERT/DELETE ข้ามตาราง
-- =====================================================

DROP TABLE IF EXISTS test1, test2, test3;
CREATE TABLE test1(a1 INT);
CREATE TABLE test2(a2 INT);
CREATE TABLE test3(a3 SERIAL PRIMARY KEY);

-- สร้าง Trigger Function
CREATE OR REPLACE FUNCTION testref_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO test2 VALUES(NEW.a1);
    DELETE FROM test3 WHERE a3 = NEW.a1;
    RETURN NEW;
END;
$$;

-- ผูก Trigger
CREATE TRIGGER testref
    BEFORE INSERT ON test1
    FOR EACH ROW
    EXECUTE FUNCTION testref_func();

INSERT INTO test3(a3) VALUES
    (DEFAULT), (DEFAULT), (DEFAULT), (DEFAULT), (DEFAULT),
    (DEFAULT), (DEFAULT), (DEFAULT), (DEFAULT), (DEFAULT);

INSERT INTO test1 VALUES (1), (3), (1), (7), (1), (8), (4), (4);
SELECT * FROM test1;
SELECT * FROM test2;
SELECT * FROM test3;

-- =====================================================
-- Example 3: บันทึก Log เมื่อลบข้อมูล
-- =====================================================

DROP TABLE IF EXISTS customer_log;
DROP TABLE IF EXISTS customer;

CREATE TABLE customer(
    id INT,
    name VARCHAR(30),
    address VARCHAR(50),
    email VARCHAR(25),
    tel VARCHAR(15)
);

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
    time_insert TIME
);

SELECT * FROM customer_log;

-- สร้าง Trigger Function (ใช้ OLD.* เพราะเป็น AFTER DELETE)
CREATE OR REPLACE FUNCTION customer_trigger_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO customer_log
        VALUES(OLD.id, OLD.name, OLD.address, OLD.email, OLD.tel,
               CURRENT_DATE, CURRENT_TIME);
    RETURN OLD;
END;
$$;

-- ผูก Trigger
CREATE TRIGGER customer_trigger
    AFTER DELETE ON customer
    FOR EACH ROW
    EXECUTE FUNCTION customer_trigger_func();

DELETE FROM customer WHERE id = 2;
SELECT * FROM customer_log;
