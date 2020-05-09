-- Creating database with my initials
create database assignment1vkvats;

-- connecting database
\c assignment1vkvats;
\qecho ''
\qecho ''
\qecho 'Question 1.2.'  
\qecho ''
\qecho ''
\qecho '6 examples that illustrate how the presence or absence of primary and'
\qecho 'foreign keys affects insert and deletes in these relations'
\qecho ''
\qecho ''
\qecho 'Example 1: Inserting tuple with and without primary key'
\qecho ''
\qecho ''
\qecho 'inserting without primary key'
\qecho ''
CREATE TABLE Sailor(
	sid INT NOT NULL,
	sname TEXT NOT NULL,
	rating INT
	);
INSERT INTO sailor VALUES
(22,   'Dustin',       7),
(22,   'Dustin',       7),
(22,   'Dustin',       7);

select * from sailor;
\qecho ' Without primary key we can insert same tuple multiple times without any restriction.'
drop table Sailor;
\qecho ''
\qecho 'inserting with primary key'
\qecho ''
CREATE TABLE Sailor(
	sid INT PRIMARY KEY,
	sname TEXT NOT NULL,
	rating INT
	);
INSERT INTO sailor VALUES
(22,   'Dustin',       7);
\qecho ''
\qecho 'inserting same tuple again'
\qecho ''
INSERT INTO sailor VALUES
(22,   'Dustin',       7);

select * from sailor;
\qecho 'There is only one tuple in the relation even when we tried to insert two same tuples. primary key do not allow multiple insertion with similar primary key values.'
\qecho ''
drop table sailor;
\qecho ''
\qecho ''
\qecho 'Example 2: Deleting tuple with and without primary key'
\qecho ''
\qecho ''
\qecho 'relation without primary key constraint'
\qecho ''
CREATE TABLE Sailor(
	sid INT NOT NULL,
	sname TEXT NOT NULL,
	rating INT
	);
INSERT INTO sailor VALUES
(22,   'Dustin',       7),
(22,   'Dustin',       7),
(22,   'Dustin',       7);

select * from sailor;
\qecho ''
\qecho 'there are 3 entires with same sid, now I try to delete one tuple of sid = 22'
Delete from sailor s
where s.sid = 22;

select * from sailor;

\qecho 'all tuples with sid =22 are deleted, so we have no control over any specific tuple when deleting.'
drop table sailor;

\qecho ''
\qecho 'relation with primary key constraint'
CREATE TABLE Sailor(
	sid INT PRIMARY KEY,
	sname TEXT NOT NULL,
	rating INT
	);
INSERT INTO sailor VALUES
(22,   'Dustin',       7),
(29,   'Brutus',       1),
(31,   'Lubber',       8);
select * from sailor;
\qecho 'Now with primary key, we wont have two tuple with all similar variable and we will be able to delete selectively'
delete from sailor s 
where s.sid =  22;

select * from sailor;

drop table sailor;

\qecho ''
\qecho ''
\qecho 'Example 3: Inserting tuple with foreign key references'
\qecho ''
\qecho ''
\qecho 'when two relation are referenced with foreign key, tuple in relation with foreign key can only be inserted if it'
\qecho 'satisfies the foreign key constraint else it will not be inserted'
CREATE TABLE Sailor(
	sid INT PRIMARY KEY,
	sname TEXT NOT NULL,
	rating INT
	);
CREATE TABLE Reserves(
	sid INT,
	bid INT,
	day TEXT,
	PRIMARY KEY(sid,bid),
	FOREIGN KEY (sid) references Sailor(sid)
	);
\qecho 'I made two tables, sailor and reserves, reserves has foreign key sid referenced to sailor.sid'
INSERT INTO sailor VALUES
(22,   'Dustin',       7),
(29,   'Brutus',       1);
select * from sailor;
\qecho 'inserted two entires in sailor with sid 22 and 29.'
\qecho ''
\qecho 'trying to insert data in table reserves with sid already in sailor table'
INSERT INTO Reserves VALUES
(22,	101,	'Monday'),
(22,	102,	'Tuesday');

select * from Reserves;

\qecho ''
\qecho 'trying to insert data in table reserves with sid not present in sailor table'

INSERT INTO Reserves VALUES
(30,	101,	'Monday');

select * from Reserves;

\qecho 'the insertion is rejected as it violates foreign key constraint'

drop table Reserves, sailor;

\qecho ''
\qecho ''
\qecho 'Example 4: Dropping table with foreign key reference when cascade is allowed and cascade is not allowed'
\qecho ''
\qecho ''
\qecho 'Dropping table when cascading is not allowed.'
CREATE TABLE Sailor(
	sid INT PRIMARY KEY,
	sname TEXT NOT NULL,
	rating INT
	);

CREATE TABLE Boat( 
	bid INT PRIMARY KEY,
	bname TEXT NOT NULL,
	color TEXT
	);

CREATE TABLE Reserves(
	sid INT,
	bid INT,
	day TEXT,
	PRIMARY KEY(sid, bid),
	FOREIGN KEY (sid) references Sailor(sid),
	FOREIGN KEY (bid) references Boat(bid)
	);
\qecho 'created three tables Sailor, Boat and Reserves'
\qecho ''
\qecho 'Dropping tables when cascading is not allowed'

\d Reserves;
drop table Sailor;

\qecho 'The description shows that the foreign key restriction did not allow Sailor to be dropped.'
drop table Reserves;
\qecho ''
\qecho 'dropping table when cascading is allowed'

CREATE TABLE Reserves(
	sid INT,
	bid INT,
	day TEXT,
	PRIMARY KEY(sid, bid),
	FOREIGN KEY (sid) references Sailor(sid) on delete cascade,
	FOREIGN KEY (bid) references Boat(bid) on delete cascade
	);
\qecho 'created three tables Reserves with cascading allowed.'

\d Reserves;
drop table Sailor cascade;
\d Reserves;
\qecho 'The description shows that the foreign key restriction are removed when we try to drop Sailor table.'
drop table Boat, Reserves;

\qecho ''
\qecho ''
\qecho 'Example 5: Deleting tuple without foreign key when cascading is allowed'
\qecho ''
\qecho ''
\qecho 'We can delete tuple with CASCADE command when cascading is allowed.'
\qecho 'creating two table Sailor and Reserves in which cascading is allowed'

CREATE TABLE Sailor(
	sid INT PRIMARY KEY,
	sname TEXT NOT NULL,
	rating INT
	);
CREATE TABLE Reserves(
	sid INT,
	bid INT,
	day TEXT,
	PRIMARY KEY(sid,bid),
	FOREIGN KEY (sid) references Sailor(sid) on delete cascade
	);
	
INSERT INTO sailor VALUES
(22,   'Dustin',       7),
(29,   'Brutus',       1);
select * from sailor;
\qecho 'inserted two entires in sailor with sid 22 and 29.'
\qecho ''
\qecho 'trying to insert data in table reserves table'
INSERT INTO Reserves VALUES
(22,	101,	'Monday'),
(29,	102,	'Tuesday');

select * from Reserves;
\qecho 'Deleting from sailor the entry with sid = 29. It will also be deleted from Reserves table automatically'
delete from Sailor s 
where s.sid = 29;

select * from Sailor;

select * from Reserves;

\qecho 'The entry with sid 29 is deleted from both tables.'
drop table Reserves, Sailor;

\qecho ''
\qecho ''
\qecho 'Example 6: Deleting tuple without foreign key when deletion is restricted.'
\qecho ''
\qecho ''
\qecho 'We can not delete tuple with CASCADE command when cascading is RESTRICTED.'
\qecho 'creating two table Sailor and Reserves in which cascading is restricted'

CREATE TABLE Sailor(
	sid INT PRIMARY KEY,
	sname TEXT NOT NULL,
	rating INT
	);
CREATE TABLE Reserves(
	sid INT ,
	bid INT ,
	day TEXT,
	PRIMARY KEY(sid,bid),
	FOREIGN KEY (sid) references Sailor(sid) on delete RESTRICT
	);
	
INSERT INTO sailor VALUES
(22,   'Dustin',       7),
(29,   'Brutus',       1);
select * from sailor;
\qecho 'inserted two entires in sailor with sid 22 and 29.'
\qecho ''
\qecho 'trying to insert data in table reserves table'
INSERT INTO Reserves VALUES
(22,	101,	'Monday'),
(29,	102,	'Tuesday');

select * from Reserves;
\qecho 'Deleting from sailor the entry with sid = 29. It not be allowed to be deleted from tables'
delete from Sailor s 
where s.sid = 29;

select * from Sailor;
select * from Reserves;

\qecho 'The entry with sid 29 is not deleted form both tables.'
drop table Reserves, Sailor;
\qecho ''
\qecho ''
\qecho ''
\qecho 'Question 1.1'
\qecho ''
\qecho ''
-- Table creation
CREATE TABLE Sailor(
	sid INT PRIMARY KEY,
	sname TEXT NOT NULL,
	rating INT
	);

CREATE TABLE Boat( 
	bid INT PRIMARY KEY,
	bname TEXT NOT NULL,
	color TEXT
	);

CREATE TABLE Reserves(
	sid INT ,
	bid INT ,
	day TEXT,
	PRIMARY KEY(sid, bid),
	FOREIGN KEY (sid) references Sailor(sid),
	FOREIGN KEY (bid) references Boat(bid)
	);

-- populating tables
INSERT INTO sailor VALUES
(22,   'Dustin',       7),
(29,   'Brutus',       1),
(31,   'Lubber',       8),
(32,   'Andy',         8),
(58,   'Rusty',        10),
(64,   'Horatio',      7),
(71,   'Zorba',        10),
(75,   'David',        8),
(74,   'Horatio',      9),
(85,   'Art',          3),
(95,   'Bob',          3);


INSERT INTO boat VALUES
(101,	'Interlake',	'blue'),
(102,	'Sunset',	'red'),
(103,	'Clipper',	'green'),
(104,	'Marine',	'red'),
(105,    'Indianapolis',     'blue');


INSERT INTO reserves VALUES
(22,	101,	'Monday'),
(22,	102,	'Tuesday'),
(22,	103,	'Wednesday'), 
(22,	105,	'Wednesday'), 
(31,	102,	'Thursday'), 
(31,	103,	'Friday'), 
(31, 	104,	'Saturday'),
(64,	101,	'Sunday'), 
(64,	102,	'Monday'), 
(74,	102,	'Saturday');

\qecho 'Sailor'
select * from Sailor;

\qecho 'Boat'
select * from Boat;

\qecho 'Reserves'
select * from Reserves;

\qecho ''
\qecho ''
\qecho 'Question 2.1'
\qecho ''
\qecho ''

SELECT s.sid, s.rating 
FROM Sailor s;

\qecho ''
\qecho ''
\qecho 'Question 2.2'
\qecho ''
\qecho ''

SELECT s.sid, s.sname, s.rating 
FROM Sailor s 
WHERE s.rating BETWEEN 2 AND 11 AND 
	s.rating NOT BETWEEN 8 AND 10;

\qecho ''
\qecho ''
\qecho 'Question 2.3'
\qecho ''
\qecho ''

select b.bid, b.bname, b.color 
from boat b, reserves r, sailor s 
where r.bid = b.bid and 
	r.sid = s.sid and 
	s.rating > 7 and 
	b.color <> 'red';
------------Alternate solution----------
select distinct  b.bid, b.bname, b.color 
from boat b
where b.color <> 'red' and 
exists (select 1 
	   from reserves r 
	   where r.bid = b.bid and 
	   exists(select 1 
			 from sailor s
			 where r.sid = s.sid and 
			 s.rating > 7));
---------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 2.4'
\qecho ''
\qecho ''

(select distinct b.bid, b.bname 
from boat b, reserves r1 
where b.bid = r1.bid and 
	r1.day in ('Saturday', 'Sunday'))
except 
(select b.bid, b.bname 
from boat b, reserves r2 
where b.bid = r2.bid and 
	r2.day = 'Tuesday');

\qecho ''
\qecho ''
\qecho 'Question 2.5'
\qecho ''
\qecho ''

(select distinct r1.sid 
from boat b1, reserves r1 
where b1.bid = r1.bid and 
 	b1.color = 'red')
intersect 
(select distinct r2.sid 
from boat b2, reserves r2 
where b2.bid = r2.bid and 
 	b2.color = 'green');

\qecho ''
\qecho ''
\qecho 'Question 2.6'
\qecho ''
\qecho ''

select distinct s.sid, s.sname 
from sailor s, reserves r1, reserves r2 
where s.sid = r1.sid and 
	s.sid = r2.sid and 
	r1.bid <> r2.bid
order by s.sid asc;

\qecho ''
\qecho ''
\qecho 'Question 2.7'
\qecho ''
\qecho ''

select distinct r1.sid, r2.sid
from reserves r1, reserves r2 
where r1.bid = r2.bid and 
	r1.sid <> r2.sid
order by r1.sid asc;
-----------alternate solutions - -------
select distinct s1.sid, s2.sid 
from sailor s1,sailor s2 
where s1.sid <> s2.sid and 
exists ( select 1 
	   from reserves r1, reserves r2 
	   where r1.sid = s1.sid and 
	   r2.sid = s2.sid and 
	   r1.bid = r2.bid);
----------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 2.8'
\qecho ''
\qecho ''

select s.sid 
from sailor s
where s.sid not in (
					select r.sid 
					from reserves r
					where r.day in ('Monday', 'Tuesday')
					); 
-----------Alternate soution---------------------------------
select s.sid 
from sailor s 
where not exists(select 1 
				from reserves r 
				where r.sid = s.sid and
				(r.day = 'Monday' or r.day = 'Tuesday'));
-------------------------------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 2.9'
\qecho ''
\qecho ''

select s.sid, b.bid 
from boat b, reserves r, sailor s 
where b.bid = r.bid and 
	r.sid = s.sid and
	b.color <> 'red' and
	s.rating > 6
order by s.sid asc;
------------Alternate solution ------------
select s.sid, b.bid 
from sailor s, boat b
where s.rating > 6 and 
	b.color <> 'red' and
	exists(select 1 
		  from reserves r 
		  where r.sid = s.sid and 
		  r.bid = b.bid);
-------------------------------------------

\qecho ''
\qecho ''
\qecho 'Question 2.10'
\qecho ''
\qecho ''

(select distinct r1.bid 
from Reserves r1)
except
(select distinct r1.bid 
from reserves r1, reserves r2 
where r2.bid = r1.bid and 
 	r1.sid <> r2.sid);
---------------Alternate solution----------------
select b.bid 
from boat b
where exists(select 1 
			from reserves r1 
			where r1.bid = b.bid and 
			not exists(select 1 
					  from reserves r2 
					  where r2.bid = b.bid and 
					  r1.sid <> r2.sid));
-------------------------------------------------
\qecho ''
\qecho ''
\qecho 'Question 2.11'
\qecho ''
\qecho ''

(select distinct s.sid 
from sailor s)
except
(select distinct r1.sid 
from sailor s, reserves r1, reserves r2, reserves r3 
where s.sid = r1.sid and 
 	s.sid = r2.sid and 
 	s.sid = r3.sid and 
 	r1.bid <> r2.bid and 
 	r1.bid <> r3.bid and 
 	r2.bid <> r3.bid);
-----------Alternate solution ------------------------------
select s.sid 
from sailor s
where not exists(select 1 
				from reserves r1, reserves r2, reserves r3 
				where r1.sid = s.sid and 
				r2.sid = r1.sid and 
				r2.sid = r3.sid and 
				r1.bid <> r2.bid and 
				r1.bid <> r3.bid and 
				r2.bid <> r3.bid);
------------------------------------------------------------
-- connect to default database
\c postgres;

--Drop database created
drop database assignment1vkvats;

