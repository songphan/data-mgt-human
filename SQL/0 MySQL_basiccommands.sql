--LOGIN:

cd\
cd xampp\mysql\bin
mysql -u root -p
--OR:
mysql -u <username> -p

--LISTING ALL DATABASES IN THE SYSTEM:

show databases;

--CHOOSING A DATABASE TO WORK WITH:

use <databasename>;

--SHOW ALL TABLES:

show tables;

--SHOW A TABLE STRUCTURE/DATA DICTIONARY:

show columns from <tablename>;
--OR:
describe tablename;

--LOGOUT:
exit;
--OR:
\q

