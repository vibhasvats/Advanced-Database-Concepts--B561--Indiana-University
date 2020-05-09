-- Creating database with my initials
create database assignment4vkvats;

-- connecting database
\c assignment4vkvats;

--Schemas

create table Student (
	sid int,
	sname text,
	major text
	);

create table Course(
	cno int, 
	cname text,
	total int,
	max int
	);

create table Prerequisite(
	cno int,
	prereq int
	);

create table HasTaken(
	sid int, 
	cno int
	);

create table Enroll(
	sid int,
	cno int
	);
	
create table waitlist(
	sid int,
	cno int,
	position int
	);
	
\qecho 'Creating a global variable table for controlling the enrollment start and stop for later part of solutions.'
\qecho ''	
create table toggle(
	enrolling int);
insert into toggle values(0);	

-- solutions
\qecho ''
\qecho ''
\qecho 'Question 1.a'
\qecho ''
\qecho ''

\qecho ''
\qecho 'For checking primary key constraint, we check if the sid already exists in student relation or not.'
\qecho ''
create function primaryKeyCheckStudent() 
returns trigger as 
$$ 
	begin 
		if new.sid in (select s.sid from student s) then 
			raise exception 'Sid already exists!, primary key violation';
		end if;
		return new;
	end;
$$ language 'plpgsql';

create trigger insert_into_student
	before insert 
	on student 
	for each row
	execute procedure primaryKeyCheckStudent();

insert into student values 
(1001,'Jean', 'Math'),
(1002,'Maria', 'CS'),
(1003,'Anna', 'Biology'),
(1005, 'bob', 'geology');

\qecho 'Primary key check on student relation'

insert into student values 
(1001,'Dean', 'DS');
\qecho ''
\qecho 'The error shows that the sid is already present in the student relation so its a primary key violation.'
\qecho ''

\qecho ''
\qecho 'For checking primary key constraint, we check if the cno already exists in course relation or not.'
\qecho ''
/*Primary key check on course relation*/

create function PrimaryKeyCheckCourse() 
returns trigger as 
$$ 
	begin 
		if new.cno in (select c.cno from course c) then 
			raise exception 'Cno already exists! primary key violation';
		end if;
		return new;
	end;
$$ language 'plpgsql';

create trigger insert_into_course
	before insert on course
	for each row 
	execute procedure PrimaryKeyCheckCourse();

insert into course values 
(101,'database intro',0, 5),
(102,'EDA',0, 5),
(103,'computer vision',0, 5),
(105, 'Machine learning',0, 5);

\qecho 'Primary key check on course relation'
\qecho ''
insert into course values(101, 'basic maths', 0, 5);

\qecho ''
\qecho ''
\qecho 'Question 1.b'
\qecho ''
\qecho ''
/*Foreign key insert constraints.*/
\qecho ''
\qecho 'To check foreign key we will need to check that if the values already exists in the course realtion or not'
\qecho ''
-- for relation prerequisite.
create function ForeignKeyCheckPrerequisite() 
returns trigger as 
$$
	begin 
		if new.cno not in(select cno from course) then 
			raise exception 'Cno not in Course relation, foreign key violation';
		end if;
		if new.prereq not in(select cno from course) then 
			raise exception 'prerequisite not in Course relation, foreign key violation';
		end if;
		return new;
	end;
$$ language 'plpgsql';

create trigger insert_into_prerequisite
	before insert on Prerequisite 
	for each row 
	execute procedure ForeignKeyCheckPrerequisite();
	
\qecho 'foreign key satisfaction check on prerequisite'
\qecho ''
insert into prerequisite values(101, 102);
\qecho ''
\qecho 'The insertion happens which shows that the foreign key constrainst is satisfied.'
\qecho ''
\qecho 'These insertion will not happen as it violates the foreign key condition.'
\qecho ''
\qecho 'Foreign key violation check for wrong course no'
\qecho ''
insert into prerequisite values(104, 101);
\qecho 'Foreign key violation check for wrong prerequisite no'
\qecho ''
insert into prerequisite values(101, 106);

/*Foreign key insert constraints.*/
\qecho ''
\qecho 'To check foreign key we will need to check that if the values already exists in the student realtion or not'
\qecho ''
-- for relation HasTaken
create function ForeignKeyCheckHasTaken() 
returns trigger as 
$$ 
	begin 
		if new.sid not in (select s.sid from student s) then 
		raise exception 'Sid not in Student relation, Foreign key violation';
		end if;
		if new.cno not in (select c.cno from course c) then 
		raise exception 'Cno not in Course relation, Foreign key violation';
		end if;
		return new;
	end;
$$ language 'plpgsql';

create trigger insert_into_HasTaken 
	before insert on HasTaken 
	for each row 
	execute procedure ForeignKeyCheckHasTaken();

\qecho 'Foreign key violation check on hastaken relation'
\qecho ''
\qecho 'These insertion will not happen as it violates the foreign key condition.'
\qecho ''
\qecho 'Foreign key violation check for wrong student id no'
\qecho ''
insert into hastaken values(1004, 101);
\qecho 'Foreign key violation check for wrong course no'
\qecho ''
insert into hastaken values(1001, 106);

-- For relation Enroll
\qecho ''
\qecho 'To check foreign key we will need to check that if the values already exists in the course realtion or not'
\qecho ' and the cno already exists in the course relation or not'
\qecho ''
create function ForeignKeyCheckEnroll() 
returns trigger as 
$$
	begin 
		if new.sid  not in (select s.sid from student s) then 
			raise exception 'Sid not in Student relation, Foreign key violation';
		elseif new.cno not in (select c.cno from course c) then 
			raise exception 'Cno not in course, foreign key violation';
		end if;
		update toggle 
		set enrolling = 1;
		return new;
	end;
$$ language 'plpgsql';

create trigger insert_into_Enroll 
	before insert on Enroll
	for each row 
	execute procedure ForeignKeyCheckEnroll();
	
\qecho 'Foreign key satisfaction check on enroll'
\qecho ''
insert into enroll values(1005, 101);
\qecho 'Foreign key violation check on enroll relation'
\qecho ''
\qecho 'These insertion will not happen as it violates the foreign key condition.'
\qecho ''
\qecho 'Foreign key violation check for wrong student id no'
\qecho ''
insert into enroll values(1004, 101);
\qecho 'Foreign key violation check for wrong course no'
\qecho ''
insert into enroll values(1001, 106);

-- For relation Waitlist
\qecho ''
\qecho 'To check foreign key we will need to check that if the values already exists in the course realtion or not'
\qecho ' and the cno already exists in the course relation or not'
\qecho ''
create function ForeignKeyCheckWaitlist() 
returns trigger as 
$$ 
	begin 
		if new.sid not in (select sid from student) then 
			raise exception 'Sid not in student relation Foreign key violation';
		end if;
		if new.cno not in (select cno from course) then 
			raise exception 'Cno not in course relation Foreign key violation';
		end if;
		return new;
	end;
$$ language 'plpgsql';

create trigger insert_into_Waitlist 
	before insert on Waitlist 
	for each row 
	execute procedure ForeignKeyCheckWaitlist();
	
\qecho 'Foreign key satisfaction check on waitlist'
\qecho ''
insert into waitlist values(1005, 102);
\qecho 'Foreign key violation check on waitlist relation'
\qecho ''
\qecho 'Foreign key violation check for wrong student id no'
\qecho ''
insert into waitlist values(1004, 101);
\qecho 'Foreign key violation check for wrong course no'
\qecho ''
insert into waitlist values(1001, 106);


/*Foreign key delete constraints.*/
\qecho ''
\qecho 'when a student deletes from student relation, he will also be deleted from Enroll and waitlist realtion'
\qecho 'there is not delete clause on hastaken relation, so no data will be deleted from hastaken relation'
\qecho ''
\qecho 'delete cascade on hastaken relation is redundant, as in later part of the assignment we have to implement no delete'
\qecho 'restriction on has taken so I have omitted delete cascade from hastaken here.'
-- For student relation
create function DeleteCascadingStudent() 
returns trigger as 
$$
	begin 
		if old.sid in (select sid from Enroll) then 
			delete from Enroll where sid = old.sid;
		end if;
		if old.sid in (select sid from waitlist) then 
			delete from Waitlist where sid = old.sid;
		end if;
		return null;
	end;
$$ language 'plpgsql';

create trigger delete_from_student 
	after delete on student 
	for each row 
	execute procedure DeleteCascadingStudent();
	
\qecho 'Delete cascade check on student relation on sid 1005'
\qecho ''
delete from student where sid = 1005;
\qecho 'checking in enroll and waitlist relation '
\qecho ''
select * from enroll where sid = 1005;
select * from waitlist where sid = 1005;
\qecho 'Sid has been deleted from enroll and waitlist as well. '
\qecho ''

\qecho ''
\qecho 'on deletion of a course from the course has to be deleted from all relevant courses'
\qecho ''
-- For Course relation
create function DeleteCascadeCourse() 
returns trigger as 
$$ 
	begin 
		if old.cno in(select cno from enroll) then 
		delete from Enroll where cno = old.cno;
		end if;
		if old.cno in (select cno from waitlist) then 
			delete from waitlist where cno = old.cno;
		end if;
		if old.cno in (select cno from prerequisite) then 
			delete from prerequisite where cno = old.cno;
		end if;
		if old.cno in (select prereq from prerequisite) then 
			delete from prerequisite where prereq = old.cno;
		end if;
		return null;
	end;
$$ language 'plpgsql';

create trigger deleter_from_course 
	after delete on course 
	for each row 
	execute procedure DeleteCascadeCourse();
	
	
\qecho 'inserting values in different table to demonstrate working of delete cascade'
\qecho ''
insert into student values(1005, 'bob', 'geology');
\qecho 'course 102 is already present in the course'
\qecho ''
insert into prerequisite values( 102, 103), (103,102);
insert into enroll values(1005, 102);
insert into waitlist values(1005, 102);

\qecho 'delete cascade on corse with cno 102'
\qecho ''
delete from course where cno = 102;
\qecho 'dislaying cno from 102, there wont be any outcome as it has been deleted'
\qecho ''
select * from course where cno = 102;
select * from prerequisite where cno = 102;
select * from enroll where cno = 102;
select * from waitlist where cno = 102;
\qecho 'course 102 has been deleted rom all around.'
\qecho 'it has also been deleted from prerequisite which enforces the condition of not delete later in the assignment.'
\qecho ''
\qecho ''
\qecho 'Question 1.c'
\qecho ''
\qecho ''
\qecho ' from here on in any case there will be no delete on hastaken relation.'
insert into hastaken values(1001, 103);
create function NoDeletionOnHasTaken() returns trigger as 
$$
	begin 
		raise exception 'Can not delete past records from HasTaken relation';
	return null;
	end;
$$ language 'plpgsql';

create trigger no_delete_on_HasTaken 
	before delete on HasTaken
	for each row 
	execute procedure NoDeletionOnHasTaken();
	
\qecho 'NO deletion check on hastaken'
delete from hastaken where sid = 1001;

\qecho 'conditional enroll on hastaken relation'
\qecho 'thing will be deleted only when enrollment has not started yet'
\qecho 'for keeping the track of start of enrollment i have made a relation toggle which toggles between 0 and 1 '
\qecho 'it is zero when the enrolling has not started but the moment first enrollment happens it is updated to 1'
\qecho 'and then things are not allowed to be enserted into hastaken, course and prereqisite.'
\qecho 'All of these are simulated down below in different questions.'

create function conditional_insert_into_hastaken() returns trigger as 
$$
	begin 
		if exists (select enrolling from toggle where enrolling = 1) then 
			raise exception 'Can not add to hastaken once enrollment started';
		end if;
		return new;
	end;	
$$ language 'plpgsql';

create trigger insert_on_hastaken_before_enrollment 
	before insert on HasTaken 
	for each row 
	execute procedure conditional_insert_into_hastaken();

\qecho 'Conditional insert on hastaken table,'
insert into hastaken values (1005, 101 );

\qecho ''
\qecho ''
\qecho 'Question 1.d'
\qecho ''
\qecho ''
-- NO delete on course relation
create function noDeleteOnCourse() returns trigger as 
$$
	begin 
		 raise exception 'Can not delete a course';
	return null;
	end;
$$ language 'plpgsql';

create trigger no_delete_on_course 
	before delete on course 
	for each row 
	execute procedure noDeleteOnCourse();
	
\qecho 'No delete on course relation demo'
delete from course where cno = 101;

-- no delete on prerequisite relation
create function noDeleteOnPrerequisite() returns trigger as 
$$
	begin 
		 raise exception 'Can not delete from prerequisite';
	return null;
	end;
$$ language 'plpgsql';

create trigger no_delete_on_prerequisite 
	before delete on prerequisite 
	for each row 
	execute procedure noDeleteOnPrerequisite();

insert into prerequisite values( 105, 103), (103,101);
\qecho 'No delete on course relation demo for cno 103 which is already present in course.'
delete from prerequisite where cno = 103;

-- no insert into course if enrollment started 
\qecho 'no insert into course if enrollment started '
\qecho 'setting enrollment toggle to 0 i.e. enrollment has not started.'
update toggle 
set enrolling = 0;
\qecho 'display of enrollment status in courses'
select * from toggle;
\qecho 'it says, enrolling set to 0 , which means enrollment has not started yet'

create function Conditional_insert_on_course() returns trigger as 
$$
	begin 
		if exists( select enrolling from toggle where enrolling = 1) then 
			raise exception 'Can not insert to course once enrollment starts';
		end if;
		return new;
	end;
$$ language 'plpgsql';

create trigger conditional_insert_into_course 
	before insert on course 
	for each row 
	execute procedure Conditional_insert_on_course();

\qecho 'testing insertion into course while enrollment has not started'
insert into course values(107, 'Data mining',0,5);

\qecho 'Insertion happened successfully'
\qecho ''
\qecho 'now chaning toggle to 1, indiacting start of enrollment'
update toggle 
set enrolling = 1;
\qecho 'display of enrollment status in courses'
select * from toggle;
\qecho 'it says, enrolling set to 1 , which means enrollment has began'
\qecho ''
\qecho 'testing insertion into course while enrollment has began'
insert into course values(126, 103);
\qecho 'Insertion did not happen.'

\qecho 'no insert into course prerequisite if enroll exists'

\qecho 'no insert into course prerequisite if enroll started '
\qecho ''
\qecho 'setting enrollment toggle to 0 i.e. enrollment has not started.'
update toggle 
set enrolling = 0;
\qecho 'display of enrollment status in courses'
select * from toggle;
\qecho ''
\qecho 'it says, enrolling set to 0 , which means enrollment has not started yet'

create function Conditional_insert_on_prerequisite() returns trigger as 
$$
	begin 
		if exists( select enrolling from toggle where enrolling = 1) then 
			raise exception 'Can not insert or update prerequisite once enrollment starts';
		end if;
		return new;
	end;
$$ language 'plpgsql';

create trigger conditional_insert_update_into_prerequisite 
	before insert or update on prerequisite 
	for each row 
	execute procedure Conditional_insert_on_prerequisite();

\qecho 'testing insertion into enprerequisiteroll while enrollment has not started'
\qecho ''
insert into prerequisite values(101, 103);
\qecho 'Insertion happened successfully'
\qecho ''
\qecho 'now chaning toggle to 1, indiacting start of enrollment'
\qecho ''
update toggle 
set enrolling = 1;
\qecho 'display of enrollment status in courses'
select * from toggle;
\qecho 'it says, enrolling set to 1 , which means enrollment has began'
\qecho ''
\qecho 'testing insertion into enroll while enrollment has began'
\qecho ''
insert into prerequisite values(101, 103);
update prerequisite set prereq = 102 where cno = 101;
\qecho 'Insertion did not happen as enrollment has began and now we can not change anythong on prerequisite'

\qecho ''
\qecho ''
\qecho 'Question 2'
\qecho ''
\qecho ''

\qecho 'updating toggle to 0, indicating that the enrollment has not started'
\qecho ''
update toggle 
set enrolling = 0;
\qecho 'Inserting data into has taken to demonstrate question 2 working'
\qecho ''
insert into hastaken values(1001, 103);

-- insert on enroll
create function conditional_insert_on_enroll() returns trigger as 
$$ 
	declare 
		waitlist_no int;
	begin 
		if exists(select 1 
				 from prerequisite p 
				 where p.cno = new.cno and 
				 p.prereq not in(select h.cno 
								 from hastaken h 
								 where h.sid = new.sid)) then 
			raise exception 'All prerequisites not satisfied';
		end if;
		if exists(select 1 
				 from course c 
				 where c.cno = new.cno and 
				 	c.total < c.max) then 
			--updating course table total for that course
			update course 
			set total = total +1
			where cno = new.cno;
			-- setting enrollment tracker to 1 indicating enrollment has started.
			update toggle 
			set enrolling = 1;
			return new;
		else 
			if exists(select cno 
					 from waitlist 
					 where cno = new.cno) then 
				waitlist_no = (select max(w.position) 
							  from waitlist w
							  where w.cno = new.cno);
				insert into waitlist values(new.sid, new.cno, waitlist_no +1);
			else 
				insert into waitlist values(new.sid, new.cno, 1);
			end if;
		end if;
		return null;
	end;
$$ language 'plpgsql';

create trigger conditional_insert_enroll 
	before insert on Enroll 
	for each row 
	execute procedure conditional_insert_on_enroll();

\qecho 'inserting sid 1001 in cno 105, this will show two things'
\qecho ''
insert into enroll values(1001, 105);
\qecho 'first that if someone satisfy all prerequisite then it will be inserted in enroll'
\qecho ''
select * from enroll where sid = 1001;
\qecho 'second that if someone is enserted in enroll, the total in relation Course is updated to 1'
\qecho ''
select * from course where cno = 105;
\qecho 'those who has do not satisfy all prerequisite cant enroll'
\qecho ''
insert into enroll values(1002, 105);
\qecho 'sid 1002 cant enroll as it doesnt satisfy all prerequisite'
\qecho ''
\qecho 'now demonstrating the if a course is full the student will be sent to waitlist relation'
\qecho ''
\qecho 'updating cno 107 to its one less than strength and then updating two students in 107 cno'
\qecho 'such that one will be enrolled and another will be put into waitlist.'
update course 
set total = 4 
where cno =107;
\qecho ''
select * from course where cno = 107;
\qecho ''
\qecho 'inserting two new student in cno 107'
\qecho ''
insert into enroll values(1001, 107), (1002, 107);
\qecho 'now check if the student is put in waitlist or not'
\qecho ''
table waitlist;
\qecho 'one student is placed in enroll and another student is placed in waitlist as the course is full'
\qecho ''

-- deletiong on enroll
create function conditional_delete_from_enroll() returns trigger as 
$$
	declare 
		student_id int;
	begin 
		update course 
			set total = total -1
			where cno = old.cno;
		-- if waitlist exists for old.cno course
		if exists(select 1 
				 from waitlist 
				 where cno = old.cno) then 
			-- get the sid with least waitlisted number.
			student_id = (select w.sid 
						 from waitlist w
						 where w.cno = old.cno and 
						 w.position = (select min(w2.position) 
									  from waitlist w2 
									  where w2.cno = old.cno));
			insert into enroll values(student_id, old.cno);
			-- delete the student from wailist.
			delete from waitlist 
			where sid = student_id;
		end if;
		return old;
	end;
$$ language 'plpgsql';

create trigger conditional_delete_on_enroll
	before delete on enroll
	for each row 
	execute procedure conditional_delete_from_enroll();
	
\qecho 'updating the course 107 to full,and there is one person in waitlist in 107 course'
\qecho 'I will delete one person from enroll and the other person in waitlist should'
\qecho 'be moved to enroll table and deleted from waitlist table.'
delete from enroll where sid = 1002;
\qecho 'the student 1002 has been deleted from enroll who was waitlisted in course 107, subsequently' 
\qecho 'another student with sid 1001 who was waiting in course no 107 has been moved to enroll table'
\qecho ''
\qecho 'if a student deleted with only SID then all courses where he is enrolled will be deleted'
\qecho 'but if the student specify both sid and cno to dropped from enroll, only that course will be removed from enroll.'

\qecho ''
\qecho ''
\qecho 'Question 3'
\qecho ''
\qecho ''
\qecho 'for this question i have made two relation experiment and T,experiment will always have only one column and it '
\qecho 'will save the running average and running standard deviation in the relation'
\qecho 'T relation is only used as decoy to call trigger on the relation and then insert to experiment relation'
\qecho ''
create table experiment(
	n int,
	et float,
	vt float
	);

create table T(
	n int,
	t int);
\qecho ''
\qecho 'for its working i have made 4 variables that keeps the old and current value sof expected value E(T) and standard deviation V(T)'
\qecho ' these variable are later used in the code to calculated the running expected value and standard delivation after each throw'
\qecho ' after each throw the value is stored in experiment relation , and it is fetched from there again after next throw and put back'
\qecho ''
create function insert_into_experiment() returns trigger as
$$
	declare 
		old_et float;
		old_vt float;
		current_et float;
		current_v float;
	begin 
		if not exists(select 1 from experiment) then 
			insert into experiment values 
			(1, new.t, 0);
		else 
			old_et = (select et from experiment);
			old_vt = (select vt from experiment);
			current_et = (select (old_et + (new.t - old_et) / (new.n)));
			current_v = (select (old_vt + (new.t - old_et)* (new.t - current_et)));
			update experiment 
			set n = new.n,
				et = current_et,
				vt = sqrt(current_v);		
		end if;
		return null;
	end;
$$ language 'plpgsql';

create trigger update_experiment 
	before insert on t 
	for each row 
	execute procedure insert_into_experiment();
\qecho ''
\qecho 'in the runExperiment function i return a table, the values are directly taken from the experiment relation after the'
\qecho 'loop has ended, the runExperiment() function should directly display the output as expected'
\qecho ' right now the runExperiment(1000) is being run for 1000 throw.'
create or replace function runExperiment(num int) 
returns table(n int, et float, vt float) as 
$$
	declare 
		i int;
		throw int;
		exp_outcome record;
	begin 
		for i in 1..num loop
			throw = (select (floor(random()*6)+1 + floor(random()*6)+1 + floor(random()*6)+1));
			insert into t values(i, throw);
		end loop;
		n = (select e.n from experiment e);
		et = (select e.et from experiment e);
		vt = (select e.vt from experiment e);
		return next;
	end;
$$ language 'plpgsql';

select * from runExperiment(1000);
						  
						  
-- connect to default database
\c postgres;

--Drop database created
drop database assignment4vkvats;

