--Delete database:

drop database employee;

--Drop table:

drop tabel department;

--Change table name:

alter table department rename to newdepartment;

--Change data type of an attribute or a field:

alter table department modify name text;

--Change an attribute name:

alter table department change name dept_name varchar(30);

--Add an attribute:

alter table employee add picture blob;