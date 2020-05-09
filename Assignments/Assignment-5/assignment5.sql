-- Creating database with my initials
create database assignment5vkvats;

-- connecting database
\c assignment5vkvats;

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

INSERT INTO student VALUES(1001,'Jean'),
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
(1020,'Ahmed');

-- Data for the book relation.
INSERT INTO book VALUES(2001,'Databases',40),
(2002,'OperatingSystems',25),
(2003,'Networks',20),
(2004,'AI',45),
(2005,'DiscreteMathematics',20),
(2006,'SQL',25),
(2007,'ProgrammingLanguages',15),
(2008,'DataScience',50),
(2009,'Calculus',10),
(2010,'Philosophy',25),
(2012,'Geometry',80),
(2013,'RealAnalysis',35),
(2011,'Anthropology',50),
(3000,'MachineLearning',40);

-- Data for the buys relation.
INSERT INTO buys VALUES(1001,2002),
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
(1020,2012);

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

-- Data for the major relation.
INSERT INTO major VALUES(1001,'Math'),
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
(1017,'Anthropology');

------------Solution Part 1 ------------------
\qecho ''
\qecho '1.c'
\qecho ''

with 
E as (select sid, bookno
		from (select sid 
			   from major 
			   where major = 'CS') t cross join (select bookno from book) b
		except 
		select sid, bookno 
		from buys)
select bookno, title 
from book natural join (select distinct e1.bookno 
						from e e1 join e e2 on 
						(e1.sid <> e2.sid and e1.bookno = e2.bookno) 
						except 
						select distinct e3.bookno 
						from e e1 join e e2 on (e1.sid <> e2.sid and 
						e1.bookno = e2.bookno) join e e3 on 
						(e1.sid <> e3.sid and 
						e2.sid <> e3.sid and 
						e1.bookno = e3.bookno))q;

\qecho ''
\qecho '2.a'
\qecho ''

create table E1(x int);
create table E2(x int);
create table F(x int);
insert into F values(11),(12),(13);
insert into E1 values (101),(201),(301);
insert into E2 values (-101),(-201),(-301);
table f;
table e1;
table e2;

\qecho 'There are tuples in relation F so the output should be relation E1 here'

SELECT e1.* 
FROM E1 e1 cross join F 
UNION
(select e2.* 
from E2 e2 
EXCEPT
select e2.* 
from E2 e2 cross join F);

\qecho 'Now I will delete the values from F then the output should be relation E2'
delete from F;

SELECT e1.* 
FROM E1 e1 cross join F 
UNION
(select e2.* 
from E2 e2 
EXCEPT
select e2.* 
from E2 e2 cross join F);

drop table F, e1,e2;
\qecho ''
\qecho '2.b'
\qecho ''
create table A (x int);
insert into A values(10),(20),(30);
\qecho 'I have inserted some values in relation A, so the output should be TRUE'
Select AisNotEmpty 
from (select true as AisNotEmpty) q cross join (select distinct row() from A) a
	  UNION 
	  (select q.AisNotEmpty 
	  from (select false as AisNotEmpty) q 
	  EXCEPT
	  select q.AisNotEmpty 
	  from (select false as AisNotEmpty) q cross join (select distinct row() from A) a);

delete from A;
\qecho 'I have deleted everything from relation A so the output should be FALSE'
Select AisNotEmpty 
from (select true as AisNotEmpty) q cross join (select distinct row() from A) a
	  UNION 
	  (select q.AisNotEmpty 
	  from (select false as AisNotEmpty) q 
	  EXCEPT
	  select q.AisNotEmpty 
	  from (select false as AisNotEmpty) q cross join (select distinct row() from A) a);
	  
-------------Solutions Part 2-----------------
\qecho ''
\qecho '7'
\qecho ''

with 
csStudent as (select sid, sname 
		from student natural join 
			(select sid from major where major = 'CS') m),
booksMoreThan10 as (select distinct sid 
		from buys natural join 
		(select bookno from book where price > 10) b)
select sid, sname 
from csStudent natural join booksMoreThan10 order by 1;

\qecho ''
\qecho '8'
\qecho ''

with 
lessThan60 as (select bookno 
				from book 
				where price < 60),
citedbooklessthan60 as (select c.bookno, c.citedbookno 
						from cites c join lessThan60 b on 
						(c.citedbookno = b.bookno))
select bk.bookno, bk.title, bk.price
from book bk natural join (select distinct c1.bookno
						from citedbooklessthan60 c1 join citedbooklessthan60 c2 on 
						(c1.bookno = c2.bookno and c1.citedbookno <> c2.citedbookno)) q;

\qecho ''
\qecho '9'
\qecho ''

with 
MathStudent as (select sid 
			   from student natural join 
			   (select sid from major 
			   where major = 'Math') m),
boughtbyMathStudent as (select bookno 
					   from buys natural join MathStudent)
select bookno, title, price 
from book 
except 
select bookno, title, price 
from book natural join boughtbyMathStudent order by 1;

\qecho ''
\qecho '10'
\qecho ''

with
NameBookPrice as (select sid, sname, bookno, title, price 
				from student natural join buys natural join book)
select  sid, sname, title, price 
from NameBookPrice 
except
select distinct e1.sid, e1.sname, e1.title, e1.price
from NameBookPrice e1 join NameBookPrice e2 on (e1.sid = e2.sid and e1.price < e2.price) 
order by 1;

\qecho ''
\qecho '11'
\qecho ''

with 
exceptHighest as (select distinct bk1.bookno,bk1.title, bk1.price
				 from book bk1 join book bk2 
				 on (bk1.price < bk2.price))
select bookno, title 
from exceptHighest
except
select t1.bookno, t1.title 
from exceptHighest t1  join exceptHighest t2 
on (t1.price < t2.price) order by 1;

\qecho ''
\qecho '12'
\qecho ''

with 
MostExpensiveBook as (select bookno
					 from book 
					 except 
					 select bk1.bookno 
					 from book bk1 join book bk2 
					 on (bk1.price < bk2.price)),
dontCitesMostExpensiveBook as (select distinct bookno 
							  from (select bookno, citedbookno 
								   from cites 
								   except 
								   select c.bookno, c.citedbookno
								   from cites c join MostExpensiveBook t on (c.citedbookno = t.bookno)) q)					 
select bookno, title, price 
from book natural join dontCitesMostExpensiveBook order by 1;

\qecho ''
\qecho '13'
\qecho ''

with 
singleMajor as (select sid 
				from major 
				except 
				select distinct m1.sid 
			   from major m1 join major m2
			   on (m1.sid = m2.sid and 
			   	m1.major <> m2.major)),
allCombinationLessThan40 as (select distinct b.sid 
						 from buys b natural join 
							 (select distinct sid, bookno
								from student cross join 
							  (select bookno 
							  from book 
							  where price < 40)q) q1),
boughtAllMoreThan40 as (select sid 
						from student 
						except 
						select sid 
						from allCombinationLessThan40)								
select sid, sname 
from student natural join singleMajor  natural join boughtAllMoreThan40;

\qecho ''
\qecho '14'
\qecho ''

with 
mathandCS as (select sid 
			 from (select sid 
				  from major 
				  where major = 'Math') m1 natural join (select sid 
														from major 
														where major = 'CS') m2),
allBookCombination as (select sid, bookno 
					  from mathandCS cross join (select bookno from book) bk),
byMathAndCSOnly as (select distinct bookno 
				   from buys 
				   except 
				   select distinct bookno
				   from (select sid, bookno 
						 from allBookCombination
						except 
						select sid, bookno 
						from buys natural join mathandCS) q)
select bookno, title 
from book natural join byMathAndCSOnly order by 1;


\qecho ''
\qecho '15'
\qecho ''

with
atLeast70 as (select bookno 
			from book where price >= 70),
lessThan30 as (select bookno 
			   from book where price < 30),
F as (select distinct sid, bookno 
		from buys natural join atleast70),
E as (select distinct sid 
		from buys natural join lessthan30 t
			  union (select sid from student 
					except 
					select sid from student 
					natural join buys))
select distinct sid, sname  
from student natural join (select sid 
						  from (select e1.* 
							from e e1 cross join (select distinct row() from f) f
							union 
							(select e2.* 
							from e e2 
							except 
							select e2.*
							from  e e2 cross join (select distinct row() from f) f)) q) q1 order by 1;


\qecho ''
\qecho '16'
\qecho ''

with 
sameMajor as (select distinct m1.sid as s1, m2.sid as s2
	 		from major m1 join major m2 on 
	 		(m1.major = m2.major and m1.sid <> m2.sid)),
sameMajorBuys as (select distinct sid, bookno 
				from buys natural join 
				(select distinct s1 as sid 
					   from sameMajor) q),
E1 as (select b.sid as s1, b.bookno, t.s1 as s2 
		from sameMajorBuys b cross join 
	   (select distinct s1 from sameMajor) t),
E2 as (select t.s1 as s1, b.bookno, b.sid as s2 
		from (select distinct s1 from sameMajor) t 
	   cross join sameMajorBuys b),
E1minusE2 as (select distinct s1, s2 
			from (select * from e1 
				except 
				select * from e2) q),
E2minusE1 as (select distinct s1, s2 
			from (select * from e2 
				except 
				select * from e1) q)
select distinct s1, s2 
from E1minusE2 natural join sameMajor
union 
select distinct s1,s2 
from E2minusE1 natural join sameMajor order by 1,2;

-- connect to default database
\c postgres;

--Drop database created
drop database assignment5vkvats;