-- Creating database with my initials
create database assignment2vkvats;

-- connecting database
\c assignment2vkvats;

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


\qecho ''
\qecho ''
\qecho 'Question 1'
\qecho ''
\qecho ''

\qecho '(a) without using subqueies and set predicate'

/* Selecting sid and name of students after checking the two conditions in the where clause.*/

select distinct s.sid, s.sname 
from student s, major m, book bk, buys b 
where s.sid = b.sid and 
	s.sid = m.sid and 
	b.bookno = bk.bookno and 
	m.major = 'CS' and 
	bk.price > 10;

\qecho '(b) Only using IN or NOT IN set predicates.'

/*from deepest subquery i am checking the bookno which as price greater than 10 
then i check the membership of the correspoinding sid with the sids of student with 
major CS and then i finally select those students that are member in first subquery*/

select s.sid, s.sname 
from student s 
where s.sid in (select distinct m.sid 
				from major m  
				where m.major = 'CS' and 
					m.sid in (select distinct b.sid 
								from buys b 
								where b.bookno in (select bk.bookno 
													from book bk 
													where bk.price > 10)));

\qecho '(c) only using the SOME or ALL set predicates'

/*from deepest subquery i am checking some bookno which as price greater than 10 
then i check the membership of the correspoinding sid with the sids of student with 
major CS and then i finally select those students that are member in first subquery*/

select s.sid, s.sname 
from student s 
where s.sid =some (select distinct m.sid 
				from major m  
				where m.major = 'CS' and 
					m.sid =some (select distinct b.sid 
								from buys b 
								where b.bookno =some (select bk.bookno 
													from book bk 
													where bk.price > 10)));

\qecho '(d) only using the EXISTS or NOT EXISTS set predicates'

/* in the where clause i check two exists condition in conjunction 
the second exists condition also has one subquery which check the 
condition of book being > 10*/

select s.sid, s.sname 
from student s 
where exists (select 1
				from major m  
				where m.major = 'CS' and s.sid = m.sid) and 
	 exists (select 1
				from buys b 
				where b.sid = s.sid and 
			 		exists (select 1 
							from book bk 
							where bk.price > 10 and 
								b.bookno = bk.bookno));

\qecho ''
\qecho ''
\qecho 'Question 2'
\qecho ''
\qecho ''

\qecho '(a) without using subqueies and set predicate'

/*from relation book, I am subtracting all those books 
bought by any math student*/

(select bk.bookno, bk.title, bk.price
 from book bk) 
EXCEPT
(select distinct bk.bookno, bk.title, bk.price
 from buys b, major m, book bk 
 where m.major = 'Math' and 
	m.sid = b.sid and 
	b.bookno = bk.bookno);
-------------alternate solutio --------------
select bk.bookno, bk.title, bk.price 
from book bk
where not exists(select 1 
				from buys b, major m
				where b.sid = m.sid and 
					b.bookno = bk.bookno and 
					m.major = 'Math');
---------------------------------------------
	
\qecho '(b) Only using IN or NOT IN set predicates'

/*From deepest query i am slecting all sid with math and then making 
set of bookno  which are bought by all math student and then finally 
checking that I am not selecting any such book that is present there*/

select bk.bookno, bk.title, bk.price 
from book bk 
where bk.bookno not in (select distinct b.bookno 
					   from buys b 
					   where b.sid in (select m.sid 
									  from major m 
									  where m.major = 'Math'));

\qecho '(c) only using the SOME or ALL set predicates.'

/*In deepest subquery i am select all student with math major 
and then i am selecting any book bought by someone from that sid 
in the topmost query i am not selecting any such book which is
present in overall subquery output.*/

select bk.bookno, bk.title, bk.price 
from book bk 
where bk.bookno <> all (select distinct b.bookno 
					   from buys b 
					   where b.sid = some (select m.sid 
									  from major m 
									  where m.major = 'Math'));

\qecho '(d) only using the EXISTS or NOT EXISTS set predicates'		

/*from deepest subquery I check the condition that the sid which has 
bought the book has math as major or not. and then I am negating the 
condition in final selection such that no book is selected which is 
bought by the math major students.*/


select distinct bk.bookno, bk.title, bk.price 
from book bk 
where not exists (select 1
			 from buys b1 
			 where bk.bookno = b1.bookno and 
			 exists (select 1
						from major m 
						where m.sid = b1.sid and 
						m.major = 'Math'));

\qecho ''
\qecho ''
\qecho 'Question 3'
\qecho ''
\qecho ''

\qecho '(a) without using subqueies and set predicate'

/*IN the where clause. first I am checking if the two book cited by same bookno is different and not
then i check if the price of both the citedbookno are less than 60 os not*/

select distinct bk.bookno, bk.title, bk.price
from cites c1, cites c2, book bk, book bk1, book bk2 
where c1.bookno = bk.bookno and 
	c1.bookno = c2.bookno and 
	c1.citedbookno <> c2.citedbookno and 
	c1.citedbookno = bk1.bookno and 
	c2.citedbookno = bk2.bookno and 
	bk1.price < 60 and 
	bk2.price < 60;	
	

\qecho '(b) Only using IN or NOT IN set predicates'

/*In the topmost subquery I am checking the membership of bookno which
has cited two diffferent books and then in subsequent subquery I 
check if both the citedbooks  are part of the bookno that has cost less than 60*/

select bk.bookno, bk.title, bk.price
from book bk 
where bk.bookno in (select distinct c.bookno
						   from cites c, cites c1 
						   where c.bookno = c1.bookno and
						   c.citedbookno <> c1.citedbookno and 
						   (c.citedbookno, c1.citedbookno) in (select distinct bk1.bookno, bk2.bookno 
																from book bk1, book bk2 
																where bk1.price < 60 and 
																	bk2.price < 60 and 
																	bk1.bookno <> bk2.bookno));

\qecho '(c) only using the EXISTS or NOT EXISTS set predicates'	

/*in the first subquery, I check if there exists a book that sites two different books
 and then in the subsequent subquery I check ih those different cited books have
 cost less than 60.*/

select bk.bookno, bk.title, bk.price
from book bk 
where exists (select 1
			   from cites c1, cites c2 
			   where bk.bookno = c1.bookno and 
			  	c1.bookno = c2.bookno and
			   c1.citedbookno <> c2.citedbookno and 
			  exists (select 1
					from book bk1, book bk2 
					where c1.citedbookno = bk1.bookno and 
						c2.citedbookno = bk2.bookno and 
						bk1.price < 60 and 
						bk2.price < 60 ));

\qecho ''
\qecho ''
\qecho 'Question 4'
\qecho ''
\qecho ''

\qecho '(a) without using subqueies and set predicate'

/* From all combination of books bought by different students 
I am removing those books which are not the highest priced book 
bought by that person*/

select s.sid, s.sname, bk.title, bk.price
from buys b, book bk, student s
where b.sid = s.sid and 
	bk.bookno = b.bookno 
except				 
select distinct s.sid, s.sname, bk1.title, bk1.price
from book bk1, book bk2, buys b1, buys b2, student s 
where bk1.bookno <> bk2.bookno and 
	bk1.price < bk2.price and 
	b1.bookno = bk1.bookno and 
	b2.bookno = bk2.bookno and 
	b1.sid = b2.sid and 
	b1.sid = s.sid;

\qecho '(b) using subqueies and set predicate'

/*from all sids, I am selectiong all student with the bookno which is 
the constliest one, >= All check that condition*/

select s.sid, s.sname, bk.title, bk.price
from buys b, book bk, student s
where b.sid = s.sid and 
	bk.bookno = b.bookno and 
	bk.price >= all (select bk2.price 
				   from book bk2,buys b2 
				   where  bk2.bookno = b2.bookno and 
					b.sid = b2.sid);

\qecho ''
\qecho ''
\qecho 'Question 5'
\qecho ''
\qecho ''

/* from the relation student, in not selecting those sids
who has bought two different books with any one of them having more than $20*/

select distinct s.sid, s.sname 
from student s
where s.sid not in (select distinct b1.sid
					from buys b1, buys b2, book bk 
					where b1.sid = b2.sid and 
						b1.bookno <> b2.bookno and 
						b1.bookno = bk.bookno and 
						bk.price > 20); 
----------Alternate solutions-----------

\qecho ''
\qecho ''
\qecho 'Question 6'
\qecho ''
\qecho ''

/*I have created a view with all books which is not the costliest book. 
repeating the same thing again, using this view, I subtract those tubples which 
has third highest or lower cost. from the view with all books except most costly one.*/

create view exceptMostCostly as 
	select distinct bk1.bookno, bk1.title, bk1.price
	from book bk1, book bk2 
	where bk1.bookno <> bk2.bookno and 
		bk1.price < bk2.price;
		
select bk1.bookno, bk1.title, bk1.price 
from exceptMostCostly bk1 
except 
select distinct bk1.bookno, bk1.title, bk1.price 
from exceptMostCostly bk1, exceptMostCostly bk2 
where bk1.bookno <> bk2.bookno and 
bk1.price < bk2.price;

drop view exceptMostCostly;

\qecho ''
\qecho ''
\qecho 'Question 7'
\qecho ''
\qecho ''

/*For each book that cites another book, I check if the cited book is not present
in a set which has the most constly book*/

select distinct bk.bookno, bk.title, bk.price 
from book bk, cites c 
where c.bookno = bk.bookno and 
	c.citedbookno not in (select bk1.bookno 
						from book bk1 
						where bk1.price >= ALL (select bk2.price 
											  from book bk2));		
\qecho ''
\qecho ''
\qecho 'Question 8'
\qecho ''
\qecho ''

/*From each student who has bought some books, I dont select those who has cost more than
40 in first subquery and then for those who satisfy the first condition i check where they have only 
one major*/

select distinct s.sid, s.sname 
from student s, buys b1 
where b1.sid = s.sid and 
	s.sid not in (select distinct b2.sid 
					from buys b2, book bk 
					where b2.bookno = bk.bookno and 
						bk.price < 40) and 
	s.sid in (select m.sid 
					from major m 
					except
					select distinct m1.sid 
					from major m1, major m2 
					where m1.sid = m2.sid and 
					m1.major != m2.major);

\qecho ''
\qecho ''
\qecho 'Question 9'
\qecho ''
\qecho ''

/*for any bookno bought by sid1 an sid2, i check for same bookno with different sid and then
I check for the condition that both the sids are in a set which has both math and CS major*/

select distinct b1.bookno, bk.title 
from buys b1, buys b2, book bk
where b1.bookno = bk.bookno and 
	b1.sid <> b2.sid and 
	b1.bookno = b2.bookno and 
	b1.sid in (select m1.sid 
				from major m1 
				where m1.major = 'Math' and 
					m1.sid in (select m2.sid 
							 from major m2 
							 where m2.major = 'CS')) and 
	b2.sid in (select m1.sid 
				from major m1 
				where m1.major = 'Math' and 
					m1.sid in (select m2.sid 
							 from major m2 
							 where m2.major = 'CS'));	
---------------------Alternate solution------------------------------------
select bk.bookno, bk.title 
from book bk 
where not exists (select b.sid  
				 from buys b 
				 where b.bookno = bk.bookno
				  except 
				  select m1.sid 
				  from major m1, major m2 
				  where m1.sid = m2.sid and 
				  m1.major = 'CS' and m2.major = 'Math');
--------------------------------------------------------------------------							 
							 
							 
\qecho ''
\qecho ''
\qecho 'Question 10'
\qecho ''
\qecho ''

/*For IF THEN condition I am selectively satisfying all  conditions from the truth table one
by one and have put OR condition in between.*/

select s.sid, s.sname 
from student s 
where s.sid in (select distinct b1.sid 
				from buys b1, buys b2, book bk1, book bk2 
				where b1.sid = b2.sid and 
					bk1.bookno = b1.bookno and 
					bk2.bookno = b2.bookno and 
					bk1.price >= 70 and 
					bk2.price < 30) or 
	s.sid in (select  distinct b.sid 
					from buys b, book bk
					where b.bookno = bk.bookno and 
						bk.price < 70
					EXCEPT 
					select  distinct b.sid 
					from buys b, book bk
					where b.bookno = bk.bookno and 
						bk.price >= 70) or 
	s.sid in (select s.sid
			 from student s 
			 where s.sid not in (select b.sid 
								from buys b));
-----------------Alternate solution---------------------------------
select s.sid, s.sname 
from student s 
where not exists(select 1 
				from buys b1, book bk1 
				where bk1.bookno = b1.bookno and 
				b1.sid = s.sid and bk1.price >= 70 and 
				not exists(select 1 
						  from buys b2, book bk2 
						  where bk2.bookno = b2.bookno and 
						  b2.sid = s.sid and bk2.price < 30));
-----------------------------------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 11'
\qecho ''
\qecho ''

/*I create a commonMajor view, and then i find the intersection of this view with a set of sid s1 and 
s2 who has not all book in common. to find all those sid pair, i check the condition that for same book
they are in set of sid who has bought b1 but not in the set of sids who has bought book b2, this gives 
those pairs of s1, s2, when s1 has not all same books as s2, then after OR condition and reverse check 
the same condition but this time i select all sid s2 which has not all same book as s1. this gives me a
complete list of student who has differnt books then i take intersection with those who has same major*/

create view commonMajor as 
	select m1.sid as s1, m2.sid as s2 
		from major m1, major m2 
		where m1.major = m2.major and 
			m1.sid <> m2.sid;
---------------------alternate solution ----------------------
create function booksboughtby(sid int) 
returns table(bookno int) as 
$$ 
	select b.bookno 
	from buys b 
	where b.sid = booksboughtby.sid;
$$ language sql;

select distinct  cm.s1, cm.s2 
from commonmajor cm, commonmajor cm1
where exists(select bookno
			from booksboughtby(cm.s1)
			except 
			select bookno 
			from booksboughtby(cm.s2)) or 
	exists (select bookno 
		   from booksboughtby(cm.s2)
		   except 
		   select bookno 
		   from booksboughtby(cm.s1));



------------------------------------------------------------
select s1, s2 from commonMajor
intersect
select  distinct s1.sid, s2.sid 
from student s1, student s2, book bk 
where (s1.sid in(select b1.sid 
			   from buys b1 
			   where b1.bookno = bk.bookno) and 
	s2.sid not in (select b2.sid 
				  from buys b2 
				  where b2.bookno = bk.bookno)) or
 	(s1.sid not in(select b1.sid 
			   from buys b1 
			   where b1.bookno = bk.bookno) and 
	s2.sid in (select b2.sid 
				  from buys b2 
				  where b2.bookno = bk.bookno)) and 
	s1.sid <> s2.sid;

drop view commonMajor;

\qecho ''
\qecho ''
\qecho 'Question 12'
\qecho ''
\qecho ''

/*Instead of satisfying each condition in truth table, i have selected the one false condition and 
have subtracted from all possible tuples.*/

select count(*) from 
(select s1.sid, bk1.bookno, s2.sid, bk2.bookno 
from student s1, student s2, book bk1, book bk2 
except 
select b1.sid, b1.bookno, b2.sid, b2.bookno 
from buys b1, buys b2) c;



\qecho ''
\qecho ''
\qecho 'Question 13'
\qecho ''
\qecho ''

/*using the view of atleast30 books, i check the membership of all those student who has bought more
than one book and any one of those book has more than 30 cost, i don't select that in the subquery and 
i check the membership of all students one by one and select those who are nto in there.*/

create view bookAtLeast30 as 
	select bk.bookno, bk.title, bk.price 
	from book bk 
	where bk.price >= 30;
	
select distinct s.sid, s.sname
from student s
where s.sid not in(select distinct b1.sid 
								from buys b1, buys b2
								where b1.sid = b2.sid and 
									b1.bookno <> b2.bookno and 
									b1.bookno not in (select bk301.bookno
													  from bookAtLeast30 bk301) and  
									b2.bookno not in (select bk302.bookno
													  from bookAtLeast30 bk302));

drop view bookAtLeast30;

\qecho ''
\qecho ''
\qecho 'Question 14'
\qecho ''
\qecho ''

/*I do the same thing just with WITH condition*/

with bookAtLeast30 as 
	(select bk.bookno, bk.title, bk.price 
	from book bk 
	where bk.price >= 30)
select distinct s.sid, s.sname
from student s
where s.sid not in(select distinct b1.sid 
								from buys b1, buys b2
								where b1.sid = b2.sid and 
									b1.bookno <> b2.bookno and 
									b1.bookno not in (select bk301.bookno
													  from bookAtLeast30 bk301) and  
									b2.bookno not in (select bk302.bookno
													  from bookAtLeast30 bk302));


\qecho ''
\qecho ''
\qecho 'Question 15'
\qecho ''
\qecho ''
-- creating parameterized view
create function citesBooks(b int)
	returns table(bookno int, title text, price int) as 
	$$
		select bk.bookno, bk.title, bk.price 
		from book bk, cites c 
		where c.bookno = b and 
		bk.bookno = c.citedbookno;
	$$ language sql;

\qecho ''
\qecho ''
\qecho 'Question 15(a)'
\qecho ''
\qecho '' 

/*using parameterized view, for all books i check which book has cited more than two cook and one 
of them is 2001 then for the other book i just check if the price is less than 50.*/

select distinct bk.bookno, bk.title
from book bk, citesBooks(bk.bookno) cb1, citesBooks(bk.bookno) cb2
where cb1.bookno = 2001 and 
	cb2.bookno <> cb1.bookno and 
	cb2.price < 50;

\qecho ''
\qecho ''
\qecho 'Question 15(b)'
\qecho ''
\qecho '' 

/*For each book in the book relation, i check if the parameterised view gives an output in which
books are not same.*/

select distinct bk.bookno, bk.title
from book bk, citesBooks(bk.bookno) cb1, citesBooks(bk.bookno) cb2
where cb2.bookno <> cb1.bookno;

drop function citesBooks;
-- connect to default database
\c postgres;

--Drop database created
drop database assignment2vkvats;




COPY student TO 'Desktop/student.csv' DELIMITER ',' CSV HEADER;
COPY Book TO 'D:/courses sem 2/ADC/assignments/Assignment 7/book.csv' DELIMITER ',' CSV HEADER;
COPY Buys TO 'D:/courses sem 2/ADC/assignments/Assignment 7/buys.csv' DELIMITER ',' CSV HEADER;
COPY Cites TO 'D:/courses sem 2/ADC/assignments/Assignment 7/cites.csv' DELIMITER ',' CSV HEADER;
COPY Major TO 'D:/courses sem 2/ADC/assignments/Assignment 7/major.csv' DELIMITER ',' CSV HEADER;




















