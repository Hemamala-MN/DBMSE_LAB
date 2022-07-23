create database supplier;
use supplier;

create table Supplier(sid int, sname varchar(40), address varchar(40));
alter table Supplier add primary key(sid);
desc Supplier;

create table Parts(pid int primary key, pname varchar(40), color varchar(40));
desc Parts;

create table Catalog(sid int, pid int, cost real, foreign key (sid) references Supplier(sid), foreign key (pid) references Parts(pid));
desc Catalog;

insert into Supplier values(10001, 'Acme Widget', 'Bangalore'), (10002, 'John', 'Kolkata'), (10003, 'Vimal', 'Mumbai'), (10004, 'Reliance', 'Delhi');
select * from Supplier;

insert into Parts values(20001, 'Book', 'Red'), (20002, 'Pen', 'Red'), (20003, 'Pencil', 'Green'), (20004, 'Mobile', 'Green'), (20005, 'Charger', 'Black');
select * from Parts;

insert into Catalog values(10001,20001,10), (10001,20002,10), (10001,20003,30), (10001,20004,10), (10001,20005,10),(10002,20001,10),(10002,20002,20),(10003,20003,30),(10004,20003,40);
select * from Catalog;

-- i.Find the pnames of parts for which there is some supplier.
select distinct P.pname from Parts P, Catalog C where C.pid = P.pid;

select pname from Parts where exists (select Catalog.pid from Catalog where Parts.pid=Catalog.pid);

-- ii. Find the snames of suppliers who supply every part.

select sname from Supplier where sid in(select sid from Catalog group by sid having count(sid) = (select count(*) from Parts));

-- iii. Find the snames of supliers who supply every red part.

select sname from Supplier where sid in (select sid from Catalog where pid in (select pid from Parts where color='red'));

-- iv.Find the pnames of parts supplied by Acme widget Suppliers and no one else.

select P.pname from Parts P, Catalog C, Supplier S where P.pid=C.pid and C.sid = S.sid and S.sname='Acme Widget' and not exists(select * from Catalog c1, Supplier s1 where P.pid = c1.pid and c1.sid = s1.sid and s1.sname <> 'Acme Widget'); 

-- v. Find the sid's of suppliers who charge more for some part than the average cost of that part(averaged over all the suppliers who supply that part).

select distinct sid from Catalog c where cost > (select avg(c1.cost) from Catalog c1 where c1.pid = c.pid);

-- vi.For each part , find the snames of the supplier who charges the most for that part. 

select P.pid, S.sname from Parts P, Supplier S, Catalog C where C.pid = P.pid and C.sid = S.sid and C.cost = (select MAX(c1.cost) from Catalog c1 where c1.pid = P.pid);

-- ivii. Find the sid's of Suppliers who supply only red parts.

select sid from Catalog where pid in (select distinct (pid) from Parts where color = 'red');
-- Not in (select distinct (pid) from Parts where color <> 'red'));