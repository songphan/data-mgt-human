-- ==============================================
-- 4. แก้ไขและลบข้อมูล (UPDATE / DELETE)
-- ==============================================

-- ----- แก้ไขข้อมูล (UPDATE) -----
UPDATE employee
    SET departmentid = 130
    WHERE employeeid = 4444;
    -- ไวยากรณ์เหมือน MySQL ✓

-- ----- ลบข้อมูล (DELETE) -----
DELETE FROM department
    WHERE departmentid = 129;
    -- ไวยากรณ์เหมือน MySQL ✓
    -- ⚠️ ถ้ามี Foreign Key อ้างอิงอยู่ จะลบไม่ได้
    --    ต้องลบข้อมูลในตาราง employee ที่อ้างถึง departmentid นี้ก่อน
