/*
drop table student;
drop table  book;
drop table major;
drop table buys;
drop table cites;

create table student (sid int, sname text);
create table book (bookno int, title text, price int);
create table major (sid int, major text);
create table buys (sid int, bookno int);
create table cites (bookno int, citedbookno int);

delete from student;
delete from book;
delete from  major;
delete from buys;
delete from  cites;


-- Data for the student relation.

insert into student values (1021, 'Kris');

insert into major values (1021, 'CS'), (1021, 'Math');


insert into book values
   (4001, 'LinearAlgebra', 30),
   (4002, 'MeasureTheory', 75),
   (4003, 'OptimizationTheory', 30);


insert into buys values 
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


INSERT INTO student VALUES(1001,'Jean');
INSERT INTO student VALUES(1002,'Maria');
INSERT INTO student VALUES(1003,'Anna');
INSERT INTO student VALUES(1004,'Chin');
INSERT INTO student VALUES(1005,'John');
INSERT INTO student VALUES(1006,'Ryan');
INSERT INTO student VALUES(1007,'Catherine');
INSERT INTO student VALUES(1008,'Emma');
INSERT INTO student VALUES(1009,'Jan');
INSERT INTO student VALUES(1010,'Linda');
INSERT INTO student VALUES(1011,'Nick');
INSERT INTO student VALUES(1012,'Eric');
INSERT INTO student VALUES(1013,'Lisa');
INSERT INTO student VALUES(1014,'Filip');
INSERT INTO student VALUES(1015,'Dirk');
INSERT INTO student VALUES(1016,'Mary');
INSERT INTO student VALUES(1017,'Ellen');
INSERT INTO student VALUES(1020,'Ahmed');

-- Data for the book relation.
INSERT INTO book VALUES(2001,'Databases',40);
INSERT INTO book VALUES(2002,'OperatingSystems',25);
INSERT INTO book VALUES(2003,'Networks',20);
INSERT INTO book VALUES(2004,'AI',45);
INSERT INTO book VALUES(2005,'DiscreteMathematics',20);
INSERT INTO book VALUES(2006,'SQL',25);
INSERT INTO book VALUES(2007,'ProgrammingLanguages',15);
INSERT INTO book VALUES(2008,'DataScience',50);
INSERT INTO book VALUES(2009,'Calculus',10);
INSERT INTO book VALUES(2010,'Philosophy',25);
INSERT INTO book VALUES(2012,'Geometry',80);
INSERT INTO book VALUES(2013,'RealAnalysis',35);
INSERT INTO book VALUES(2011,'Anthropology',50);
INSERT INTO book VALUES(3000,'MachineLearning',40);


-- Data for the buys relation.

INSERT INTO buys VALUES(1001,2002);
INSERT INTO buys VALUES(1001,2007);
INSERT INTO buys VALUES(1001,2009);
INSERT INTO buys VALUES(1001,2011);
INSERT INTO buys VALUES(1001,2013);
INSERT INTO buys VALUES(1002,2001);
INSERT INTO buys VALUES(1002,2002);
INSERT INTO buys VALUES(1002,2007);
INSERT INTO buys VALUES(1002,2011);
INSERT INTO buys VALUES(1002,2012);
INSERT INTO buys VALUES(1002,2013);
INSERT INTO buys VALUES(1003,2002);
INSERT INTO buys VALUES(1003,2007);
INSERT INTO buys VALUES(1003,2011);
INSERT INTO buys VALUES(1003,2012);
INSERT INTO buys VALUES(1003,2013);
INSERT INTO buys VALUES(1004,2006);
INSERT INTO buys VALUES(1004,2007);
INSERT INTO buys VALUES(1004,2008);
INSERT INTO buys VALUES(1004,2011);
INSERT INTO buys VALUES(1004,2012);
INSERT INTO buys VALUES(1004,2013);
INSERT INTO buys VALUES(1005,2007);
INSERT INTO buys VALUES(1005,2011);
INSERT INTO buys VALUES(1005,2012);
INSERT INTO buys VALUES(1005,2013);
INSERT INTO buys VALUES(1006,2006);
INSERT INTO buys VALUES(1006,2007);
INSERT INTO buys VALUES(1006,2008);
INSERT INTO buys VALUES(1006,2011);
INSERT INTO buys VALUES(1006,2012);
INSERT INTO buys VALUES(1006,2013);
INSERT INTO buys VALUES(1007,2001);
INSERT INTO buys VALUES(1007,2002);
INSERT INTO buys VALUES(1007,2003);
INSERT INTO buys VALUES(1007,2007);
INSERT INTO buys VALUES(1007,2008);
INSERT INTO buys VALUES(1007,2009);
INSERT INTO buys VALUES(1007,2010);
INSERT INTO buys VALUES(1007,2011);
INSERT INTO buys VALUES(1007,2012);
INSERT INTO buys VALUES(1007,2013);
INSERT INTO buys VALUES(1008,2007);
INSERT INTO buys VALUES(1008,2011);
INSERT INTO buys VALUES(1008,2012);
INSERT INTO buys VALUES(1008,2013);
INSERT INTO buys VALUES(1009,2001);
INSERT INTO buys VALUES(1009,2002);
INSERT INTO buys VALUES(1009,2011);
INSERT INTO buys VALUES(1009,2012);
INSERT INTO buys VALUES(1009,2013);
INSERT INTO buys VALUES(1010,2001);
INSERT INTO buys VALUES(1010,2002);
INSERT INTO buys VALUES(1010,2003);
INSERT INTO buys VALUES(1010,2011);
INSERT INTO buys VALUES(1010,2012);
INSERT INTO buys VALUES(1010,2013);
INSERT INTO buys VALUES(1011,2002);
INSERT INTO buys VALUES(1011,2011);
INSERT INTO buys VALUES(1011,2012);
INSERT INTO buys VALUES(1012,2011);
INSERT INTO buys VALUES(1012,2012);
INSERT INTO buys VALUES(1013,2001);
INSERT INTO buys VALUES(1013,2011);
INSERT INTO buys VALUES(1013,2012);
INSERT INTO buys VALUES(1014,2008);
INSERT INTO buys VALUES(1014,2011);
INSERT INTO buys VALUES(1014,2012);
INSERT INTO buys VALUES(1017,2001);
INSERT INTO buys VALUES(1017,2002);
INSERT INTO buys VALUES(1017,2003);
INSERT INTO buys VALUES(1017,2008);
INSERT INTO buys VALUES(1017,2012);
INSERT INTO buys VALUES(1020,2012);

-- Data for the cites relation.
INSERT INTO cites VALUES(2012,2001);
INSERT INTO cites VALUES(2008,2011);
INSERT INTO cites VALUES(2008,2012);
INSERT INTO cites VALUES(2001,2002);
INSERT INTO cites VALUES(2001,2007);
INSERT INTO cites VALUES(2002,2003);
INSERT INTO cites VALUES(2003,2001);
INSERT INTO cites VALUES(2003,2004);
INSERT INTO cites VALUES(2003,2002);
INSERT INTO cites VALUES(2012,2005);


-- Data for the major relation.

INSERT INTO major VALUES(1001,'Math');
INSERT INTO major VALUES(1001,'Physics');
INSERT INTO major VALUES(1002,'CS');
INSERT INTO major VALUES(1002,'Math');
INSERT INTO major VALUES(1003,'Math');
INSERT INTO major VALUES(1004,'CS');
INSERT INTO major VALUES(1006,'CS');
INSERT INTO major VALUES(1007,'CS');
INSERT INTO major VALUES(1007,'Physics');
INSERT INTO major VALUES(1008,'Physics');
INSERT INTO major VALUES(1009,'Biology');
INSERT INTO major VALUES(1010,'Biology');
INSERT INTO major VALUES(1011,'CS');
INSERT INTO major VALUES(1011,'Math');
INSERT INTO major VALUES(1012,'CS');
INSERT INTO major VALUES(1013,'CS');
INSERT INTO major VALUES(1013,'Psychology');
INSERT INTO major VALUES(1014,'Theater');
INSERT INTO major VALUES(1017,'Anthropology');


*/

------------------------------- Problem 1 ------------------------------------

\qecho 'problem 1';



select not exists( select a.x from A a except select b.x from B b) as empty_a_minus_b,
       not exists( select b.x from B b except select a.x from A a) as empty_b_minus_a,
       not exists( select a.x from A a intersect select b.x from B b) as empty_a_interesect_b;



------------------------------- Problem 2 ------------------------------------

\qecho 'problem 2';

-- (p -> q) -> (not r)
-- is equivalent with
-- (p and not q) or not r

drop table p;
drop table q;
drop table r;

create table p(value boolean);
create table q(value boolean);
create table r(value boolean);

insert into p values (true), (false), (NULL);
insert into q values (true), (false), (NULL);
insert into r values (true), (false), (NULL);


select p.value as p, q.value as q, r.value as r, (p.value and not(q.value)) or not(r.value) as value
from   p, q, r;
 
------------------------------- Problem 3 ------------------------------------
\qecho 'problem 3 a'

drop table point;
create table point(pid int, x int, y int);

insert into point values
   (1,0,0),
   (2,0,1),
   (3,1,0),
   (4,1,1),
   (5,2,2),
   (6,0,2);

create or replace function distance(x1 int, y1 int, x2 int, y2 int)
  returns float as
  $$
   select sqrt(power(x1-x2,2)+power(y1-y2,2));
  $$ language sql;


select p1.pid as p1, p2.pid as p2
from   point p1, point p2
where  distance(p1.x, p1.y, p2.x, p2.y) <= ALL (select distance(p3.x,p3.y,p4.x,p4.y)
                                                from   point p3, point p4
                                                where  p3.pid <> p4.pid) and
       p1.pid <> p2.pid order by 1,2;


\qecho 'Problem 3.b'

-- Three distinct points
-- (x1,y1)
-- (x2,y2)
-- (x3,y3)
-- are collinear
-- if (x1 - x2)(y2 - y3) = (y1 - y2)(x2 - x3)


select  p1.pid as p1, p2.pid as p2, p3.pid as p3
from    point p1, point p2, point p3
where   p1.pid <> p2.pid and p1.pid <> p3.pid and p2.pid <> p3.pid and
        (p1.x - p2.x)*(p2.y-p3.y) = (p2.x-p3.x)*(p1.y-p2.y) order by 1,2,3;;


-- Problem 4 --

-- Determine if A is a primary key for R(A,B,C)

\qecho 'Problem 4'

drop table r;
create table r (a int, b int, c int);

insert into r values (1,1,1), (2,2,1), (4,7,3);
table r;

select not exists (select 1
                   from   R r1, R r2
                   where  r1.A = r2.A and (r1.B <> r2.B or r1.C <> r2.C)) 
as A_is_Primary_Key_of_Relation_R;


drop table r;
create table r (a int, b int, c int);


insert into r values (1,1,1), (1,2,1), (2,2,1), (2,2,2), (3,1,1);
table r;


select not exists (select 1
                   from   R r1, R r2
                   where  r1.A = r2.A and (r1.B <> r2.B or r1.C <> r2.C)) 
as A_is_Primary_Key_of_Relation_R;


-- Problem 5  Matrix square problem

\qecho 'Problem 5'

DROP TABLE M;

CREATE TABLE M (row int, colmn int, value int);


INSERT INTO M VALUES
  (1, 1, 1),
  (1, 2, 2),
  (1, 3, 3),
  (2, 1, 1),
  (2, 2, -3),
  (2, 3, 5),
  (3, 1, 4),
  (3, 2, 0),
  (3, 3, -2);

TABLE M;


WITH M_Squared AS (SELECT e1.row, e2.colmn, SUM(e1.value * e2.value) AS Value
                   FROM   M e1, M e2
                   WHERE  e1.colmn = e2.row
                   GROUP BY (e1.row, e2.colmn)),
     M_Squared_Squared AS  (SELECT e1.row, e2.colmn, SUM(e1.value * e2.value) as value
                            FROM   M_Squared e1, M_Squared e2
                            WHERE  e1.colmn = e2.row
                            GROUP BY (e1.row, e2.colmn))
SELECT * FROM M_Squared_Squared order by 1,2;
 -- Problem 6

\qecho 'Problem 6'

drop table a;

create table a (x int);



insert into a values (1), (2), (3), (4),
                     (2*1), (2*3), (-2*3),
                     (5*1), (6*2), (-5*4),
                     (10*1), (3), (4*101), (14*14);

table a;

select mod( 4 + mod(e.x,4), 4), count(1)
from   A e
group by ( mod(4 + mod(e.x,4), 4) ) order by 1;


-- if we are guarenteed that the integer in A are non-negative, 
-- the solution is simpler

delete from a;

delete from a;

insert into a values (1), (2), (3), (4),
                     (2*1), (2*3), (2*3),
                     (5*1), (6*2), (5*4),
                     (10*1), (3), (4*101), (14*14);

table a;

select mod(e.x,4), count(1)
from   A e
group by ( mod(e.x,4) ) order by 1;

-- Problem 7
\qecho 'Problem 7'
drop table a;

create table A (x int);

insert into a values (5), (3), (3), (2), (1), (3), (5);

select a.x
from   A a
group by (a.x) order by 1;





-- Problem 8.a
-- ``Find the bookno's and titles of books that cost less than \$40
-- and that where bought by fewer than 3 CS students."


select b.bookno, b.title
from   book b
where  b.price < 40 and
       (select count(m.sid)
        from   major m 
        where  m.major = 'CS' and
                  m.sid in  (select t.sid
                             from   buys  t
                             where  t.bookno = b.bookno)) < 3 order by 1,2;


-- Problem 8.b
-- ``For each student, find the sid and name of that student along
-- with the number of books bought by that student, provided that the
-- collective cost of these books is less that \$200.''

\qecho 'problem 8.b';


create or replace function priceOfBooksBoughtByStudent(s int) 
returns bigint as
$$
select sum(b.price)
from   book b
where  b.bookno in (select t.bookno
                    from   buys t
                    where  t.sid = s)
union
select 0 where not exists (select t.bookno
                           from   buys t
                           where  t.sid = s);
$$ language sql;

select s.sid, s.sname, (select count(t.bookno)
                        from   buys t
                        where  t.sid = s.sid) as numberOfBooksBought
from   student s
where  priceOfBooksBoughtByStudent(s.sid) < 200 order by 1,2,3;

-- Problem 8.c 
--``Find the sids and names of the students who spent the most on the
-- books that they bought."

\qecho 'problem 8.c';



select s.sid, sname
from   student s
where  priceOfBooksBoughtByStudent(s.sid) = (select max(priceOfBooksBoughtByStudent(s1.sid))
                                             from   student s1) order by 1,2;


-- Problem 8.d
-- ``For each major, specify the combined cost of all the books bought
-- by students with that major."

\qecho 'problem 8.d';


select m.major, sum(priceOfBooksBoughtByStudent(m.sid)) as totalPriceOfBooksBought
from   major m
group  by (m.major) order by 1,2;



-- Problem 8.e
-- ``Find the pairs of different booknos $(b_1,b_2)$ that were bought by
-- the same number of CS students."

\qecho 'problem 8.e';


create or replace function numberOfCSStudentsWhoBoughtBook(b int)
returns bigint as
$$
select count(1)
from   buys t
where  t.bookno = b and t.sid in (select m.sid
                                  from   major m
                                  where  m.major = 'CS');
$$ language sql;


select b1.bookno as b1, b2.bookno as b2
from   book b1, book b2
where  b1.bookno <> b2.bookno and
       numberOfCSStudentsWhoBoughtBook(b1.bookno) = numberOfCSStudentsWhoBoughtBook(b2.bookno) 
order by 1,2;


---
--- Problem 9
--- Find the sid and name of each student who did not buy all the books that cost more than \$50

\qecho 'problem 9';

create or replace function BookBoughtByStudent(s int) 
returns table (bookno int) as
$$
select t.bookno
from   buys t
where  t.sid = s order by 1; 
$$ language sql;


create or replace view bookMoreThan50 as
(select b.bookno
 from   book b
 where  b.price > 50 order by 1);


select s.sid, s.sname
from   student s
where  exists (select bookno
               from   bookMoreThan50
               except
               select bookno
               from   bookBoughtByStudent(s.sid)) 
order by 1,2;


--- Problem 10
-- Find the bookno and title of each book that was not only bought by
-- students who major in both `CS' or in `Math'.

\qecho 'problem 10'

create or replace function StudentWhoBoughtBook(b int) 
returns table (sid int) as
$$
select t.sid
from   buys t
where  t.bookno = b order by 1; 
$$ language sql;


create or replace view CSorMathMajor as
(select s.sid
 from   student s
 where  s.sid in (select m.sid
                  from   major m
                  where  m.major = 'CS') or
        s.sid in (select m.sid
                  from   major m
                  where  m.major = 'Math'));


select b.bookno, b.title
from   book b
where  exists (select sid
               from   studentWhoBoughtBook(b.bookno)
               except
               select sid
               from   CSorMathMajor)
order by 1,2;


-- Problem 11
-- Find the sid and name of each student who bought none of the least expensive books.
\qecho 'problem 11'

create or replace function BookBoughtByStudent(s int) 
returns table (bookno int) as
$$
select t.bookno
from   buys t
where  t.sid = s order by 1; 
$$ language sql;


create or replace view leastExpensiveBook as
(select  b.bookno
 from    book b
 where   b.price = (select min(b1.price)
                    from   book b1));


select s.sid, s.sname
from   student s
where  not exists (select bookno
                   from   leastExpensiveBook
                   intersect
                   select bookno
                   from   bookBoughtByStudent(s.sid))
order by 1,2;



-- Problem 12
-- Find the pairs of booknos $(b_1,b_2)$ of different books that where
-- bought by the same set of CS students.

\qecho 'problem 12';


create or replace function CSStudentWhoBoughtBook(b int) 
returns table (sid int) as
$$
select t.sid
from   buys t
where  t.bookno = b and t.sid in (select m.sid
                                  from   major m
                                  where  m.major = 'CS');

$$ language sql;

select b1.bookno as b1, b2.bookno as b2
from   book b1, book b2
where  b1.bookno <> b2.bookno and
       not exists (select sid
                   from   CSStudentWhoBoughtBook(b1.bookno)
                   except
                   select sid
                   from   CSStudentWhoBoughtBook(b2.bookno)) and
       not exists (select sid
                   from   CSStudentWhoBoughtBook(b2.bookno)
                   except
                   select sid
                   from   CSStudentWhoBoughtBook(b1.bookno))
order by 1,2;


-- Problem 13
-- Find sid and name of each CS student who bought fewer than 4 books
-- that cost less that \$50.

\qecho 'problem 13';

create or replace function BookBoughtByStudent(s int) 
returns table (bookno int) as
$$
select t.bookno
from   buys t
where  t.sid = s order by 1; 
$$ language sql;


create or replace view BookLessThan50 as
(select b.bookno 
 from   book b
 where  b.price < 50);


select s.sid, s.sname
from   student s
where  (select count(1)
        from   (select bookno
                from   BookBoughtByStudent(sid)
                intersect
                select bookno
                from   BookLessThan50) q) < 4 and
        s.sid in (select m.sid
                  from   major m
                  where  m.major = 'CS')
order by 1,2;


-- Problem 14 
-- Find the bookno and title of each book that was bought by an odd
-- number of CS students.


\qecho 'problem 14';

create or replace function StudentWhoBoughtBook(b int) 
returns table (sid int) as
$$
select t.sid
from   buys t
where  t.bookno = b order by 1; 
$$ language sql;


create or replace view CSstudent as
(select m.sid
 from   major m
 where  m.major = 'CS'
);

select b.bookno, b.title
from   book b
where  mod((select count(1)
            from   (select sid
                    from   studentWhoBoughtBook(b.bookno)
                    intersect
                    select sid
                    from   CSstudent) q), 2) = 1
order by 1,2;


--  Greatly simplified
/*select b.bookno, b.title
from   book b
where  mod((select count(1)
            from   studentWhoBoughtBook(b.bookno)),2)=1
order by 1,2;
*/

-- Problem 15
-- Find the sid and name of each student who bought all but 3 books.

\qecho 'problem 15';

create or replace function BookBoughtByStudent(s int) 
returns table (bookno int) as
$$
select t.bookno
from   buys t
where  t.sid = s order by 1; 
$$ language sql;


create or replace view BookBookno as
(select b.bookno 
 from   book b);


select s.sid, s.sname
from   student s
where  (select count(1)
        from   (select bookno
                from   BookBookno
                except
                select bookno
                from   bookBoughtByStudent(s.sid)) q) = 3
order by 1,2;

-- Problem 16
-- Find the pairs of booknos $(b_1,b_2)$ of different books such that
-- all the students who bought book $b_1$ also bought book $b_2$.

\qecho 'problem 16';

create or replace function StudentWhoBoughtBook(b int) 
returns table (sid int) as
$$
select t.sid
from   buys t
where  t.bookno = b order by 1; 
$$ language sql;

select b1.bookno as b1, b2.bookno as b2
from   book b1, book b2
where  b1.bookno <> b2.bookno and
       (select count(1)
        from  (select sid
               from   StudentWhoBoughtBook(b1.bookno)
               except
               select sid
               from   StudentWhoBoughtBook(b2.bookno)) q) = 0 order by 1,2;






