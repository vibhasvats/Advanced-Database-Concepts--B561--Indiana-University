-- Creating database with my initials
create database assignment7vkvats;

-- connecting database
\c assignment7vkvats;

\qecho ''
\qecho 'question 1.a: projection of A and B'
\qecho ''
drop function if exists map(text, jsonb), reduce(jsonb, jsonb[]);

-- Creating table R
create table R (A int, B int, C int);
insert into R values( 1, 2, 3),
	(4,5,6),
	(7,8,9),
	(10,11, 12),
	(13, 14, 15),
	(16, 17, 18),
	(19, 20, 21),
	(4,5,6),
	(7,8,9),
	(10,11, 12),
	(13, 14, 15),
	(16, 17, 18),
	(19, 20, 21);

-- create a table 'encodingofR' to encode the values of R in it.	
create table encodingofR (key text, value jsonb);

-- step 1: encode relation r in key-value store
insert into encodingofR 
	select 'R' as key, json_build_object('a', r.a, 'b', r.b, 'c', r.c)::jsonb as value
	from R r;

--Map function
create or replace function map(keyIn text, valueIn jsonb) 
returns table(keyOut jsonb, valueOut jsonb) as 
$$
	select json_build_object('a',valueIN -> 'a', 'b', valueIN -> 'b')::jsonb, 
		json_build_object('RelName', KeyIn::text)::jsonb;
$$ language sql;

--Reduce function 
create or replace function reduce(keyin jsonb, valuein jsonb[])
returns table(keyout text, valueout jsonb) as 
$$
	select 'projection(a,b)':: text, keyin::jsonb as valueout;
$$ language sql;

--Three phase simulation of Map-reduce.
with
map_phase as (
			select m.keyout, m.valueout 
			from encodingofR r, lateral(select keyOut, valueOut 
									   from map(r.key, r.value)) m
),
group_phase as (
			select keyOut, array_agg(valueOut) as valueOut
				from map_phase 
				group by(keyout)
),
reduce_phase as (
			select r.keyout as key, r.valueout as value 
			from group_phase g, lateral(select keyout, valueout 
									 from reduce(g.keyout, g.valueout)) r
)
select (value -> 'a')::int as A, (value -> 'b')::int as b 
from reduce_phase 
order by 1,2;

--drop all related tables and functions 
drop table if exists R, encodingofR cascade;
drop function if exists map(text, jsonb), reduce(jsonb, jsonb[]);

\qecho ''
\qecho 'question 1.b: set difference'
\qecho ''

create table R(A int);
create table S(a int);
-- inserting values in R and S
insert into R values 
(1),(2), (3),(4),(5),(6),(7),(8),(9),(10),(1),(2), (3),(4),(5),(6),(7),(8),(9),(10);
insert into S values 
(1),(2), (13),(14),(5),(16),(7),(18),(19),(10);

-- step 1: encode in key-value store 
create table encodingofRandS(key text, value jsonb);

--encoding R
-- union will produce unique values.
insert into encodingofRandS select 'R' as text, 
							json_build_object('a', r.a)::jsonb as value
							from R r
							union 
							select 'S' as text,
							json_build_object('a', s.a)::jsonb as value 
							from S s;

--Map function 
create or replace function map(keyin text, valuein jsonb)
returns table(keyout jsonb, valueout jsonb) as 
$$
	select valuein as key, json_build_object('RelName',keyin)::jsonb as value;
$$ language sql;

--Reduce function
-- set difference is implemented here 
create or replace function reduce(keyin jsonb, valuein jsonb[]) 
returns table(keyout text, valueout jsonb) as 
$$
	select 'set difference R - s':: text as key, keyin as value
	where valuein = array['{"RelName": "R"}']::jsonb[];		
$$ language sql;

-- Three phase simulation
with 
map_phase as (
	select m.keyout, m.valueout 
	from encodingofrands r, lateral(select keyout, valueout 
							   from map(r.key, r.value)) m
),
group_phase as (
	select keyout, array_agg(valueout)::jsonb[] as valueout 
	from map_phase 
	group by(keyout)
),
reduce_phase as (
	select r.keyout, r.valueout 
	from group_phase g, lateral(select keyout, valueout 
							   from reduce(g.keyout, g.valueout)) r
)
select valueout -> 'a' as A 
from reduce_phase
order by 1;

-- drop all functions and tables 
drop table if exists R, S, encodingofRands cascade;
drop function if exists map(text, jsonb), reduce(jsonb, jsonb[]);

\qecho ''
\qecho 'question 1.c'
\qecho ''

-- Creating table R and S. 
create table R(A int, B int);
create table S(B int, C int);
-- inserting values in R and S
insert into R values 
(11, 1),(12, 2), (13, 3),(14, 4),(15, 5),(16, 6),(17, 7),(18, 8),(19, 9),(20, 10);
insert into S values 
(1, 21),(2, 22), (13, 23 ),(14,24),(5, 25),(16, 26),(7, 27),(18, 28),(19, 29),(10, 30);

-- step 1: encode in key-value store 
create table encodingofRandS(key text, value jsonb);

--encoding R
-- union will produce unique values.
insert into encodingofRandS select 'R' as Key, 
							jsonb_build_object('a', r.a, 'b', r.b)::jsonb  as value
							from R r
							union 
							select 'S' as key,
							jsonb_build_object('c', s.c, 'b', s.b)::jsonb as value 
							from S s;

--Map function 
create or replace function map(keyin text, valuein jsonb)
returns table(keyout jsonb, valueout jsonb) as 
$$
	select valuein -> 'b' as key, valuein as value;
$$ language sql;

--Reduce function
-- set difference is implemented here 
create or replace function reduce(keyin jsonb, valuein jsonb[]) 
returns table(keyout text, valueout jsonb) as 
$$
	select 'R semi-join S' as keyout,  v as valueout
	from unnest(valuein) v 
	where json_array_length(array_to_json(valuein)) >= 2 and 
	v ?& array['a','b'] ;
$$ language sql;

-- Three phase simulation
with 
map_phase as (
	select m.keyout as key, m.valueout as value
	from encodingofrands r, lateral(select keyout, valueout 
							   from map(r.key, r.value)) m
) ,
group_phase as (
	select key, array_agg(value) as value
	from map_phase 
	group by(key)
),
reduce_phase as (select r.keyout, r.valueout 
				 from group_phase g, lateral(select keyout, valueout 
											 from reduce(g.key, g.value) r)r
) 
select (r.valueout -> 'a')::int as A, (r.valueout -> 'b')::int as B 
from reduce_phase r 
order by 1;

-- Drop all tables and function 
drop table if exists R, S, encodingofRandS;
drop function if exists map(text, jsonb), reduce(jsonb, jsonb[]);

\qecho ''
\qecho 'question 1.d'
\qecho ''

create table R (A int);
create table S (A int);
create table T (A int);
insert into R values (1), (2), (3), (4),(5), (6), (7), (8), (9), (10);
insert into S values (1), (3), (5), (7), (8);
insert into T values (1), (2), (3), (4), (5), (7), (8);

-- creating encoding of RST 
create table encodingofRST (key text, values jsonb);
insert into encodingofRST select 'R' as key, jsonb_build_object( 'A', r.A) as values 
							from R r 
							union 
							select 'S' as key, jsonb_build_object( 'A', s.A) as values 
							from S s 
							union 
							select 'T' as key, jsonb_build_object( 'A', t.A) as values 
							from T t;

-- create map function 
create or replace function map(keyin text, valuein jsonb) 
returns table( keyout jsonb, valueout jsonb) as 
$$
	select valuein, jsonb_build_object('RelName', keyin) as values;
$$ language sql;

--create reduce function
create or replace function reduce(keyin jsonb, valuein jsonb[]) 
returns table (keyout text, valueout jsonb) as 
$$
	select 'R-(S union T)' as keyout, keyin as keyout
	where not array['{"RelName": "S"}']::jsonb[] <@ valuein and 
		not array['{"RelName": "T"}']::jsonb[] <@ valuein;
$$ language sql;

-- Map reduce simulation 
with map_phase as (select m.keyout as key, m.valueout as value
				  from encodingofRST t, lateral (select keyout, valueout 
												from map(t.key, t.values)) m),
	group_phase as (select m.key, array_agg(m.value) as value 
				   from map_phase m
				   group by(m.key)),
	reduce_phase as (select r.key, r.value 
					from group_phase g, lateral (select keyout as key, valueout as value 
												from reduce(g.key, g.value)) r)
select (value -> 'A')::int as A from reduce_phase;

-- Drop all tables and function 
drop table if exists R, S, T, encodingofRST;
drop function if exists map(text, jsonb), reduce(jsonb, jsonb[]);

\qecho ''
\qecho 'Question: 2'
\qecho ''

create table R(A int, B int);
insert into R values 
(11, 1),(12, 2), (13, 3),(14, 4),(15, 5),(16, 6),(17, 7),(18, 8),(19, 9),(20, 10),
(11, 2),(12, 3), (13, 31),(16, 86),(17, 97),(18, 88),(19, 90),(20, 110),
(11, 1),(12, 2), (13, 3);

-- EncodingofR
create table EncodingOfR (key jsonb, value jsonb);
insert into EncodingOfR select json_build_object( 'RelName', 'R') as key, 
						json_build_object('a', r.a,'b', r.b)::json as value 
						from R r;

-- Map function 
create or replace function map(keyin jsonb, valuein jsonb) 
returns table (keyout jsonb, valueout jsonb) as 
$$
	select json_build_object('a', valuein -> 'a')::jsonb as keyout, 
	json_build_object('b', valuein -> 'b')::jsonb as valueout;
$$ language sql;

-- Reduce function
create or replace function reduce(keyin jsonb, valuein jsonb[])
returns table (keyout jsonb, counts jsonb) as 
$$
	select jsonb_build_object( 'a', keyin -> 'a', 'values', 
							 array_to_json(array_agg(v -> 'b'))), 
		jsonb_build_object('counts',cardinality(valuein)) as values
	from unnest(valuein) v
	where cardinality(valuein) >=2
	group by(keyin);
$$ language sql;

--simulation 
with map_phase as (select m.keyout, m.valueout 
				  from encodingofr r, lateral(select keyout, valueout 
											 from map(r.key, r.value)) m),
	group_phase as (select m.keyout as keys, array_agg(m.valueout) as values 
					from map_phase m 
				   group by(m.keyout)),
	reduce_phase as (select r.keyout as keys, r.counts as values 
				 from group_phase g, lateral (select keyout, counts 
										   from reduce(g.keys, g.values)) r)
select (keys -> 'a')::int as A, keys -> 'values' as B, (values -> 'counts')::int as count 
from reduce_phase;

-- Drop all tables and function
drop table R, encodingofR cascade;
drop function if exists map(jsonb, jsonb), reduce(jsonb, jsonb[]);

\qecho ''
\qecho 'Question: 3.a'
\qecho ''

create table R(k int, v int);
create table S(k int, w int);
insert into R values 
(11, 1), (11, 2),(12, 1),(13, 3);
insert into S values 
(11, 1),(11, 3),(13, 2),(14, 1),(14, 4);

-- simulating cogroup
create view R_cogroup_S as 
with all_keys as (select r.k as keys from R r
				 union 
				 select s.k as keys from S s),
	R_key_values as (select r.k as keys, array_agg(r.v) as R_values
					from R r
					group by (r.k)
					union 
					select k.keys, '{}' as R_values 
					from all_keys k
					where k.keys not in(select r.k from R r)),
	S_key_values as (select s.k as keys, array_agg(s.w) as S_values 
					from S s
					group by (s.k) 
					union 
					select k.keys, '{}' as S_values 
					from all_keys k 
					where k.keys not in (select s.k from S s))
select keys, jsonb_build_object( 'R', R_values:: int[], 'S', S_values::int[]) as values 
from R_key_values natural join S_key_values;

\qecho 'Output from the created view R_cogroup_S'
table R_cogroup_S;

\qecho ''
\qecho 'Question: 3.b'
\qecho 'implementing R semi-join S = (R natural join (pi(k)(S)))'

select r.keys, r.Rvalues 
from (select cg.keys, v as Rvalues
		from R_cogroup_S cg, jsonb_array_elements(values -> 'R') as v) R 
		natural join (select cg.keys, w as Svalues
					from R_cogroup_S cg, jsonb_array_elements(values -> 'S') as w) S;


\qecho ''
\qecho 'Question: 3.c'
\qecho ''
-- given query 
/*
given querry in words: find the combination of R.k and S.k such that 
the values of R.v for key R.k is contained in values of S.w for key s.k 
*/

-- solution using cogroup view formed
with Rel_R as (select cg.keys as k, v as V 
			  from R_cogroup_S cg, jsonb_array_elements(values -> 'R') as V),
	Rel_S as (select cg.keys as k, w as w 
			 from R_cogroup_S cg, jsonb_array_elements(values -> 'S') as w) 
select distinct r.k as rk, s.k as sk
from Rel_R r cross join Rel_S s
where array( select r1.v
		   from Rel_R r1
		   where r1.k = r.k) <@ array(select s1.w 
									 from Rel_S s1 
									 where s1.k = s.k);

-- drop the tables 
drop table if exists R,S cascade;

\qecho ''
\qecho 'Question: 4.a'
\qecho ''

create table A (value int);
create table B (value int);
insert into A values(1),(2),(3),(4),(5),(6),(7),(8);
insert into B values(1),(3),(5),(7),(9),(11),(13);

-- implementation using cogroup
create view A_cogroup_B as
with new_A as (select a.value as key, a.value as value 
			  from A a),
	new_B as (select b.value as key, b.value as value
			 from B b),
	All_keys as (select distinct a.key from new_a a 
				 union 
				 select distinct b.key from new_b b), 
	A_key_values as (select a.key as keys, array_agg(distinct a.value) as A_values
					from new_A a
					group by (a.key)
					union 
					select k.key, '{}' as A_values 
					from all_keys k
					where k.key not in(select a.key from new_A a)),
	B_key_values as (select b.key as keys, array_agg(distinct b.value) as B_values 
					from new_b b
					group by (b.key) 
					union 
					select k.key, '{}' as B_values 
					from all_keys k 
					where k.key not in (select b.key from new_B b))
select keys, jsonb_build_object( 'A', A_values:: int[], 'B', B_values::int[]) as values 
from A_key_values natural join B_key_values;				 

\qecho 'Output from the created view A_cogroup_B'
table A_cogroup_b;

-- solution using cogroup view created.


/*
I have written two querries for it, both the query uses only the cogroup view. but one is very small and 
uses only simple non-equality check to find the required value. For unary relation this solution is crisp 
and effective. 

then other solution does the similar thing but more inline with traditional way to doing natural join .
*/

select keys as A_intersect_B 
from A_cogroup_B 
where values -> 'A' = values -> 'B' 
order by 1;

-- -- Alternate solutions
-- select val as A_intersect_b 
-- from (select val 
-- 	  from A_cogroup_B cg1, jsonb_array_elements(values -> 'A') val) A 
-- 	  natural join (select val 
-- 					from A_cogroup_B cg2, jsonb_array_elements(values -> 'B') val) B
-- order by 1;

\qecho ''
\qecho 'Question: 4.b'
\qecho ''

/*
I have written two querries for it, both the query uses only the cogroup view. but one is very small and 
uses only simple non-equality check to find the required value. For unary relation this solution is crisp 
and effective. 

then other solution does the similar thing but more inline with traditional way to doing natural join .
*/
select keys as A_intersect_B 
from A_cogroup_B 
where values -> 'A' != values -> 'B'
order by 1;

-- -- Alternate solution using only cogroup
-- with A_values as (select a as num
-- 				 from A_cogroup_b cg, jsonb_array_elements(values -> 'A') a),
-- 	B_values as (select b as num
-- 				from A_cogroup_B cg, jsonb_array_elements(values -> 'B') b),
-- 	AminusB as (select a.num
-- 				from A_values a
-- 				except 
-- 				select b.num 
-- 				from B_values b),
-- 	BminusA as (select b.num 
-- 				from B_values b 
-- 				except 
-- 				select a.num 
-- 				from A_values a)
-- select num::int as symmetricDifference_AB from AminusB
-- union 
-- select num::int as symmetricDifference_AB from BminusA
-- order by 1;

--Drop table s
drop table if exists A, B cascade;

\qecho ''
\qecho 'Part 2: Nested relations ans semi-structured databases'
\qecho 'Question 5'

drop table if exists enroll;
-- creating student grade types first 
Create table enroll ( sid text, cno text, grade text);
insert into enroll values 
     ('s100','c200', 'A'),
     ('s100','c201', 'B'),
     ('s100','c202', 'A'),
     ('s101','c200', 'B'),
     ('s101','c201', 'A'),
     ('s102','c200', 'B'),
     ('s103','c201', 'A'),
     ('s101','c202', 'A'),
     ('s101','c301', 'C'),
     ('s101','c302', 'A'),
     ('s102','c202', 'A'),
     ('s102','c301', 'B'),
     ('s102','c302', 'A'),
     ('s104','c201', 'D');

\qecho ''
\qecho 'Question 5.a'
\qecho ''

/*
I use the enroll relation and first group by cno and grade then the used the newly formed relation F and 
group by only cno. in the process i typecast as required. 
*/
-- creating types for CourseGrades nested relation 
create type StudentType as (sid text);
create type GradeStudentType as (grade text, students StudentType[]);
create table CourseGrades (cno text, gradeInfo GradeStudentType[]);

insert into CourseGrades 
with E as (select cno, grade, array_agg(row(sid)::StudentType) as Students 
		  from enroll
		  group by(cno, grade)), 
	F as (select cno, array_agg(row(grade, Students)::GradeStudentType) as gradeInfo 
		 from E 
		 group by(cno))
select * from F order by cno;

\qecho 'The CourseGrades nested relation'
select * from CourseGrades;

\qecho ''
\qecho 'Question 5.b'
\qecho ''

/*
I unnest the Coursegrades nested relation to make a temporary enroll view, then first group by on sid and grade
and then again group by only sid, while converting, I typecase it as required. 
*/
-- creating StudentGrade realation;
create type CourseType as (cno text);
create type GradeCoursetype as ( grade text, courses CourseType[]);
create table StudentGrades (sid text, gradeinfo GradeCourseType[]);

insert into StudentGrades
with enroll as (select cno, grade, sid 
				from CourseGrades cg, 
						unnest(cg.gradeInfo) gi, 
							unnest(gi.students)), 
	E as (select sid, grade, array_agg(row(cno)::CourseType) as Courses
		 from enroll 
		 group by (sid, grade)),
	F as (select sid, array_agg(row(grade, Courses)::GradeCourseType) as gradeInfo 
		 from E 
		 group by(sid))
select * from F order by sid;

\qecho 'the studentGrades nested relation'
select * from studentGrades;

\qecho ''
\qecho 'Question 5.c'
\qecho ''

create table JCourseGrades(studentInfo jsonb);

/*
first i group Enroll relation by cno and grade, and build json elements, 
then again I group by only cno and convert 
all values in json elements and inset it into Jcoursegrades.
*/
-- using enroll relation to insert into Coursegrade relation
insert into JCourseGrades 
with E as (select cno, grade,
		  		array_to_json(array_agg(json_build_object('sid', sid))) as students 
		  from enroll 
		  group by(cno, grade) order by 1),
	F as (select json_build_object('cno', cno, 'gradeInfo',
				  array_to_json(array_agg(json_build_object('grade', grade, 'students', students)))) as studentInfo
		 from E 
		 group by(cno))
select studentInfo from F;

\qecho 'Relation JCourseGrades: values inserted using Enroll table.'
table JCourseGrades;

\qecho ''
\qecho 'Question 5.d'
\qecho ''

create table JStudentGrades(studentInfo jsonb);
/*
I take the JcourseGrades json relation and take out all elements to form a temporary 'enroll' relation, 
then use this relation to do step by step the same operation done to create JCourseGrades and insert the
final values in JStudentGrades
*/
-- inserting value in JstudentGrades from JCourseGrades relation
insert into JStudentGrades
with enroll as (select cg.studentInfo -> 'cno' as cno, gi -> 'grade' as grade, s -> 'sid' as sid
			   from jcoursegrades cg, jsonb_array_elements(cg.studentInfo -> 'gradeInfo') gi,
			   		jsonb_array_elements(gi -> 'students') s),
	E as (select sid, grade, 
		 array_to_json(array_agg(json_build_object('cno', cno))) as courses 
		 from enroll 
		 group by(sid, grade) order by 1),
	F as (select json_build_object('sid', sid, 'studentInfo', 
								  array_to_json(array_agg(json_build_object('grade', grade, 'courses', courses)))) as studentInfo
		 from E 
		 group by(sid))
select studentInfo from F;

\qecho 'Relation JStudentGrades: values inserted using JCourseGrades table.'
table JStudentGrades;

\qecho ''
\qecho 'Question 5.e'
\qecho ''
drop table if exists major, course, student;

CREATE TABLE major (sid text, major text);
create  table course (cno text, cname text, dept text);
create table student (sid text, sname text, major text, byear int);
insert into course values 
	('c200', 'PL', 'CS'),
	('c201', 'Calculus', 'Math'),
	('c202', 'Dbs', 'CS'),
	('c301', 'AI', 'CS'),
	('c302', 'Logic', 'Philosophy');
insert into student values 
	('s100', 'Eric', 'CS', 1987),
	('S101', 'Nick', 'Math', 1990),
	('s102', 'Chris', 'Biology', 1976),
	('s103', 'Dinska', 'CS', 1977),
	('s104', 'Zanna', 'Math', 2000),
	('s105', 'Vince', 'CS', 1990);
INSERT INTO major VALUES ('s100','French'),
('s100','Theater'),
('s100', 'CS'),
('s102', 'CS'),
('s103', 'CS'),
('s103', 'French'),
('s104',  'Dance'),
('s105',  'CS');

/*
Using the JstudentGrades table, I extract sid and cno as required, put it in temporary relation E and 
then do natural join with course then select only those student with major 'CS' and display the final output
*/
--Query solution
with E as (select sg.studentinfo ->> 'sid' as sid, c ->> 'cno' as cno
			from JStudentGrades sg, 
			jsonb_array_elements(sg.studentinfo -> 'studentInfo') g,
			jsonb_array_elements(g -> 'courses') c),
	F as (select sid, dept, array_to_json(array_agg(json_build_object('cno', cno, 'cname', cname))) as courses
		 from E natural join course 
		 group by(sid, dept)), 
	G as (select sid, sname, array_to_json(array(select json_build_object(dept, courses) 
							   				from F where S.sid = F.sid )) as courseinfo
		from student s
		where s.sid in (select m.sid 
					   from major m 
					   where m.major = 'CS'))
select json_build_object('sid', sid, 'sname', sname, 'courseinfo', courseinfo) as studentInfo  
from G ;

-- drop all tables
drop type if exists CourseType, GradeCoursetype, StudentType, GradeStudentType cascade;
drop table if exists CourseGrades, StudentGrades, JCourseGrades, JStudentGrades, major, course,student, enroll cascade;


-- connect to default database
\c postgres;

--Drop database created
drop database assignment7vkvats;
