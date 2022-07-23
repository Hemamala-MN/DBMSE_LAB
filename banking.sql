create database banking;
use banking;

create table Branch(BranchName varchar(40), BranchCity varchar(40), Assets int);
alter table Branch add primary key(BranchName);
desc Branch;

create table BankAccount(AccountNo int, BranchName varchar(40), Balance int, foreign key(BranchName) references Branch(BranchName));
alter table BankAccount add primary key(AccountNo);
desc BankAccount;

create table BankCustomer(CustomerName varchar(40) primary key, CustomerStreet varchar(40), CustomerCity varchar(40));
desc BankCustomer;

create table Loan(LoanNumber int primary key, BranchName varchar(40), Amount int, foreign key (BranchName) references Branch(BranchName));
desc Loan;

create table Depositor(CustomerName varchar(40), AccountNo int, foreign key(CustomerName) references BankCustomer(CustomerName), foreign key (AccountNo) references BankAccount(AccountNo));
desc Depositor;

insert into Branch values('SBI_chamrajpet','Bangalore',50000),('SBI_residencyRoad','Bangalore',10000),('SBI_shivajiRoad','Bombay',20000),('SBI_parlimentRoad','Delhi',10000),('SBI_jantarmantar','Delhi',20000);
select * from Branch order by BranchCity;

insert into BankAccount values(1,'SBI_chamrajpet',20000),(2,'SBI_residencyRoad',5000),(3,'SBI_shivajiRoad',6000),(4,'SBI_parlimentRoad',9000),(5,'SBI_jantarmantar',8000),(6,'SBI_shivajiRoad',4000),(8,'SBI_residencyRoad',4000),(9,'SBI_parlimentRoad',3000),(10,'SBI_residencyRoad',5000),(11,'SBI_jantarmantar',2000);
select * from BankAccount;

insert into BankCustomer values('Mohan','National college road','Bangalore'),('Avinash','Bull Temple Road','Bangalore'),('Kriti','PrithviRaj road','Delhi'),('Dinesh','Bannerjata road','Delhi'),('Nikhil','Akbar road','Delhi');
select * from BankCustomer;

insert into Depositor values('Avinash',1),('Dinesh',2),('Kriti',4),('Mohan',5),('Nikhil',8),('Avinash',9),('Dinesh',10),('Nikhil',11);
select * from Depositor;

insert into Loan values(1,'SBI_chamrajpet',1000),(2,'SBI_residencyRoad',2000),(3,'SBI_shivajiRoad',3000),(4,'SBI_parlimentRoad',4000),(5,'SBI_jantarmantar',5000);
select * from Loan;

 -- iii. Find all the customers who have at least two accounts at the Main branch.

select CustomerName from Depositor where AccountNo in (select AccountNo from BankAccount group by BranchName) group by CustomerName having count(*)>1;

  -- iv. Find all the customers who have an account at all the branches located in a specific city.

select distinct CustomerName from Depositor where AccountNo in(select AccountNo from BankAccount where BranchName in (select BranchName from Branch where BranchCity='Bangalore')) group by CustomerName having count(distinct AccountNo)>=(select count(*) from Branch where BranchCity='Bangalore');