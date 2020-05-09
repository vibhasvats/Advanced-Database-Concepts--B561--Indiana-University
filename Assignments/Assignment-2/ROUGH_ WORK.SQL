QUESTION 7
--it doesnt include any book that cites only most expensive book.
select distinct bk.bookno, bk.title, bk.price 
from book bk, cites c 
where c.bookno = bk.bookno and 
	c.bookno not in (select distinct c.bookno 
						from cites c 
						where c.citedbookno in (select bk1.bookno 
													from book bk1 
													where bk1.price >= ALL (select bk2.price 
																		  from book bk2)));

-- students who has common majors but have bought at least one common book, 
-- so there is no one who has same major but all different books
select distinct m1.sid, m2.sid 
from major m1, major m2 
where m1.major = m2.major and 
	m1.sid <> m2.sid and 
	m1.sid not in (select distinct b1.sid 
					from buys b1, buys b2 
					where b1.bookno = b2.bookno) and 
	m2.sid not in (select distinct b1.sid 
					from buys b1, buys b2 
					where b1.bookno = b2.bookno);

