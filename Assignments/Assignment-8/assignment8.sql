-- Creating database with my initials
create database assignment8vkvats;

-- connecting database
\c assignment8vkvats;

\qecho ''
\qecho 'Object Relational programming'
\qecho ''
\qecho ' Question 1'
drop table if exists tree;
-- creatng table tree
create table tree(parent int, child int);
insert into Tree values (1,2), (1,3), (1,4), (2,5), (2,6), (3,7), (5,8), (7,9), (9,10);

--table tree
table tree;

-- creating a table which will have all edges in both direction, a->b and b->a;
create table all_edges(parent int, child int);
-- this table will contain only the subtree starting from point M and ending at point n.
create table subTree(startPoint int, parent int, child int, pathLength int);

-- The distance function
/*
Description: given the node M and N in distance function, i create a subtree, starting from node M 
and ending at node N, As soon as this subTree is formed, the loop is exited. 
then this function selects the distance calculated during the subTree formation and returns it.
*/
create or replace function distance(m int, n int)
returns int as 
$$
	declare 
	i int;
	allEdge bigint := (select count(1) from tree);
	dist int :=1;
	begin
	-- delete everything from subTree and all_edges
		delete from subTree;
		delete from all_edges;
		-- compute all edges
		insert into all_edges 
		select t.parent, t.child from tree t 
		union 
		select t.child, t.parent from tree t;
		--insert root of new subtree
		insert into subTree 
		select distance.m, ae.parent, ae.child, dist from all_edges ae where parent = distance.m;
		-- loop till complete subTree is formed.
		for i in 1..allEdge
		loop 
			-- loop exit condition check, it exits the loop if subtree has been formed with 
			-- start node M and end node N
			if (select exists (select 1 
				  from subTree st 
				  where st.startPoint = distance.m and 
					st.child = distance.n)) then exit;
			end if;
			dist := dist +1;
			insert into subTree 
			select distance.m, ae.parent, ae.child, dist 
			from all_edges ae join subTree st on (st.child = ae.parent) 
			where (ae.parent, ae.child) not in (select st.parent, st.child from subTree st) and 
				(ae.child, ae.parent) not in (select st.parent, st.child from subTree st);	
		end loop;
		--select the distance from the subTree table for point M and N.
		dist := (select st.pathLength from subTree st 
				 where st.startPoint = distance.m and 
					st.child = distance.n);
		return dist;
	end;
$$ language plpgsql;

with vertex as ( select t.parent as vertex 
			   from tree t 
			   union 
			   select t.child as vertex 
			   from tree t)
select v1.vertex as v1, v2.vertex as v2, distance(v1.vertex, v2.vertex) as distance 
from vertex v1, vertex v2 
where v1.vertex <> v2.vertex 
order by 3,1,2;


-- drop all tables and functions
drop table tree, all_edges, subtree;
drop function distance;

\qecho ''
\qecho '2: Topological sort'
\qecho ''
drop table if exists Graph;
-- creating the schema Graph 
create table Graph(source int, target int);
-- inserting into graph table.
insert into graph values 
(1,2), (1,3), (1,4), (3,4), (2,5), (3,5), (5,4), (3,6), (4,6);

\qecho ''
\qecho 'Table Graph'
Table Graph;

-- creating topological table 
create table topologicalOrder (
	nodes int primary key,
	path_length int,
	index int
);

-- drop table topologicalOrder;
create table nodesPathlength (
	nodes int, 
	pathLength int
);

-- creating supporting function to generate maximum path lengths of all nodes.
create or replace function generatePathLength()
returns void as 
$$
delete from nodesPathlength;
insert into nodesPathlength
with recursive nodePath (nodes, path) as (
	select g.source as nodes, array[g.source] as path from graph g
	union 
	select distinct g.target, np.path || g.target 
	from nodePath np join graph g on g.source = np.nodes
)
select distinct np1.nodes, cardinality(np1.path) as pathLength from nodePath np1
where cardinality(path) >= (select max(cardinality(path)) from nodePath np2
						   where np1.nodes = np2.nodes);
$$ language sql;

-- creating function topologicalSort 
create or replace function topologicalSort() 
returns table(index int, vertex int) as 
$$
	declare 
	i int; 
	j int = 0;
	path_size bigint := (select count(1) from nodesPathlength);
	begin 
		perform generatePathLength();
		delete from topologicalOrder;
		-- loop for rest paths 
		while exists (select * from nodesPathlength 
					 except 
					 select nodes, path_length from topologicalOrder)
		loop
			j := j+1;
			insert into topologicalOrder 
			with remainderNodes as (select np.nodes, np.pathlength from nodesPathlength np 
								 except 
								 select nodes, path_length from topologicalOrder)
			select t.nodes, t.pathlength, j
			from  remainderNodes t
			where t.pathlength <= (select min(t1.pathlength) from remainderNodes t1)
			order by random() limit 1;
		end loop;
		return query select tpo.index as index, tpo.nodes as vertex from topologicalOrder tpo;
	end;
$$ language plpgsql;

\qecho ''
\qecho 'The function topological sort generates topological sorting in random fashion.'
select * from topologicalSort();
\qecho ''


-- dropping all related tables
drop table if exists topologicalOrder, nodesPathlength , Graph cascade ;
drop function topologicalSort, generatePathLength; 

\qecho ''
\qecho '3: Part-SubPart problem'
\qecho ''
drop table if exists partSubpart, basicPart;
-- Creating table partSubpart
create table partSubpart(
	pid int,
	sid int,
	quantity int,
	primary key(pid, sid)
);
-- creating table basic part
create table basicPart(
	pid int,
	weight int,
	primary key (pid)
);

-- insert into tables 
insert into partSubpart values 
(   1,   2, 4),
(   1,   3, 1),
(   3,   4, 1),
(   3,   5, 2),
(   3,   6, 3),
(   6,   7, 2),
(   6,   8, 3);
insert into basicPart values 
(   2,      5),
(   4,     50),
(   5,      3),
(   7,      6),
(   8,     10);

\qecho ''
\qecho 'Table PartSubpart'
table partSubpart;
\qecho ''
\qecho 'Table Basic Part'
table basicpart;
\qecho ''

-- Creating the function aggregatedWeight(par_id)
create or replace function aggregatedWeight(part_id integer) 
returns numeric as 
$$
/*This section calculates all the sub-parts of a part recursively*/
with recursive sub_parts(sid, pid, quantity) as (
	select sid, pid, quantity 
	from partSubPart p 
	where p.pid = aggregatedWeight.part_id
	union all 
	select p.sid, p.pid, p.quantity 
	from sub_parts sp, partSubPart p 
	where p.pid = sp.sid
),
/*This section calculates the total weight of each sub-part or a part,
this will only include total cost of basic parts alone*/
basicPartWeight as (
	select pid, sum(quantity*weight) as part_Weight 
	from sub_parts agg 
	natural join (select pid as sid, weight 
				  from basicPart bp) bp
	group by (pid)
),
/*This section calculates the unit weight of each parts only
this will not include weight of any basic part alone*/
unit_Weight as (
	select sid, sum(quantity*bpc.part_Weight) as unit_Weight  
	from (select sid, quantity 
		  from sub_parts agg) agg 
	natural join (select pid as sid, part_Weight from basicPartWeight bpc) bpc
	group by (agg.sid)
),
/* Here, I sum the two aggregated weights calculated in last two sections, 
sum of aggregated weight of a part and sub-parts together.*/
agg_Weight as (
	select sid, unit_Weight 
	from unit_Weight uc
	union 
	select pid as sid, part_Weight as unit_Weight 
	from basicPartWeight bpc2 
	where bpc2.pid not in (select sid 
						  from unit_Weight)
	union 
/*If the function is called with only basic part number then this will
fetch the weight of that part from basicPart table.*/
	select pid as sid, weight as unit_weight
	from basicPart 
	where pid = part_id
)
select sum(unit_Weight) as Agg_Weight from agg_Weight;
$$ language sql;

\qecho ''
\qecho 'The aggregated weight of each part'
select distinct pid, AggregatedWeight(pid)
from   (select pid from partSubPart union select pid from basicPart) q order by 1;

--dropping all functions and tables 
drop table if exists partSubpart, basicPart;
drop function aggregatedWeight;

\qecho ''
\qecho '4: Apriori'
\qecho ''

drop table if exists document cascade;
-- creating table to store doc and words 
create table document(doc text primary key, words text[]);
-- inserting values into document
insert into document values
('d7', '{C,B,A}'),
('d1', '{A,B,C}'),
('d8', '{B,A}'),
('d4', '{B,B,A,D}'),
('d2', '{B,C,D}'),
('d6', '{A,D,G}'),
('d3', '{A,E}'),
('d5', '{E,F}');

\qecho 'table document'
table document;

-- creating view for all words in the all documents.
create or replace view all_words as 
select array( select distinct unnest(words) as all_words from document) as all_words;

create or replace function frequentSets(t int) 
returns setof text[] as 
$$
with recursive sets (set) as (
		select array[unnest(all_words)] as set
		from all_words
		union 
		select '{}'::text[] as set
		union  
		select array( select un
					from unnest(t.set || array[g]) un 
					order by un)  as set
		from sets t, all_words aw, unnest(aw.all_words) g
		where not (array[g] <@ t.set) 
	),
	document_sets as (select s.set as set, array(select d.doc 
								  from document d 
								   where s.set <@ words) as doc_array
					from sets s),
	Tfrequent_sets as (select ds.set, cardinality(doc_array) as doc_count
					  from document_sets ds 
					  where cardinality(doc_array) >=frequentSets.t)
select distinct set from Tfrequent_sets;
$$ language sql;

\qecho 'select frequentsets(1);'
select * from frequentSets(1);
\qecho 'select frequentsets(2);'
select * from frequentSets(2);
\qecho 'select frequentsets(3);'
select * from frequentSets(3);
\qecho 'select frequentsets(4);'
select * from frequentSets(4);
\qecho 'select frequentsets(5);'
select * from frequentSets(5);
\qecho 'select frequentsets(6);'
select * from frequentSets(6);
\qecho 'select frequentsets(7);'
select * from frequentSets(7);


drop table if exists document cascade;
drop function frequentSets;

\qecho ''
\qecho '5'
\qecho ''
/*
Description
1. After inserting the points in Points table, with PID as primary key, I create a table Centroids
2. Table centroids will contain the coordinates of the randomly generated centroids values during 
initilization process.
3. then I create a pointsCentroid table, which keeps the record of randomly assigned centroid 
values of the pids' from points table, This table will be repeatedly updated during the execution 
of Kmeans function.
4. The output of the Kmeans algorithm can be seen using pointsCentroid table which should show the 
reassigned centroid values of each pid represented by cid of each centroid.
5. sometimes, when Kmeans is run for more number of K than present in data, you might see some centroids
assigned to null values. 
6. EXIT Condition: in Kmeans function I have used two exit conditions, first, I have set the maximum 
number of iteration to 500, so if the function do no converge in 500 iteration it will automatically exit, 
second, i also track the reassigned values of centroids, so the program will exit early, if during reAssignment
of centroid to the points, nothing changes. 
*/

drop table if exists Points;
-- Kmeans clustering 
create table Points(pid int, x float, y float, primary key (pid));
-- inserting values into table 
insert into Points values 
(   1 , 0 , 0),
(   2 , 2 , 0),
(   3 , 4 , 0),
(   4 , 6 , 0),
(   5 , 0 , 2),
(   6 , 2 , 2),
(   7 , 4 , 2),
(   8 , 6 , 2),
(   9 , 0 , 4),
(  10 , 2 , 4),
(  11 , 4 , 4),
(  12 , 6 , 4),
(  13 , 0 , 6),
(  14 , 2 , 6),
(  15 , 4 , 6),
(  16 , 6 , 6),
(  17 , 1 , 1),
(  18 , 5 , 1),
(  19 , 1 , 5),
(  20 , 5 , 5);

\qecho ''
\qecho 'This points table.'
table points;
\qecho ''

-- table that will store the values of centroids.
create table centroids( 
		cid int, 
		c_x float, 
		c_y float,
		primary key (cid));

-- creating table that will keep the points mapping with centriod cid
create table pointsCentroid(pid int, 
							cid int,
							old_cid int,
							primary key(pid, cid));
							
-- create a table that will contain the old centroid assignment, new centroid assignment and distance.
/*This table is kind of temporary table which is used during the running of reAssignCentriod function*/
create table centroid_assignment_table(
	old_cid int, cid int, distance float
);

-- random centroid values generation based on K from user input
/*This function generates the initial values of K centroids*/
create or replace function init_centroid( k int) 
returns void as 
$$
	declare 
	c1 int ;
	c_x float;
	c_y float;
	begin
		delete from centroids;
		for c1 in 1..k
		loop 
		-- randomly choosing values from point table as centroid values.
			c_x := (select p.x from points p order by random() limit 1 );
			c_y := (select p.y from points p order by random() limit 1 );
		-- randomly generating the centroid values.
-- 			c_x := (select floor(random()*10));
-- 			c_y := (select floor(random()*10));
			insert into centroids values (c1, c_x, c_y);
		end loop;
	end;
$$ language plpgsql;

-- random assignemnt of centroids on point table. 
/*
This function assings a cid value to a pid value randomly for the first time.
after then only reassignments are done based on Kmeans algo
*/
create or replace function centroid_assignment() 
returns void as 
$$
	declare
	i int;
	c int;
	points bigint := (select count(1) from points);
	begin
		delete from pointsCentroid;
		FOR i IN 1..points 
			LOOP
			 c := (select c.cid from centroids c order by random() limit 1);
			 insert into pointsCentroid values (i, c, c);
			END LOOP;
	end;
$$ language plpgsql;

/* this function calculated euclidean distance from all centroids for a point and  
then the point pid is reassigned to centroid cid based on minimum distance
*/
create or replace function reAssignCentriod(pid int, old_cid int)
returns void as 
$$	
	declare 
	cent_num int;
	x float := (select p.x from points p where p.pid = reAssignCentriod.pid);
	y float := (select p.y from points p where p.pid = reAssignCentriod.pid);
	num_centroids bigint := (select count(1) from centroids);
	cx float;
	cy float;
	dist float;
	new_cid int;
	begin 
		delete from centroid_assignment_table;
		for cent_num in 1..num_centroids
		loop
			cx := (select c.c_x from centroids c where c.cid = cent_num);
			cy := (select c.c_y from centroids c where c.cid = cent_num);
		 	dist := (select sqrt(pow(x - cx,2) + pow(y - cy,2)));	
			insert into centroid_assignment_table values (reAssignCentriod.old_cid, cent_num, dist);
		end loop;
		new_cid := (select distinct cat.cid from centroid_assignment_table cat
				   where cat.distance = (select min(distance) from centroid_assignment_table limit 1) limit 1);
		update pointsCentroid  pc
		set cid = new_cid, old_cid = reAssignCentriod.old_cid 
		where pc.pid = reAssignCentriod.pid;
	end;
$$ language plpgsql;

-- The main Kmeans() function
create or replace function Kmeans(K int) 
returns table(cid int, x float, y float) as 
$$
	declare 
	i int; j int; c int;
	itr int := 500;
	old_cid int;
	point_table_size bigint;
	begin
-- all preparation work 
		perform init_centroid(Kmeans.k);
		perform  centroid_assignment();
		point_table_size := (select count(*) from points);
		-- loop for number of times iteration is defined.
		for i in 1..itr
		loop 
-- 		RAISE NOTICE 'number of iterations(%)', i;
		-- loop for each point in point table for reassigning centroids.
			for j in 1..point_table_size
			loop 
				old_cid := (select pc.cid from pointsCentroid pc where pc.pid = j);
				perform reAssignCentriod(j,old_cid);				
			end loop;
			for c in 1..Kmeans.k
			loop 
			-- loop to updata centroid values after reassigning the centroids.
				update centroids 
				set c_x = (select avg(p.x)
							 from points p natural join PointsCentroid pc natural join centroids cen
							where cen.cid = c),
					c_y = (select avg(p.y)
							 from points p natural join PointsCentroid pc natural join centroids cen
							where cen.cid = c)
				where centroids.cid = c;
			end loop;
			-- checking exit condition of no change in centroids
-- 			if (select not exists(select 1 from pointsCentroid p 
-- 								 where p.cid <> p.old_cid)) then exit;
-- 			end if;
		end loop;
		return query select c.cid as cid, c.c_x as x, c.c_y as y from Centroids c;
	end;
$$ language plpgsql;

\qecho ''
\qecho 'running Kmeans algorithm for 500 iteration'
select * from Kmeans(4);


drop table if exists Points, centroids, pointsCentroid, centroid_assignment_table cascade;
drop function init_centroid, centroid_assignment, reAssignCentriod, Kmeans;
-- connect to default database
\c postgres;

--Drop database created
drop database assignment8vkvats;