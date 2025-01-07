DROP DATABASE IF EXISTS Employee;
CREATE DATABASE Employee;
USE Employee;
CREATE TABLE IF NOT EXISTS employee
	(
	employeeID int not null auto_increment,
	name varchar(80),
	job varchar(30),
	salary int,
	departmentID int not null,
	primary key(employeeID)
	);
CREATE TABLE IF NOT EXISTS department
	(
	departmentID int not null auto_increment,
	name varchar(100),
	primary key(departmentID)
	);
CREATE TABLE IF NOT EXISTS employeeskills
(
employeeID int not null,
skill varchar(15) not null,
primary key(employeeID, skill)
);
CREATE TABLE IF NOT EXISTS client
(
clientID int not null auto_increment,
name varchar(40),
address varchar(100),
contactperson varchar(80),
contactnumber char(12),
primary key(clientID)
);
CREATE TABLE IF NOT EXISTS assignment
(
clientID int not null,
employeeID int not null,
workdate date not null,
hours float,
primary key (clientID, employeeID, workdate)
);
