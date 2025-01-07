INSERT INTO employee VALUES 
	(1111, 'Somchai', 'Programmer', 15000, 128),
	(Null, 'Mana', 'Sale', 12000, 155),
	(Null, 'Wichit', 'DBA', 13500, 42),
	(Null, 'Somjai', 'Programmer', 16500, 128),
	(Null, 'Aphisit', 'System administrator', 12000, 42),
	(Null, 'Somjit', 'Sale Manager', 16500, 155);
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
INSERT INTO department VALUES
	(42, 'Finance'),
	(128, 'Research and development'),
	(Null, 'Human Resources'),
	(Null, 'Marketing'),
	(155, 'Business development');
INSERT INTO client VALUES
	(Null, 'ABC Company Limited', '1 Silom Rd.', 'Vera', '02-9555123'),
	(Null, 'Imperial Industry', '100 Samutprakarn', 'Mongkol', '02-9555987');
INSERT INTO assignment VALUES
	(1, 1111, '2017-04-27', 8.5),
	(2, 1112, '2017-05-26', 7);
LOAD DATA INFILE 'C:\Users\songp\Desktop\table_employeeSkills.txt'
	INTO TABLE employeeskills;