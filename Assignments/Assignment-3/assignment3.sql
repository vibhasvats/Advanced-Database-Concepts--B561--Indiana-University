-- Creating database with my initials
create database assignment3vkvats;

-- connecting database
\c assignment3vkvats;

CREATE TABLE Student(
	sid INT PRIMARY KEY,
	sname TEXT
	);
	
CREATE TABLE Book(
	bookno INT PRIMARY KEY,
	title text,
	price INT 
	);
	
CREATE TABLE major(
	sid INT,
	major text,
	PRIMARY KEY(sid, major),
	FOREIGN KEY (sid) REFERENCES Student(sid)
	);
	
CREATE TABLE cites(
	bookno INT,
	citedbookno INT,
	PRIMARY KEY(bookno, citedbookno),
	FOREIGN KEY (bookno) REFERENCES Book(bookno),
	FOREIGN KEY (citedbookno) REFERENCES Book(bookno)
	);
	
CREATE TABLE buys(
	sid INT,
	bookno INT,
	PRIMARY KEY(sid, bookno),
	FOREIGN KEY (sid) REFERENCES student(sid),
	FOREIGN KEY (bookno) REFERENCES Book(bookno)
	);
	
-- Populating tables

INSERT INTO student VALUES
(1001,'Jean'),
(1002,'Maria'),
(1003,'Anna'),
(1004,'Chin'),
(1005,'John'),
(1006,'Ryan'),
(1007,'Catherine'),
(1008,'Emma'),
(1009,'Jan'),
(1010,'Linda'),
(1011,'Nick'),
(1012,'Eric'),
(1013,'Lisa'),
(1014,'Filip'),
(1015,'Dirk'),
(1016,'Mary'),
(1017,'Ellen'),
(1020,'Ahmed'),
(1021, 'Kris');

-- Data for the book relation.
INSERT INTO book VALUES
(2001,'Databases',40),
(2002,'Operati,gSystems',25),
(2003,'Network,',20),
(2004,'AI',45),
(2005,'Discrete,athematics',20),
(2006,'SQL',25),
(2007,'ProgrammingLanguages',15),
(2008,'DataScience',50),
(2009,'Calculus',10),
(2010,'Philosophy',25),
(2012,'Geometry',80),
(2013,'RealAnalysis',35),
(2011,'Anthropology',50),
(3000,'MachineLearning',40),
(4001, 'LinearAlgebra', 30),
(4002, 'MeasureTheory', 75),
(4003, 'OptimizationTheory', 30);

-- Data for the major relation.

INSERT INTO major VALUES
(1001,'Math'),
(1001,'Physics'),
(1002,'CS'),
(1002,'Math'),
(1003,'Math'),
(1004,'CS'),
(1006,'CS'),
(1007,'CS'),
(1007,'Physics'),
(1008,'Physics'),
(1009,'Biology'),
(1010,'Biology'),
(1011,'CS'),
(1011,'Math'),
(1012,'CS'),
(1013,'CS'),
(1013,'Psychology'),
(1014,'Theater'),
(1017,'Anthropology'),
(1021, 'CS'), 
(1021, 'Math');

-- Data for the buys relation.

INSERT INTO buys VALUES
(1001,2002),
(1001,2007),
(1001,2009),
(1001,2011),
(1001,2013),
(1002,2001),
(1002,2002),
(1002,2007),
(1002,2011),
(1002,2012),
(1002,2013),
(1003,2002),
(1003,2007),
(1003,2011),
(1003,2012),
(1003,2013),
(1004,2006),
(1004,2007),
(1004,2008),
(1004,2011),
(1004,2012),
(1004,2013),
(1005,2007),
(1005,2011),
(1005,2012),
(1005,2013),
(1006,2006),
(1006,2007),
(1006,2008),
(1006,2011),
(1006,2012),
(1006,2013),
(1007,2001),
(1007,2002),
(1007,2003),
(1007,2007),
(1007,2008),
(1007,2009),
(1007,2010),
(1007,2011),
(1007,2012),
(1007,2013),
(1008,2007),
(1008,2011),
(1008,2012),
(1008,2013),
(1009,2001),
(1009,2002),
(1009,2011),
(1009,2012),
(1009,2013),
(1010,2001),
(1010,2002),
(1010,2003),
(1010,2011),
(1010,2012),
(1010,2013),
(1011,2002),
(1011,2011),
(1011,2012),
(1012,2011),
(1012,2012),
(1013,2001),
(1013,2011),
(1013,2012),
(1014,2008),
(1014,2011),
(1014,2012),
(1017,2001),
(1017,2002),
(1017,2003),
(1017,2008),
(1017,2012),
(1020,2012),
(1001,3000),
(1001,2004),
(1021, 2001),
(1021, 2002),
(1021, 2003),
(1021, 2004),
(1021, 2005),
(1021, 2006),
(1021, 2007),
(1021, 2008),
(1021, 2009),
(1021, 2010),
(1021, 2011),
(1021, 4003),
(1021, 4001),
(1021, 4002),
(1015, 2001),
(1015, 2002),
(1016, 2001),
(1016, 2002),
(1015, 2004),
(1015, 2008),
(1015, 2012),
(1015, 2011),
(1015, 3000),
(1016, 2004),
(1016, 2008),
(1016, 2012),
(1016, 2011),
(1016, 3000),
(1002, 4003),
(1011, 4003),
(1015, 4003),
(1015, 4001),
(1015, 4002),
(1016, 4001),
(1016, 4002);

-- Data for the cites relation.
INSERT INTO cites VALUES(2012,2001),
(2008,2011),
(2008,2012),
(2001,2002),
(2001,2007),
(2002,2003),
(2003,2001),
(2003,2004),
(2003,2002),
(2012,2005);

---------------- solutions -------------------
\qecho ''
\qecho ''
\qecho 'Question 1.a'
\qecho ''
\qecho ''
create table setA(
	e1 int
);
create table setB(
	e2 int
);

insert into setA values 
(1),
(2),
(3),
(4),
(5);

insert into setB values 
(1),
(2),
(3);
-- creating related views.
create view setAminusSetB as 
	select e1 
	from setA 
	except 
	select e2 
	from setB;

create view setBminusSetA as 
	select e2 
	from setB
	except
	select e1 
	from setA;

create view AintersectB as 
	select e1 
	from setA
	intersect 
	select e2 
	from setB;

select (select not exists(select e1
					from setAminusSetB) as empty_a_minus_b), 
		(select not exists(select e2 
					from setBminusSetA) as empty_b_minus_a),
		(select not exists(select e1 
					from AintersectB) as empty_a_intersection_b);

drop view setAminusSetB, setBminusSetA, AintersectB;

\qecho ''
\qecho ''
\qecho 'Question 1.b'
\qecho ''
\qecho ''
-- A intersect B written with IN clause
create view AinB as 
	select a.e1 
	from setA a
	where a.e1 in (select b.e2 
				 from setB b);
-- A except B written with NOT IN clause
create view AnotinB as 
	select a.e1 
	from setA a
	where a.e1 not in (select b.e2 
				 		from setB b);
-- B except A written with NOT IN clause
create view BnotinA as 
	select b.e2 
	from setB b 
	where b.e2 not in (select a.e1 
					  from setA a);
--main query using those views.
select (select not exists(select e1
					from AnotinB) as empty_a_minus_b), 
		(select not exists(select e2 
					from BnotinA) as empty_b_minus_a),
		(select not exists(select e1 
					from AinB) as empty_a_intersection_b);

drop view ainb, anotinb, bnotina;
drop table setA, setB;


\qecho ''
\qecho ''
\qecho 'Question 2'
\qecho ''
\qecho ''

create table p(
	value boolean
);
create table q(
	value boolean
);
create table r(
	value boolean
);

insert into p values 
(TRUE),
(FALSE),
(NULL);
insert into q values 
(TRUE),
(FALSE),
(NULL);
insert into r values 
(TRUE),
(FALSE),
(NULL);

/*The fourth column that I am selecting is predicate logic statement of the question asked.*/
select p.value as p, 
	q.value as q,
	r.value as r, 
	(select (p.value and not q.value) or not r.value) as value
from p p, q q, r r;

drop table p, q, r;

\qecho ''
\qecho ''
\qecho 'Question 3.a'
\qecho ''
\qecho ''
create table point(
	pid int,
	x float,
	y float
);

insert into point values
(1, 0, 0),
(2, 0, 1),
(3, 1, 0),
(4, 1, 2),
(6, 5, 6);
-- a function that calculates the distance between the given two points.
create function distance ( x1 float, y1 float, x2 float, y2 float) 
returns float as 
$$
	select sqrt( power(x1-x2,2) + power(y1-y2, 2));
$$ language sql;
-- a view that calculates the distance between two points where points.
create view distanceBetweenPoint as 
	select p1.pid as p1, 
		p2.pid as p2,
		distance(p1.x, p1.y, p2.x, p2.y) 
	from point p1, point p2
	where p1.pid <> p2.pid;
-- here i am just selecting those points which is required by our condition.
select t.p1, t.p2
from distanceBetweenPoint t
where t.distance <=all (select t2.distance 
					   from distanceBetweenPoint t2);

drop view distanceBetweenPoint;
drop function distance;
----------- alternate solution ----------
create view distance as 
	select p1.pid as p1, p2.pid as p2, (sqrt(power(p1.x-p2.x,2) + power(p1.y-p2.y,2))) as distance 
	from point p1, point p2 
	where p1.pid <> p2.pid;
select d.p1, d.p2 
from distance d 
where d.distance <= all(select d2.distance 
					   from distance d2);
-----------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 3.b'
\qecho ''
\qecho ''
-- area of triangle formed by the three points should be zero for collinear points.
-- this function calculates the area of triangle formed by three points.
create function areaOfTraingle( x1 float, y1 float, x2 float, y2 float, x3 float, y3 float) 
returns table(area float) as 
$$
	select (select abs((select x1 - x2)*(select y2 - y3) - (select x2 -x3)*(select y1 - y2))) as area;
$$ language sql;

/*For three different points I calculate the ares of the triangle formed by those points and then 
select those triplets which gives area zero, those will the points that satisfy collinearity*/
select p1.pid, p2.pid, p3.pid 
from point p1, point p2, point p3 
where p1.pid <> p2.pid and 
	p2.pid <> p3.pid and 
	p1.pid <> p3.pid and 
	exists (select * 
			from areaOfTraingle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y) 
			   where area = 0);

drop function areaOfTraingle;
drop table point;

\qecho ''
\qecho ''
\qecho 'Question 4.a'
\qecho ''
\qecho ''
create table R
	(A int,
	B int,
	c int
);
insert into r values
(1, 2, 3),
(2, 2, 4),
(3, 3, 4),
(4, 3, 4),
(2, 2, 4);

/*converting bag of relation into set relation as this 
operation has to be performed on set relation*/ 

/* converting to set from bag also removes the possibility that
for same value of attribute B and C, we wont have repeated value of attribute 
A, so we won't be checking that*/

/* I just listed down all cases from truth table to cover all cases keeping condition that A is same 
case 1 : when B and C are different 
case 2: when B is similar but C is different
case 3: when B is different and C is same
this covers all cases and checks for primary key*/
with setR as 
	(select distinct r.a, r.b, r.c 
	from R r)
select not exists(select *
				 from setr r1, setr r2
				 where r1.a = r2.a and 
				 	((r1.b <> r2.c and r1.c <> r2.c) or 
					(r1.b = r2.b and r1.c <> r2.c) or 
					(r1.b <> r2.b and r1.c = r2.c))) as isprimaryKey;

delete from r;

\qecho ''
\qecho ''
\qecho 'Question 4.b'
\qecho ''
\qecho ''

\qecho 'Where A is a primary key'
insert into r values
(1, 2, 3),
(2, 2, 3),
(3, 3, 4),
(4, 3, 5),
(5, 6, 5);
--converting bag of relation into set relation
with setR as 
	(select distinct r.a, r.b, r.c 
	from R r)
select not exists(select *
				 from setr r1, setr r2
				 where r1.a = r2.a and 
				 	((r1.b <> r2.c and r1.c <> r2.c) or 
					(r1.b = r2.b and r1.c <> r2.c) or 
					(r1.b <> r2.b and r1.c = r2.c))) as isprimaryKey;

delete from r;
\qecho 'Where A is not a primary key'
insert into r values
(1, 2, 3),
(2, 2, 3),
(3, 3, 4),
(4, 3, 5),
(4, 6, 5);
--converting bag of relation into set relation
with setR as 
	(select distinct r.a, r.b, r.c 
	from R r)
select not exists(select *
				 from setr r1, setr r2
				 where r1.a = r2.a and 
				 	((r1.b <> r2.c and r1.c <> r2.c) or 
					(r1.b = r2.b and r1.c <> r2.c) or 
					(r1.b <> r2.b and r1.c = r2.c))) as isprimaryKey;
					
drop table r;
\qecho ''
\qecho ''
\qecho 'Question 5'
\qecho ''
\qecho ''
create table M (
	row int,
	colmn int,
	value int
);
insert into M values
(1,1,1),
(1,2,2),
(1,3,3),
(2,1,1),
(2,2,-3),
(2,3,5),
(3,1,4),
(3,2,0),
(3,3,-2);
/* created a function that returns setof record( can also use view for same) the set of records will 
give the calcualtion of M^2*/
create function m2(OUT row1 int, OUT colmn int, OUT value bigint) 
RETURNS SETOF RECORD
as $$
  select m1.row row1, m2.colmn as colmn, sum(m1.value * m2.value) as value
  from m m1, m m2 
  where m1.colmn = m2.row 
  group by (m1.row, m2.colmn);
  $$ language sql;
/*Using the m2 function, i do the same operation once again on m2 to get m^4*/
select m1.row1 as row, m2.colmn as colmn, sum(m1.value * m2.value) as value 
from m2() m1, m2() m2 
where m1.colmn = m2.row1
group by(m1.row1, m2.colmn) 
order by(m1.row1, m2.colmn);

drop function m2;
drop table m;

\qecho ''
\qecho ''
\qecho 'Question 6'
\qecho ''
\qecho ''
create table A(
X int);
insert into A values
(0),(1),(2),(3),(4),(5),(6),(7),(30),(31),(12),(23),(35),(44),(58),(69),(72),
(30),(31),(-1),(-2),(-3),(-4),(-5),(-6),(-7),(-30),(-31),(-12),(-23),(-35),
(-44),(-58),(-69),(-72);
/*for the realation A, I have taken mode by 4 and then have goup by on mode values which
ranges from 0 to 3.*/

select (select mod(abs(a.x),4)) as RemainderValue, count(1) as noofElementInA
from A a
group by(RemainderValue)
order by(RemainderValue);

delete from A;
------------Alternate solution ------------------
select mod(abs(a.x),4) as modValue, count(1) as elements
from a a 
group by(modValue);
------------------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 7'
\qecho ''
\qecho ''

insert into A values
(0),(1),(2),(3),(4),(5),(6),(7),(30),(31),(12),(23),(35),(44),(58),(69),(72),
(30),(31), (0),(1),(2),(3),(4),(5),(6),(7),(30),(31),(12),(23),(35),(44),(58),(69),(72),
(30),(31),(0),(1),(2),(3),(4),(5),(6),(7),(30),(31),(12),(23),(35),(44),(58),(69),(72),
(30),(31);
/*Grouping by the value of A.x all repeated tuples will be stored in different boxes and 
then selected the attribute A.a*/
select a.x 
from A a 
group by a.x
order by a.x;

drop table A;
\qecho ''
\qecho ''
\qecho 'Question 8.a'
\qecho ''
\qecho ''
/*created a view which selects the books bought by CS students*/
create view booksByCS as 
	select distinct b.bookno, m.sid  
	from buys b, major m
	where b.sid = m.sid and 
		m.major = 'CS';
/*Then i select the book that satisfies all the stated condition */
select bk.bookno, bk.title 
from book bk 
where bk.bookno in (select bk1.bookno
					from booksbycs bk1 
					group by(bk1.bookno) 
					having count(1)<3) and 
	bk.price < 40;

drop view booksByCS;
--------------Alternate solutions ------------
select bk.bookno, bk.title 
from book bk 
where bk.price < 40 and 
(select count(1)
 from (select s.sid 
		from student s, buys b, major m 
		where bk.bookno = b.bookno and 
			b.sid = s.sid and 
			s.sid = m.sid and 
			m.major = 'CS') q) <3;
--------------------------------------------
select bk.bookno, bk.title 
from book bk 
where bk.price < 40 and 
(select count(1) 
from (select b.sid 
	 from buys b 
	 where b.bookno = bk.bookno 
	 intersect 
	 select m.sid 
	 from major m 
	 where m.major= 'CS') q) < 3;

--------------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 8.b'
\qecho ''
\qecho ''
/*I grouped by sid and sname and applied the condition to check the cost to be less than 200
and then also took the count of it, then i took union with those students who did not buy any books
because technically they satisfy the condition.*/

select s.sid, s.sname, count(1) as numberofbooksbought
from buys b, book bk, student s 
where b.bookno = bk.bookno and 
	s.sid = b.sid
group by(s.sid, s.sname) 
having sum(bk.price)< 200
union 
select s.sid, s.sname, 0 as numberofbooksbought
from student s 
where s.sid NOT IN (select b.sid 
				   from buys b)
order by(numberofbooksbought) desc;

\qecho ''
\qecho ''
\qecho 'Question 8.c'
\qecho ''
\qecho ''
/*made a view that calculates the total cost of books bought by each students.*/
create view collectivebookcost as 
	select b.sid, s.sname, sum(bk.price) as collectivecost 
	from buys b, student s, book bk 
	where b.sid = s.sid and 
	 b.bookno = bk.bookno
	group by(b.sid, s.sname);

/*selected the top buyers from that view. could also use MAX() but this is more robust technique and i 
have already used aggregrat function in calulating the view above.*/
select bkc.sid, bkc.sname
from collectivebookcost bkc
where bkc.collectivecost >=all ( select collectivecost 
							  from collectivebookcost);

drop view collectivebookcost;

\qecho ''
\qecho ''
\qecho 'Question 8.d'
\qecho ''
\qecho ''
/*group by major was important part and then just took the sum of books bought*/
select m.major, sum(bk.price) as cost
from buys b, book bk, major m 
where b.sid = m.sid and 
	b.bookno = bk.bookno 
	group by(m.major)
	order by m.major;
	
\qecho ''
\qecho ''
\qecho 'Question 8.e'
\qecho ''
\qecho ''
/*a view that calculates the count of CS students for each book*/
create view CSstudentCountPerBook as 
	select  b.bookno, count(1) as noofstudents
	from buys b, major m
	where b.sid = m.sid and 
		m.major = 'CS' 
		group by(b.bookno);
/*then selected the books that has same counts of CS students using the view.*/
select t1.bookno, t2.bookno 
from CSstudentCountPerBook t1, CSstudentCountPerBook t2 
where t1.bookno <> t2.bookno and 
	t1.noofstudents = t2.noofstudents;

drop view CSstudentCountPerBook;

\qecho ''
\qecho ''
\qecho 'Question 9'
\qecho ''
\qecho ''
/* a view with book cost more than 50*/
create view bookabove50 as 
	select bk.bookno 
	 from book bk 
	 where bk.price > 50;
/*a function that finds all the books bought by a student*/
create function boughtbooks(sid int) 
returns table(bookno int) as 
$$
	select b.bookno 
	from buys b 
	where b.sid = boughtbooks.sid;
$$ language sql;

/*used the venn diagram condition*/
select s.sid, s.sname 
from student s
where exists (select bookno 
			 from bookabove50 
			 except 
			 select bookno 
			 from boughtbooks(s.sid));

drop view bookabove50;
drop function boughtbooks;

\qecho ''
\qecho ''
\qecho 'Question 10'
\qecho ''
\qecho ''
/* created set of math and cs students.*/
create view MathandCS as 
	select m1.sid, m1.major 
	from major m1, major m2 
	where m1.sid = m2.sid and 
		(m1.major = 'CS' or 
		m2.major = 'Math');
/* a function that gives the sid values who bought the given bookno*/
create function studentsBought(bookno int) 
returns table (sid int) as 
$$
	select b.sid 
	from buys b 
	where b.bookno = studentsbought.bookno;
$$ language sql;
/* applying the venn diagram condition for not only*/
select distinct bk.bookno, bk.title 
from book bk
where exists (select sid 
			 from studentsBought(bk.bookno) 
			 except 
			 select sid 
			 from mathandcs)
	order by bk.bookno;

drop view MathandCS;
drop function studentsBought;

\qecho ''
\qecho ''
\qecho 'Question 11'
\qecho ''
\qecho ''
/* view of least expensive book*/
create view leastExpensiveBook as 
	select bk1.bookno, bk1.title, bk1.price 
	from book bk1 
	where bk1.price <=all(select bk2.price 
						from book bk2);
/* a function that gives a table of books bought by given SID*/
create function boughtbooks(sid int) 
returns table(bookno int) as 
$$
	select b.bookno 
	from buys b 
	where b.sid = boughtbooks.sid;
$$ language sql;
/*applying No condition of venn diagram*/
select s.sid, s.sname 
from student s 
where not exists (select bookno 
				 from boughtbooks(s.sid)
				 intersect 
				 select bookno 
				 from leastExpensiveBook);

drop view leastExpensiveBook;
drop function boughtbooks;

\qecho ''
\qecho ''
\qecho 'Question 12'
\qecho ''
\qecho ''
/* view of only CS students.*/
create view CSStudent as 
	select m.sid
	from major m 
	where m.major = 'CS';
/*books bought by only CS students*/
create view CSBuys as 
	select b.sid, b.bookno 
	from buys b, major m 
	where m.sid = b.sid and 
		m.major = 'CS';
/*rerutrns a table of sid who bought the given book*/
create function boughtByCS(bookno int) 
returns table(sid int) as 
$$
	select b.sid 
	from csbuys b 
	where b.bookno = boughtByCS.bookno
$$ language sql;
drop function boughtByCS;
/*applied condition for all and only, A-B and B-A are null*/
select distinct b1.bookno, b2.bookno 
from book b1, book b2
where b1.bookno <> b2.bookno and
	not exists( select sid 
			  from boughtByCS(b1.bookno)
			  except 
			  select sid 
			  from boughtByCS(b2.bookno)) and 
	not exists (select sid 
			   from boughtByCS(b2.bookno)
			   except 
			   select sid from boughtByCS(b1.bookno))
	order by(b1.bookno);

drop  view CSStudent, CSBuys;
drop function boughtByCS;


\qecho ''
\qecho ''
\qecho 'Question 13'
\qecho ''
\qecho ''
/*a vies of CS students*/
create view CSStudent as 
	select s.sid, s.sname 
	from student s 
	where exists (select 1 
				  from major m 
				  where m.sid = s.sid and 
				 	m.major = 'CS');
/*a view of books less than 50*/
create view lessthan50 as
	select bk.bookno
	from book bk 
	where bk.price < 50;
	
/* gives a table of books bought by given sid*/	
create function BoughtBooks(sid int) 
returns table(bookno int) as 
$$
	select b.bookno 
	from buys b 
	where b.sid = BoughtBooks.sid
$$ language sql;

/*intersect condition for fewer than 4 books.*/
select s.sid, s.sname 
from csstudent s
where (select count(1) 
			from (select t.bookno 
			 from BoughtBooks(s.sid) t 
			  intersect
			 select bookno 
			 from lessthan50) p)< 4;

drop view CSStudent, lessthan50;
drop function BoughtBooks;

\qecho ''
\qecho ''
\qecho 'Question 14'
\qecho ''
\qecho ''
/*books bought by CS students.*/
create view CSBuys as 
	select b.sid, b.bookno 
	from buys b, major m 
	where m.sid = b.sid and 
		m.major = 'CS';
		
/*calculated the frequency of  each books that is bought by CS students only*/
create view soldfrequency as
	select bk.bookno, bk.title, count(1) as boughtcount
	from book bk, CSBuys b
	where bk.bookno = b.bookno 
	group by(bk.bookno);

/*selected the odd number of bookcount from above view.*/
select bk.bookno, bk.title 
from book bk 
where (select count(1)
	   from (select 1 
			 from soldfrequency sf 
			 where sf.bookno = bk.bookno and 
			 sf.boughtcount % 2 <> 0) q) >=1 
			 order by(bk.bookno);

drop view soldfrequency, CSBuys;
-----------------------alternate solution----------
create view boughtbycs as 
select b.bookno, count(1) as noofstudents
from buys b, major m
where b.sid = m.sid and 
m.major = 'CS'
group by(b.bookno);

select bk.bookno, bk.title 
from book bk 
where bk.bookno in (select b.bookno 
				   from boughtbycs b
				   where b.noofstudents % 2 <> 0);
----------------------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 15'
\qecho ''
\qecho ''
/*gives the cound of all the books bought by that sid.*/
create function bookcounts(sid int ) 
returns bigint as 
$$
	select count(1) 
	from buys b 
	where b.sid = bookcounts.sid;
$$ language sql;
/*selects the student who bought all-3 books*/
select s.sid, s.sname 
from student s
where (select count(1) 
	  from (select 1 
			 from bookcounts(s.sid) 
			 where bookcounts = (select count(1) 
								from book) - 3) q) >=1
	order by(s.sid);

drop function bookcounts;
--------------alternate solution-------------------------
select s.sid, s.sname 
from student s, buys b
where s.sid = b.sid 
group by(s.sid) 
having count(b.bookno) = (select count(1) from book) -3;

----------------------------------------------------------

\qecho ''
\qecho ''
\qecho 'Question 16'
\qecho ''
\qecho ''
/*a function that gives a table of all sid who bought a given book*/
create function allstudent(bookno int ) 
returns table (sid int) as 
$$
	select b.sid 
	from buys b 
	where b.bookno = allstudent.bookno;
$$ language sql;
/*applied the condition for pair wise set condition A-B is null */
select bk1.bookno , bk2.bookno 
from book bk1, book bk2 
where bk1.bookno <> bk2.bookno and 
	(select count(1) 
	 from (select s1.sid 
		   from allstudent(bk1.bookno) s1
		   except 
		   select s2.sid 
		   from allstudent(bk2.bookno) s2) q)= 0;

drop function allstudent;
---------------------2018 assignment --------------
--set operations 
create table setA(
	x int
);
create table setB(
	x int
);
create table setC(
	x int
);
insert into setA values 
(1),
(2),
(3),
(4),
(5);

insert into setB values 
(1),
(2),
(3);

insert into setC values 
(1),
(2);
-- A subset of B
select not exists(select b.x 
				 from setb b 
				 except 
				 select a.x 
				 from seta a);
-- A intersect B except B = empty
select not exists(select a.x 
				 from setA a 
				 intersect 
				 select b.x 
				 from setB b 
				  except 
				  select b2.x 
				  from setB b2);
select (select count(1) 
	   from (select a.x 
			from setA a
			intersect 
			select b.x 
			from setb b) q) <=2;





-- connect to default database
\c postgres;

--Drop database created
drop database assignment3vkvats;
