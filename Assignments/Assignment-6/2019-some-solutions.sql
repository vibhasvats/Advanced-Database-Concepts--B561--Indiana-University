-- Solutions B561 2019 Assignment 6

-- Problem 4.a Translate and optimize
select s.sid, s.sname
from   student s
where  s.sid in (select m.sid from major m where m.major = 'CS') AND
       exists (select 1
               from   buys t, cites c, book b1, book b2
               where  s.sid = t.sid and t.bookno = c.citedbookno and
                      c.citedbookno = b1.bookno and c.bookno = b2.bookno and
                      b1.price > b2.price)
order by 1,2;

-- eliminate in and exists

select distinct s.sid, s.sname
from   student s, buys t, cites c, book b1, book b2, major m
where  s.sid = m.sid and m.major = 'CS' and
       s.sid = t.sid and t.bookno = c.citedbookno and
       c.citedbookno = b1.bookno and c.bookno = b2.bookno and
       b1.price > b2.price
order by 1,2;

-- push m.major = 'CS' to major relation

with  CSmajor as (select m.sid, m.major from major m where m.major = 'CS')
select distinct s.sid, s.sname
from   student s, buys t, cites c, book b1, book b2, CSmajor m
where  s.sid = m.sid and
       s.sid = t.sid and t.bookno = c.citedbookno and
       c.citedbookno = b1.bookno and c.bookno = b2.bookno and
       b1.price > b2.price
order by 1,2;

-- form natural join between student and CS major and then with
-- buys 

with  CSmajor as (select m.sid, m.major from major m where m.major = 'CS')
select distinct s.sid, s.sname
from   student s 
       natural join CSmajor m
       natural join buys t, cites c, book b1, book b2
where  t.bookno = c.citedbookno and
       c.citedbookno = b1.bookno and 
       c.bookno = b2.bookno and
       b1.price > b2.price
order by 1,2;

-- join with cites

with  CSmajor as (select m.sid, m.major from major m where m.major = 'CS')
select distinct s.sid, s.sname
from   (student s 
        natural join CSmajor m
        natural join buys t) join cites c on(t.bookno = c.citedbookno), book b1, book b2
where  c.citedbookno = b1.bookno and 
       c.bookno = b2.bookno and
       b1.price > b2.price
order by 1,2;

-- join with book b1 

with  CSmajor as (select m.sid, m.major from major m where m.major = 'CS')
select distinct s.sid, s.sname
from   ((student s 
         natural join CSmajor m
         natural join buys t) 
         join cites c on(t.bookno = c.citedbookno))
         join book b1 on (c.citedbookno = b1.bookno), book b2
where  c.bookno = b2.bookno and
       b1.price > b2.price
order by 1,2;

-- join with book b2 and include b1.price > b2.price

with  CSmajor as (select m.sid, m.major from major m where m.major = 'CS')
select distinct s.sid, s.sname
from   (student s 
        natural join CSmajor m
        natural join buys t) 
        join cites c on (t.bookno = c.citedbookno)
        join book b1 on (c.citedbookno = b1.bookno)
        join book b2 on (c.bookno = b2.bookno and b1.price > b2.price)
order by 1,2;

-- we can now start optimizing
-- we push selections and projections in where possible

with  CS as (select distinct m.sid as sid from major m where m.major = 'CS'),
      T as (select distinct s.sid, s.sname, t.bookno 
            from   student s 
                   natural join CS m
                   natural join buys t),
      B as (select distinct bookno, price from book),
      C as (select c.citedbookno
            from   cites c
                   join B b1 on (c.citedbookno = b1.bookno)
                   join B b2 on (c.bookno = b2.bookno and b1.price > b2.price))
select distinct t.sid, t.sname 
from    T t join C c on (t.bookno = c.citedbookno)
order by 1,2;


-- Problem 4.c
select distinct t.sid, b.bookno
from   buys t, book b
where  t.bookno = b.bookno and
       b.price <= ALL (select b1.price
                       from   buys t1, book b1
                       where t1.bookno = b1.bookno and t1.sid = t.sid)
order by 1,2;

-- replacing <= ALL using NOT EXISTS

select distinct t.sid, b.bookno
from   buys t, book b
where  t.bookno = b.bookno and
       not exists (select b1.price
                   from   buys t1, book b1
                   where t1.bookno = b1.bookno and t1.sid = t.sid and b.price > b1.price)
order by 1,2;

-- introducing joins
select distinct t.sid, b.bookno
from   buys t natural join book b
where  not exists (select b1.price
                   from   buys t1 natural join book b1
                   where  t1.sid = t.sid and b.price > b1.price)
order by 1,2;

-- eliminating not exists
select distinct q.sid, q.tbookno
from   (select t.sid, t.bookno as tbookno, b.* 
        from   buys t natural join book b
        except
        select t.*, b.*
        from   buys t natural join book b, buys t1 natural join book b1
        where  t1.sid = t.sid and b.price > b1.price) q
order by 1,2;

-- introducing join
select distinct q.sid, q.tbookno
from   (select t.sid, t.bookno as tbookno, b.* 
        from   buys t natural join book b
        except
        select t.*, b.*
        from   (buys t natural join book b) join (buys t1 natural join book b1) on
               (t.sid = t1.sid and b.price > b1.price)) q
order by 1,2;

-- We can now start the optimization
with books as (select bookno, price from book)
select distinct q.sid, q.tbookno
from   (select t.sid, t.bookno as tbookno, b.*
        from   buys t natural join books b
        except
        select t.*, b.*
        from   (buys t natural join books b) join (buys t1 natural join books b1) on
               (t.sid = t1.sid and b.price > b1.price)) q
order by 1,2;








-- Problem 12.a
-- Find the bookno of each book that is cited by at least
-- one book that cost less than \$50.

select 'Problem 12.a';

select  b.bookno
from    book b
where   exists
        (select 1
         from   book b1, book_citedbooks bc
         where  b1.price < 50 and b1.bookno = bc.bookno and
                memberof(b.bookno,bc.citedbooks))
order by bookno;


--  Problem 12.c
--  Find the bookno of each book that is cited by exactly one book.

select 'Problem 12.c';

select  bc.bookno
from    book_citingbooks bc
where   cardinality(bc.citingbooks) = 1
order by 1;

--  Problem 12.d
--  Find the sid of each student who bought all books that
--  cost more than\$50.

select 'Problem 12.d';

select  s.sid
from    student_books s
where   array(select bookno from book where price >50) <@ s.books;

-- Problem 12.e
-- Find the sid of each student who bought no book that cost more
-- than \$50.

select 'Problem 12.e';

select  s.sid
from    student_books s
where   not(array(select bookno from book where price >50) && s.books);

-- Problem 12.h
-- Find sid-bookno pairs $(s,b)$ such that not all books
-- bought by student $s$ are books that cite book $b$.

-- I.e, Find sid-bookno pairs $(s,b)$ such that student s does not
-- only buys books that cite book $b$.

select 'Problem 12.h';

select distinct s.sid, b.bookno 
from   student_books s, book_citingbooks b 
where  not(s.books <@ b.citingbooks) 
order by 1,2;

select 'Problem 12.l';

select b.bookno
from   book_citedbooks b
where  cardinality( setdifference( array(select b.bookno from book b), b.citedbooks)) = 3;

-- bookno 
--------
--   2010
-- (1 row)

