-- Creating database with my initials
create database assignment6vkvats;

-- connecting database
\c assignment6vkvats;

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
-- Data for the student relation.
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
(1017,'Anthropology');

\qecho '--------------------------------------------------------------------------------------------------------'

\qecho '--------------------------------------------------------------------------------------------------------'
\qecho 'PLEASE COMMENT OUT ALL OTHER QUERY FROM HERE TILL QUESTION 11 IF YOU WANT TO RUN ONLY QUESTION 14'
-----------------------------------------------------------------------------------------------------------
\qecho 'WITHOUT COMMENTING OUT, SAME SOLUTION WILL BE PRINTED OUT SEVERAL TIMES FOR PART 2 OF ASSIGNMENT'
\qecho '--------------------------------------------------------------------------------------------------------'

\qecho '--------------------------------------------------------------------------------------------------------'

\qecho 'Part 2: Translating and Optimizing SQL Queries to Equivalent RA Expressions'
\qecho ''
\qecho '3'
\qecho ''

-- given query 
select s.sid, s.sname 
from student s 
where s.sid in (select m.sid from major m where m.major = 'CS') and 
exists (select 1 
	   from cites c, book b1, book b2 
	   where (s.sid, c.bookno) in (select t.sid, t.bookno from buys t) and 
	  		c.bookno = b1.bookno and c.citedbookno = b2.bookno and 
	   		b1.price < b2.price);
			
-- pushing the top query inside IN subquery 
select s.sid, s.sname 
from student s, major m 
where m.major = 'CS' and s.sid = m.sid and 
exists (select 1 
	   from cites c, book b1, book b2 
	   where (s.sid, c.bookno) in (select t.sid, t.bookno from buys t) and 
	  		c.bookno = b1.bookno and c.citedbookno = b2.bookno and 
	   		b1.price < b2.price);
			
-- Pushing the external query inside EXISTS into inside IN subquery 
select s.sid, s.sname 
from student s, major m 
where m.major = 'CS' and s.sid = m.sid and 
exists (select 1 
	   from cites c, book b1, book b2, buys t 
	   where s.sid = t.sid and 
		c.bookno = t.bookno and 
		c.bookno = b1.bookno and 
		c.citedbookno = b2.bookno and 
		b1.price < b2.price);
		
-- Now, we push the top query inside the EXISTS subquery
select distinct s.sid, s.sname 
from student s, major m, cites c, book b1, book b2, buys t
where m.major = 'CS' and 
	s.sid = m.sid and 
	s.sid = t.sid and 
	c.bookno = t.bookno and 
	c.bookno = b1.bookno and 
	c.citedbookno = b2.bookno and 
	b1.price < b2.price;
	
-- separating CSMajor with temporary view 
with 
CSMajor as (select sid, major from major where major = 'CS') 
select distinct s.sid, s.sname 
from student s , CSMajor m, cites c, book b1, book b2, buys t 
where s.sid = m.sid and 
	s.sid = t.sid and 
	c.bookno = t.bookno and 
	c.bookno = b1.bookno and 
	c.citedbookno = b2.bookno and 
	b1.price < b2.price;
	
-- forming natural join between student and CSMajor and buys 
with 
CSMajor as (select sid, major from major where major = 'CS') 
select distinct s.sid, s.sname 
from student s natural join CSMajor m natural join buys t, cites c, book b1, book b2 
where c.bookno = t.bookno and 
	c.bookno = b1.bookno and 
	c.citedbookno = b2.bookno and 
	b1.price < b2.price;
	
-- join on cites 
with 
CSMajor as (select sid, major from major where major = 'CS') 
select distinct s.sid, s.sname 
from (student s natural join CSMajor m natural join buys t) 
	join cites c on (c.bookno = t.bookno), book b1, book b2
where c.bookno = b1.bookno and 
	c.citedbookno = b2.bookno and 
	b1.price < b2.price;

-- join on book b1 and b2
with 
CSMajor as (select sid, major from major where major = 'CS') 
select distinct s.sid, s.sname 
from (student s natural join CSMajor m natural join buys t) 
	join cites c on (c.bookno = t.bookno) 
	join book b1 on (c.bookno = b1.bookno) 
	join book b2 on (c.citedbookno = b2.bookno and b1.price < b2.price);
	
-- We can start optimizing now
-- Optimization step 1: we push selection and projection in where possible
with 
CSMajor as (select sid from major where major = 'CS'),
T as (select distinct s.sid, s.sname, t.bookno
	 from student s 
	 	natural join CSMajor m
	 	natural join buys t),
B as (select bookno, price from book),
C as (select c.bookno 
	 from cites c 
	 join B b1 on (b1.bookno = c.bookno) 
	 join b b2 on (c.citedbookno = b2.bookno and b1.price < b2.price))
select distinct t.sid, t.sname
from T t join C c on (t.bookno = c.bookno)
order by 1,2;

-- Optimization step 2: reduce to natural joins where ever possible as natural
-- joins are faster than join on conditions.
with 
CSMajor as (select sid 
			from major 
			where major = 'CS'),
StudentCSMajorBuys as (select distinct s.sid, s.sname, t.bookno
					 from student s 
						natural join CSMajor m
						natural join buys t),
Books as (select bookno, price 
		  from book),
CitedBooks as (select c.bookno 
	 from cites c 
	 natural join Books b1  
	 join Books b2 on (c.citedbookno = b2.bookno and b1.price < b2.price))
select distinct t.sid, t.sname
from StudentCSMajorBuys t 
natural join CitedBooks c 
order by 1,2;

\qecho ''
\qecho '4'
\qecho ''

-- given query 
select distinct s.sid, s.sname, m.major 
from student s, major m 
where s.sid = m.sid and s.sid not in(select m.sid from major m where m.major = 'CS') and 
	s.sid <> ALL (select t.sid
				 from buys t, book b 
				 where t.bookno = b.bookno and b.price < 30) and 
	s.sid in (select t.sid 
			 from buys t, book b 
			 where t.bookno = b.bookno and b.price < 60);
		 
-- chaning <> ALL to not exists 
select distinct s.sid, s.sname, m.major 
from student s, major m 
where s.sid = m.sid and s.sid in (select t.sid 
								 from buys t, book b
								 where t.bookno = b.bookno and b.price <60) and 
	s.sid not in (select m.sid from major m where m.major = 'CS') and 
	not exists(select 1 from 
			  buys t, book b 
			  where t.bookno = b.bookno and b.price < 30 and t.sid = s.sid);
		  
-- pushing top query into IN condition
select distinct s.sid, s.sname, m.major 
from student s, major m, buys t, book b 
where s.sid = m.sid and s.sid = t.sid and t.bookno = b.bookno and b.price< 60 and 
	s.sid not in (select m.sid from major m where m.major = 'CS') and 
	not exists(select 1 from 
			  buys t, book b 
			  where t.bookno = b.bookno and b.price < 30 and t.sid = s.sid);
		  
-- pushing query inside NOT IN and NOT EXISTS clause
select distinct q.sid, q.sname, q.major 
from (select distinct s.sid, s.sname, m.major 
		from student s, major m, buys t, book b 
		where s.sid = m.sid and s.sid = t.sid and t.bookno = b.bookno and b.price< 60
	 except 
	  select q2.sid, q2.sname, q2.major
	  from (select distinct s.sid, s.sname, m.major 
		  from student s, major m, buys t, book b, major m2
		  where s.sid = m.sid and s.sid = t.sid and 
		  t.bookno = b.bookno and b.price<60 and 
		  s.sid = m2.sid and m2.major = 'CS'
		  union
		 select distinct s.sid, s.sname, m.major 
		 from student s, major m, buys t, book b, buys t2, book b2
		 where s.sid = m.sid and s.sid = t.sid and t.bookno = b.bookno and b.price< 60 and 
		 t2.bookno = b2.bookno and b2.price < 30 and t2.sid = s.sid) q2) q;
		 
-- apply join and natural join where ever can be applied
select q.sid, q.sname, q.major 
from (select s.sid, s.sname, m.major 
	 from student s 
	  natural join major m 
	  natural join buys t 
	  join book b on (t.bookno = b.bookno and b.price <60)
	 except 
	 select q2.sid, q2.sname, q2.major 
	 from (select s.sid, s.sname, m.major 
		  from student s 
		   natural join major m 
		   natural join buys t 
		   join book b on (t.bookno = b.bookno and b.price <60)
		   join major m2 on (s.sid = m2.sid and m2.major = 'CS')
		  union 
		  select s.sid, s.sname, m.major 
		  from student s 
			natural join major m 
			natural join buys t 
			join book b on (t.bookno = b.bookno and b.price <60)
			join buys t2 on (t2.sid = s.sid) 
			join book b2 on (t2.bookno = b2.bookno and b2.price < 30) ) q2) q;
		  
-- Optimization step 1: pushing in conditon and projections where possible in all queries. 
with S as (select s.sid, s.sname from student s), 
	M as (select m.sid, m.major from major m), 
	B as (select b.bookno, b.price from book b),
	SM as (select s.sid, s.sname, m.major 
		  from S s natural join M m),
	Q1 as (select sm.sid, sm.sname, sm.major 
		  from SM sm natural join buys t join B b on (t.bookno = b.bookno and b.price < 60)),
	Q21 as (select sm.sid, sm.sname, sm.major 
		   from SM sm 
			natural join buys t 
			join B b on (t.bookno = b.bookno and b.price < 60) 
			join M m2 on (sm.sid = m2.sid and m2.major = 'CS')),
	Q22 as (select sm.sid, sm.sname, sm.major 
		   from SM sm 
			natural join buys t 
			join B b on (t.bookno = b.bookno and b.price < 60)
			join buys t2 on (t2.sid = sm.sid) 
			join B b2 on (b2.bookno = t2.bookno and b2.price < 30))
select q.sid, q.sname, q.major 
from (select q1.sid, q1.sname, q1.major 
	 from Q1 q1 
	 except 
	 (select q21.sid, q21.sname, q21.major 
	 from Q21 q21 
	 union 
	 select q22.sid, q22.sname, q22.major 
	 from Q22 q22 ))q;

-- Optimization step 2: converting all join on condition into natural joins.
-- Explanation.
/*In this optimization step, I have done a few improvement, 
1. initially, i was doing natural join to students, major and buys relations at three
different places, so i combined them in one and named it studentMajorBuys.
2. in temporaty view Q22, the original query(query in optimization step 1) suggest application of 
two condition, first, bookslessthan60 and second bookslessthan30. But we see, at the end, we
only going to get all such values for which the the cost is less than 30, so one buys realtion and 
and booksLessThan60 temporary views becomes redundant there, so i have removed it.
Also in Q21 temporary view, I have removed bookLessThan60 because in later stage when we find the set 
difference with Q1, there I have already used bookLessthan60*/
-- rest of the methodology is exactly how professor taught in class for such problems.

with CSMajor as( select m.sid from major m where m.major = 'CS'),
	bookLessThan60 as (select b.bookno from book b where b.price < 60),
	bookLessThan30 as (select b.bookno from book b where b.price < 30),
	StudentMajorbuys as (select s.sid, s.sname, m.major, t.bookno 
						from Student s 
						natural join Major m 
						natural join buys t),
	Q1 as (select smb.sid, smb.sname, smb.major 
		  from StudentMajorbuys smb 
		   natural join bookLessThan60 b ),
	Q21 as (select smb.sid, smb.sname, smb.major 
		   from StudentMajorbuys smb
			natural join CSmajor m2),
	Q22 as (select smb.sid, smb.sname, smb.major 
		   from StudentMajorbuys smb 
			natural join BookLessThan30 b)
select q.sid, q.sname, q.major 
from (select q1.sid, q1.sname, q1.major 
	 from Q1 q1 
	 except 
	 (select q21.sid, q21.sname, q21.major 
	 from Q21 q21 
	 union 
	 select q22.sid, q22.sname, q22.major 
	 from Q22 q22 ))q;

\qecho ''
\qecho '5'
\qecho ''

--given query 
select distinct s.sid, s.sname, b.bookno 
from student s, buys t, book b 
where s.sid = t.sid and t.bookno = b.bookno and 
b.price >= ALL (select b.price 
			   from book b 
			   where (s.sid, b.bookno) in (select t.sid, t.bookno from buys t));
			   
-- pushing the query inside the IN predicate 
select distinct s.sid, s.sname, b.bookno 
from student s, buys t, book b 
where s.sid = t.sid and t.bookno = b.bookno and 
b.price >= ALL (select b.price 
			   from book b, buys t 
			   where s.sid = t.sid and b.bookno = t.bookno) 
			   order by 1;
			   
-- converting ALL to NOT EXISTS condition 
select distinct s.sid, s.sname, b.bookno 
from student s, buys t, book b 
where s.sid = t.sid and t.bookno = b.bookno and 
not exists(select 1 
		  from book b2, buys t 
		  where s.sid = t.sid and b2.bookno = t.bookno and b.price < b2.price) 
		  order by 1;
		  
--Removing  NOT EXISTS condition 
select distinct q.sid, q.sname, q.bookno 
from (select s.sid, s.sname, b.* 
	 from student s, buys t, book b 
	 where s.sid = t.sid and 
	 t.bookno = b.bookno
	 except 
	 select s.sid, s.sname, b.* 
	 from student s, buys t, book b, buys t2, book b2 
	 where s.sid = t.sid and 
	 t.bookno = b.bookno and 
	 s.sid = t2.sid and 
	 b2.bookno = t2.bookno and 
	 b.price < b2.price) q 
	 order by 1;
	 
-- Convert to natural join or join where possible
select distinct q.sid, q.sname, q.bookno 
from (select s.sid, s.sname, b.* 
	 from student s natural join buys t natural join book b 
	 except 
	 select s.sid, s.sname, b.* 
	 from student s natural join buys t natural join book b 
	 join buys t2 on (s.sid = t2.sid) 
	 join book b2 on (b2.bookno = t2.bookno and b.price < b2.price)) q 
	 order by 1;
	 
-- Now we can optimize it by pushong selection and projection inside.
with Books as (select b.bookno, b.price 
			   from book b),
	StudentBook as (select distinct s.sid, s.sname, b.bookno, b.price 
			   from student s 
					natural join buys t 
					natural join Books b),
	BuysBooks as (select t.sid, t.bookno, b.price 
				from buys t 
				natural join Books b)
select q.sid, q.sname, q.bookno 
from (select sb.sid, sb.sname, sb.bookno 
	 from StudentBook sb 
	 except 
	 select sb.sid, sb.sname, sb.bookno 
	 from StudentBook sb join BuysBooks bt on (bt.sid = sb.sid and sb.price < bt.price)) q 
	 order by 1;
	 
\qecho ''
\qecho '6'
\qecho ''

--given query 
select b.bookno, b.title 
from book b 
where exists (select s.sid 
			 from student s 
			 where s.sid in (select m.sid from major m
							where m.major = 'CS'
							union 
							select m.sid from major m 
							where m.major = 'Math') and 
			 s.sid not in (select t.sid 
						  from buys t 
						  where t.bookno = b.bookno)) 
						  order by 1;
						  
-- taking math anc CS out with temporary view and push inside IN clause 
with MathAndCS as (select m.sid from major m where m.major = 'CS'
				 union 
				  select m.sid from major m where m.major = 'Math')
select b.bookno, b.title 
from book b 
where exists ( select s.sid 
			 from student s, MathAndCS m 
			 where s.sid = m.sid and 
			 s.sid not in (select t.sid 
						  from buys t 
						  where t.bookno = b.bookno)) 
						  order by 1;
						  
-- Removing the exists clause 
with MathAndCS as (select m.sid from major m where m.major = 'CS'
				 union 
				  select m.sid from major m where m.major = 'Math')
select distinct b.bookno, b.title 
from book b, student s, MathAndCS m 
where s.sid = m.sid and 
	s.sid not in (select t.sid 
				 from buys t 
				 where t.bookno = b.bookno) 
				 order by 1;
				 
-- Removing NOT IN clause
with 
MathAndCS as (select m.sid from major m where m.major = 'CS'
			 union 
			  select m.sid from major m where m.major = 'Math')
select distinct q.bookno, q.title 
from (select distinct b.bookno, b.title, s.sid 
	 from book b, student s, MathAndCS m 
	 where s.sid = m.sid 
	 except 
	 select distinct b.bookno, b.title, s.sid 
	 from book b, student s, MathAndCS m, buys t 
	 where s.sid = m.sid and s.sid = t.sid and t.bookno = b.bookno) q 
	 order by 1;
	 
-- Equivalent RA query 
-- using natural join/ join condition wherever possible 
with MathAndCS as (select m.sid from major m where m.major = 'CS'
				 union 
				  select m.sid from major m where m.major = 'Math')
select distinct q.bookno, q.title 
from (select distinct b.bookno, b.title, s.*
	 from book b 
	  cross join student s 
	  natural join MathAndCS m
	 except 
	 select distinct b.bookno, b.title, s.*
	 from student s 
	  natural join MathAndCS m 
	  natural join buys t 
	  natural join book b) q 
	  order by 1;

-- Optimization step 1:	  
-- now we can optimize it by pushing selection and projection inside. 
with  MathAndCS as (select m.sid from major m where m.major = 'CS'
				 union 
				  select m.sid from major m where m.major = 'Math'),
	Books as (select b.bookno, b.title from book b)
select distinct q.bookno, q.title 
from (select distinct b.bookno, b.title, m.sid 
	 from MathAndCS m 
	  cross join Books b 
	 except 
	 select distinct b.bookno, b.title, m.sid 
	 from MathAndCS m 
	  natural join buys t 
	  natural join Books b) q 
	 order by 1;

-- Optimization step 2: MathandCS is redundant in last subquery
with  MathAndCS as (select m.sid from major m where m.major = 'CS'
				 union 
				  select m.sid from major m where m.major = 'Math'),
	Books as (select b.bookno, b.title from book b)
select distinct q.bookno, q.title 
from (select distinct b.bookno, b.title, m.sid 
	 from MathAndCS m 
	  cross join Books b 
	 except 
	 select distinct b.bookno, b.title, t.sid 
	 from  buys t 
	  natural join Books b) q 
	 order by 1;
\qecho '--------------------------------------------------------------------------------------------------------'

\qecho '--------------------------------------------------------------------------------------------------------'
\qecho 'Part 3: Experiment to test effectiveness of query optimization'
\qecho '--------------------------------------------------------------------------------------------------------'
\qecho 'Please ignore the errors for part 3, as this is the experimentation part. the table for comparison is in .pdf file'
\qecho '--------------------------------------------------------------------------------------------------------'
-- insert into R, Ra and Rb
create or replace function makerandomR(m integer, n integer, l integer)
returns void as
$$
declare  i integer; j integer;
begin
    drop table if exists Ra; drop table if exists Rb;
    drop table if exists R;
    create table Ra(a int); create table Rb(b int);
    create table R(a int, b int);
for i in 1..m loop insert into Ra values(i); end loop;
for j in 1..n loop insert into Rb values(j); end loop;
insert into R select * from Ra a, Rb b order by random() limit(l);
end;
$$ LANGUAGE plpgsql;

-- insert into S and Sb
create or replace function makerandomS(n integer, l integer)
returns void as
$$
declare i integer;
begin
    drop table if exists Sb;
    drop table if exists S;
    create table Sb(b int);
    create table S(b int);
for i in 1..n loop insert into Sb values(i); end loop;
    insert into S select * from Sb order by random() limit (l);
end;
$$ LANGUAGE plpgsql;


\qecho ''
\qecho '7'
\qecho ''

--given query Q3
--EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select distinct r1.a
from R r1, R r2, R r3
where r1.b = r2.a and r2.b = r3.a;

--optimized query: Q4
-- Explanation of optimization: 
/*We know that the natural join condition operates faster than the join on condition 
method, so to advantage of it, I have renames the attributes, so that natural join can 
be performed. */

--EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
with 
R3 as (select distinct r.a as b from R r),
R2R3 as (select distinct r2.a as b from R r2 natural join R3)
select distinct r1.a
from R r1 
natural join R2R3;

\qecho ''
\qecho '8'
\qecho ''

-- --inserting large value to R
-- select makerandomR(100,100,1000);
-- select makerandomS(100,50);

-- select makerandomR(100,100,1000);
-- select makerandomS(100,100);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,250);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,1000);

-- select makerandomR(2000,2000,40000);
-- select makerandomS(2000,2000);

-- select makerandomR(5000,6000,100000);
-- select makerandomS(6000,6000);

-- select makerandomR(8000,8000, 100000);
-- select makerandomS(8000, 8000);

-- given query Q5
select ra.a
from Ra ra
where not exists (select r.b 
				 from R r 
				 where r.a = ra.a and 
				 r.b not in (select s.b from S s)) 
				 order by 1;
				 
-- remove NOT EXISTS
select q.a 
from (select ra.a 
	 from Ra ra 
	 except 
	 select distinct ra.a 
	 from Ra ra, R r 
	 where r.a = ra.a and 
	 	r.b not in (select s.b from S s)) q
		order by 1;
		
--remove NOT IN
select q.a 
from (select ra.a 
	 from Ra ra 
	 except 
	 select distinct q2.a 
	 from (select ra.a, r.b 
		  from Ra ra, R r 
		  where r.a = ra.a 
		  except 
		  select ra.a, r.b 
		  from Ra ra, R r, S s 
		  where r.a = ra.a  and 
		  r.b = s.b) q2) q
		  order by 1;
		  
-- introduce natural join and join where possible 
select q.a 
from (select ra.a 
	 from Ra ra 
	 except 
	 select q2.a 
	 from (select ra.a, r.b 
		  from Ra ra natural join R r
		  except 
		  select r.a, r.b 
		  from Ra ra natural join R r Natural join S s) q2) q
		  order by 1;

-- Q6
-- Optimization explanation: 
/*the optimization follows all traditional steps of pushing the upper query inside and keeping all 
attributes that is needed. Only in the last subquery, using the internal structure of how Ra and R are formed,
the natural join Ra and R becomes redundant, so I have removed that.*/
--Unitlizing the internal structure of relation R and Ra, we can remove Ra form subquery by R
select q.a 
from (select distinct ra.a 
	 from Ra ra 
	 except 
	 select q2.a 
	 from (select r.a, r.b
		  from R r
		  except 
		  select r.a, r.b
		  from R r Natural join S s) q2) q 
		  order by 1;

\qecho ''
\qecho '9'
\qecho ''
-- --inserting large value to R
-- select makerandomR(100,100,1000);
-- select makerandomS(100,50);

-- select makerandomR(100,100,1000);
-- select makerandomS(100,100);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,250);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,1000);

-- select makerandomR(2000,2000,40000);
-- select makerandomS(2000,2000);

-- select makerandomR(3000,5000,80000);
-- select makerandomS(5000,5000);

-- select makerandomR(8000,8000, 100000);
-- select makerandomS(8000, 8000);

--given query 
--EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select ra.a 
from Ra ra 
where not exists (select s.b 
				 from S s
				 where s.b not in (select r.b from R r 
								  where r.a = ra.a));		  
								  
-- remove not exists 
select q.a 
from (select distinct ra.a, s.b 
	 from Ra ra, S s 
	 except 
	 select distinct ra.a, s.b 
	 from Ra ra, s s 
	 where s.b not in(select r.b 
					  from R r 
					  where r.a = ra.a))q;
-- remove NOT IN
select q.a 
from (select distinct ra.a 
	 from Ra ra 
	 except 
	 select distinct q2.a 
	 from (select distinct ra.a, s.b 
		  from Ra ra, S s 
		  except 
		  select distinct r.a, s.b 
		  from Ra ra, S s, R r 
		  where r.a = ra.a and 
		  	r.b = s.b) q2) q;
			
-- Now we can optimize and insert Join conditions.
--EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select q.a 
from (select ra.a
	 from Ra ra 
	 except 
	 select distinct q2.a 
	 from (select ra.a, s.b 
		  from Ra ra cross join S s
		  except 
		  select r.a, r.b 
		  from R r natural join S s) q2) q;


\qecho ''
\qecho '10'
\qecho ''

-- --inserting large value to R
-- select makerandomR(100,100,1000);
-- select makerandomS(100,50);

-- select makerandomR(100,100,1000);
-- select makerandomS(100,100);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,250);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,1000);

-- select makerandomR(2000,2000,40000);
-- select makerandomS(2000,2000);

-- select makerandomR(3000,5000,80000);
-- select makerandomS(5000,5000);

-- select makerandomR(8000,8000, 100000);
-- select makerandomS(8000, 8000);

--EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
with 
NestedR as (select r.a, array_agg(r.b order by 1) as Bs
				from R r 
				group by(r.a)),
setS as (select array(select s.b from S s order by 1) as Bs)
select r.a 
from NestedR r, SetS s 
where r.Bs <@ s.Bs
union 
select r.a 
from NestedR r 
where r.Bs = '{}';


\qecho ''
\qecho '11'
\qecho ''
-- --inserting large value to R
-- select makerandomR(100,100,1000);
-- select makerandomS(100,50);

-- select makerandomR(100,100,1000);
-- select makerandomS(100,100);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,250);

-- select makerandomR(500,500,2500);
-- select makerandomS(500,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,500);

-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,1000);

-- select makerandomR(2000,2000,40000);
-- select makerandomS(2000,2000);

-- select makerandomR(3000,5000,80000);
-- select makerandomS(5000,5000);

-- select makerandomR(8000,8000,100000);
-- select makerandomS(8000,8000);

-- -- additional test 
-- --inserting large value to R
-- select makerandomR(1000,1000,10000);
-- select makerandomS(1000,1000);

-- select makerandomR(1500,1500,15000);
-- select makerandomS(1500,1500);

-- select makerandomR(2000,2000,400000);
-- select makerandomS(2000,2000);

-- select makerandomR(2500,2500,600000);
-- select makerandomS(2500,2500);

--EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
with 
NestedR as (select r.a, array_agg(r.b order by 1) as Bs 
		   from R r 
		   group by(r.a)),
SetS as (select array(select s.b from S s order by 1) as Bs)
select r.a 
from NestedR r, SetS s
where s.Bs <@ r.Bs;

\qecho '--------------------------------------------------------------------------------------------------------'

\qecho '--------------------------------------------------------------------------------------------------------'
\qecho 'PLEASE COMMENT OUT ALL QUERY ABOVE THIS IF YOU WANT TO RUN ONLY QUESTION 14'
\qecho '--------------------------------------------------------------------------------------------------------'

\qecho '--------------------------------------------------------------------------------------------------------'


\qecho 'Part 4: Object relationla SQL'
\qecho ''
\qecho '12'
\qecho ''

-- setUnion function 
create or replace function setunion(A anyarray, B anyarray) 
returns anyarray as
$$
with
   Aset as (select UNNEST(A)),
   Bset as (select UNNEST(B))
select array((select * from Aset) 
			 union 
			 (select * from Bset) order by 1);
$$ language sql;

-- IsIn function: to check set membership
create or replace function isIn(x anyelement, S anyarray)
returns boolean as
$$
select x = SOME(S);
$$ language sql;

\qecho ''
\qecho '12.a'
\qecho ''

-- setIntersection function 
create or replace function setIntersection(A anyarray, B anyarray) 
returns anyarray as
$$
with
   Aset as (select UNNEST(A)),
   Bset as (select UNNEST(B))
select array((select * from Aset) 
			 intersect 
			 (select * from Bset) order by 1);
$$ language sql;

\qecho ''
\qecho '12.b'
\qecho ''

-- setDifference function 
create or replace function setDifference(A anyarray, B anyarray) 
returns anyarray as
$$
with
   Aset as (select UNNEST(A)),
   Bset as (select UNNEST(B))
select array((select * from Aset) 
			 except 
			 (select * from Bset) order by 1);
$$ language sql;

\qecho ''
\qecho '13: creating student_books view'
\qecho ''
--student_books(sid, books) as given in assignment.
create or replace view student_books as 
select s.sid, array(select t.bookno 
				   from buys t 
				   where t.sid = s.sid order by t.bookno) as books 
from student s order by s.sid;				   

\qecho ''
\qecho '13.a: creating book_students view'
\qecho ''
-- book students(bookno,students)
create view book_students as 
select b.bookno, array(select t.sid 
					  from buys t 
					  where t.bookno = b.bookno order by t.sid) as students
from book b order by b.bookno;					  

\qecho ''
\qecho '13.b: book_citedbooks view'
\qecho ''
-- book citedbooks(bookno,citedbooks)
create view book_citedbooks as 
select b.bookno, array(select c.citedbookno 
					  from cites c 
					  where c.bookno = b.bookno order by c.citedbookno) as citedbooks
from book b order by b.bookno;					  

\qecho ''
\qecho '13.c: book_citingbooks view'
\qecho ''
-- book citingbooks(bookno,citingbooks)
create view book_citingbooks as 
select b.bookno, array(select c.bookno 
					  from cites c 
					  where c.citedbookno = b.bookno order by c.citedbookno) as citingbooks
from book b order by b.bookno;					  

\qecho ''
\qecho '13.d: major_students view'
\qecho ''
-- major students(major,students)
create view major_students as 
select distinct m.major, array(select m2.sid 
					 from major m2 
					 where m.major = m2.major order by m2.sid) as students
from major m order by m.major;					 

\qecho ''
\qecho '13.e: student_majors view'
\qecho ''

-- student majors(sid,majors)
create view student_majors as 
select s.sid, array(select m.major 
				   from major m 
				   where s.sid = m.sid ) as majors 
from student s order by s.sid;				   

\qecho ''
\qecho '14.a'
\qecho ''

with 
booksLessThan50 as (select array(select b.bookno 
								from book b 
								where b.price<50) as books)
select b.bookno, b2.title
from book_citedbooks b, bookslessthan50 b50, book b2
where cardinality(b.citedbooks)>= 3 and 
	setdifference(b.citedbooks,b50.books) <@ '{}' and 
	b.bookno = b2.bookno;

\qecho ''
\qecho '14.b'
\qecho ''

with 
CSMajor as (select students 
		   from major_students 
		   where major = 'CS')
select distinct b.bookno, b2.title 
from book_students b, CSMajor m, book b2 
where cardinality(setIntersection(b.students, m.students)) =0 and 
	b2.bookno = b.bookno;

\qecho ''
\qecho '14.c'
\qecho ''

with 
atLeast50 as (select array(select b.bookno 
						  from book b 
						  where price >=50) as books)
select s.sid 
from student_books s, atLeast50 b50
where cardinality(setdifference(b50.books, s.books)) = 0;

\qecho ''
\qecho '14.d'
\qecho ''

with 
CSMajor as (select students 
		   from major_students 
		   where major = 'CS')
select b.bookno 
from book_students b, CSMajor m
where cardinality(setDifference(b.students, m.students)) >0;

\qecho ''
\qecho '14.e'
\qecho ''

with 
booksMoreThan45 as (select array(select b.bookno 
								from book b 
								where b.price >45) as books),
StudentsBoughtAllbooksMoreThan45 as (select array(select s.sid 
										   from student_books s, booksMoreThan45 b45 
										   where cardinality(setDifference(b45.books, s.books)) = 0) as students)						
select b.bookno, b2.title 
from book_students b, StudentsBoughtAllbooksMoreThan45 s45, book b2
where cardinality(setDifference(b.students, s45.students)) > 0 and 
	b2.bookno = b.bookno ;

\qecho ''
\qecho '14.f'
\qecho ''

select distinct s.sid as s, b.bookno as b
from student_books s, book_citingbooks b 
where cardinality(setDifference(s.books, b.citingbooks)) > 0
order by 1,2;

\qecho ''
\qecho '14.g'
\qecho ''

select b1.bookno as b1, b2.bookno as b2 
from book_students b1, book_students b2 
where cardinality(setDifference(b1.students, b2.students)) = 0 and 
	cardinality(setDifference(b2.students, b1.students)) = 0
order by 1,2;

\qecho ''
\qecho '14.h'
\qecho ''

select b1.bookno as b1, b2.bookno as b2 
from book_students b1, book_students b2 
where (cardinality(b1.students) - cardinality(b2.students)) = 0 
order by 1,2;

\qecho ''
\qecho '14.i'
\qecho ''

with 
allbooks as (select array(select bookno from book) as books)
select s.sid 
from student_books s, allbooks b
where cardinality(setDifference(b.books, s.books)) = 4;

\qecho ''
\qecho '14.J'
\qecho ''

with 
Psychology as (select unnest(m.students) as sid 
			  from major_students m 
			  where m.major = 'Psychology'),
NumberOfBooksByPsychology as (select cardinality(s.books) as number 
							 from student_books s, Psychology p
							 where s.sid = p.sid)
select s.sid 
from student_books s, NumberOfBooksByPsychology n
where cardinality(s.books)<= (select n.number from NumberOfBooksByPsychology n);

-- connect to default database
\c postgres;

--Drop database created
drop database assignment6vkvats;