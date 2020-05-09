---------------------------------------------------------------------------------------------
drop function aggregatedWeight;

create or replace function aggregatedWeight(part_id integer) 
returns table(sid int, pid int, quantity int) as 
$$
with recursive sub_parts(sid, pid, quantity) as (
	select sid, pid, quantity 
	from partSubPart p 
	where p.pid = part_id
	union all 
	select p.sid, p.pid, p.quantity 
	from sub_parts sp, partSubPart p 
	where p.pid = sp.sid
)select sid, pid, quantity from sub_parts;
$$ language sql;

select * from aggregatedWeight(1);

/*
for calculating aggregatedWeight, number of different pid's = number of different summation in calculation

*/

with basicPartWeight as (
	select pid, sum(quantity*weight) as part_Weight 
	from aggregatedWeight(1) agg 
	natural join (select pid as sid, weight 
				  from basicPart bp) bp
	group by (pid)
),
unit_Weight as (
	select sid, sum(quantity*bpc.part_Weight) as unit_Weight  
	from (select sid, quantity 
		  from aggregatedWeight(1) agg) agg 
	natural join (select pid as sid, part_Weight from basicPartWeight bpc) bpc
	group by (agg.sid)
),
agg_Weight as (
	select sid, unit_Weight 
	from unit_Weight uc
	union 
	select pid as sid, part_Weight as unit_Weight 
	from basicPartWeight bpc2 
	where bpc2.pid not in (select sid 
						  from unit_Weight)
)
select sum(unit_Weight) as Agg_Weight from agg_Weight;
-----------------------------------------------------------------------------------------------




-- create table to store path and its path length from top 
create table path (start_point int, end_point int, path_length int);

table path;
-- for finding new path
create or replace function new_path()
returns table (start_point integer, end_point integer) AS
$$
   select p.start_point as start_point, g.target as end_point
    from path p JOIN graph g ON (p.end_point = g.source)
   except
   select  start_point, end_point
    from path;
$$ LANGUAGE SQL;
	
create or replace function path_finder()
returns void as 
$$
declare 
path_length int :=1;
begin
   delete from path;   
   with source as (select distinct g.source as source 
				from graph g 
				where g.source not in (select g.target 
									   from graph g))
   insert into path 
   select source, target, 1 from graph
   union 
   select s.source, s.source, 0 from source s;
   
   while exists(select * from new_path()) 
   loop
   		path_length := path_length + 1;
        insert into path 
		select start_point, end_point, path_length from new_path();
   end loop;
end;
$$ language plpgsql;
--------------------------------------------------------------------------
question topological sorting 

-- delete from Graph;
-- insert into Graph values 
-- (17, 12), (12, 6), (8,12),(8,1), (8,9), (5,9),
-- (5,100),(9,3),(3,14),(3,2),(100,50),(100,4),
-- (4,18),(4,19),(4,10);


-- delete from Graph;
-- insert into Graph values 
-- (1,2),(1,3), (1,4), (1,5);
-- -- alternate data for relation Graph 
-- delete from Graph;
-- insert into Graph values 
-- (1,2), (2,3), (3, 4), (4,5);
-- -- alternate values for graph 

problem: apriori
-- generate all subset of set words from all_words.
create or replace function all_possible_set_x (wordArray anyarray)
returns setof anyarray as 
$$
	with recursive sets (set, nums) as (
	select wordArray[i:i], array[i] from generate_subscripts(wordArray,1) i 
		union all 
		select t.set || wordArray[j], t.nums || j
		from sets t, generate_subscripts(wordArray, 1) j
		where J > all(t.nums)
	)
select set from sets;
$$ language sql;

-------------------------------------------------------------------------
with recursive length(firstNode, lastNode) as (
	select t.child, t.parent from tree t where t.child=2
	union all 
	select l.firstNode, t.parent 
	from tree t join length l on (l.lastNode=t.child)
)select * from length;

--this is forward flowing 
with recursive length(firstNode, lastNode) as (
	select t.parent, t.child from tree t where t.parent=
	union all 
	select l.firstNode, t.child 
	from tree t join length l on (l.lastNode=t.parent) 
)select * from length;

------------------------------------------------------------------------------------------
-- create funtion to find new edges 
create or replace function distance(vertex1 int, vertex2 int)
returns int as 
$proc$
	declare 
	distance int := 1;
	dist_value int;
	begin
		create or replace function edge_pairs() 
		returns table(ancestor int, child int) as 
		$$
			begin 
				return query select a.ancestor, t.child 
				from ANC a join Tree t on (a.child = t.parent)
				except 
				select a.ancestor, a.child 
				from anc a;
			end;
		$$ language plpgsql;
		delete from ANC;
		insert into ANC 
		select parent, child, distance from tree 
		union 
		select child, parent, distance from tree;
		while exists (select * from edge_pairs())
		loop 
			distance := distance + 1;
			insert into ANC 
			select ancestor, child, distance from edge_pairs() 
			union 
			select child, ancestor, distance from edge_pairs();
		end loop;
		dist_value := (select a.distance from anc a 
		where a.ancestor = vertex1 and a.child = vertex2);
		return dist_value;
	end;
$proc$ language plpgsql;


-- final code.
with vertex as ( select t.parent as vertex 
			   from tree t 
			   union 
			   select t.child as vertex 
			   from tree t)
select v1.vertex as v1, v2.vertex as v2, distance(v1.vertex, v2.vertex) as distance 
from vertex v1, vertex v2 
where v1.vertex <> v2.vertex 
and v1.vertex = 1 and v2.vertex = 3 order by 3,1,2;


drop table if exists tree, anc cascade ;
drop function distance;
------------------------------------------------------------------------------------------


