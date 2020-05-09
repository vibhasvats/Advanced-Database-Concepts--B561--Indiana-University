-- Assignment 8 sample solutions
-- In this note I give two different ways to solve a object-relation program
-- that involves recursion of looping

-- Powerset of set A
-- Given a set A(x int[]), we wish to construct the powerset Powerset(S int[]) of A.
-- This requires recursion or a loop
-- Consider the following recursive rules to compute the powerset


-- Solution using RECURSION (using the SQL WITH RECURSIVE construct)

--    Powerset({})    this rules states that the emptyset is an element of the powerset
--    Powerset(S union {x}) :- Powerset(S) and (x is an element of A)

-- We can turn this into a recursive PostgreSQL query as follows:

create table if not exists A(x int);
delete from A;
insert into A values (1), (2), (3);
table A;

/*
 x 
---
 1
 2
 3
(3 rows)
*/

with recursive powerset as (
      select '{}'::int[] as S
      union
      select array(select * from UNNEST(S) union select x order by 1)
      from   powerset S, A x)
select * from powerset;

/*
    s    
---------
 {}
 {1}
 {2}
 {3}
 {1,2}
 {1,3}
 {2,3}
 {1,2,3}
(8 rows)
*/

-- A more efficient solution can be obtained by using the following 
-- recursive rules

--    Powerset({})    this rules states that the emptyset is an element of the powerset
--    Powerset(S union {x}) :- Powerset(S) and (x is not an element of A-S)

--  The second rule states that we only need to consider adding an element x to S
--  if x is not already in S (i.e., x is an element A-S)

with recursive powerset as (
      select '{}'::int[] as S
      union
      select array(select * from UNNEST(S) union select x order by 1)
      from   powerset S, A x
      where  x not in (select * from UNNEST(S)))
select * from powerset;


/*
    s    
---------
 {}
 {1}
 {2}
 {3}
 {1,2}
 {1,3}
 {2,3}
 {1,2,3}
(8 rows)
*/


-- ITERATIVE solution 
-- We can also come up with a solution using
-- explict looping.

-- The idea is similar to that for the recursive solution.  We
-- initialize the powerset with the emptyset.  At stage "i" >= 1, we
-- can assume to have all elements in the powerset of size "i-1".  For
-- each of these, we add an element of A that is is not already present
-- thus making a subset of A of size "i".  We repeat this iteration
-- for |A|-1 times.  We need to make sure that during insert we don't
-- add multiple copies of the same new element.  The iterative
-- solution is as follows:
-- 
--    Powerset :=  array['{}'];
--    i = 0;
--    
--    while i <= |A|-1
--      for each element of S of Powerset of size i-1 and
--        for each element x in S-A powerset := insert S union {x} into Powerset;
--       i := i+1;
--    end while


create or replace function new_sets()
returns table (set int[]) AS
$$
  select   array(select * from UNNEST(S) union select x order by 1)::int[] as S
  from     Powerset S, A x
  where    x not in (select * from UNNEST(S))
  except
  select S from Powerset;
$$ language sql;

create or replace function Powerset()
returns table (set int[]) AS
$$
begin
   drop table if exists Powerset;
   create table Powerset(S int[]);

   insert into Powerset select array[]::int[];

   while exists(select * from new_sets()) 
   loop
        insert into Powerset select * from new_sets();
   end loop;

   return query select S  from Powerset;

end;
$$ language plpgsql;


select S as S from Powerset() S; 


/*
    s    
---------
 {}
 {2}
 {1}
 {3}
 {1,3}
 {2,3}
 {1,2}
 {1,2,3}
(8 rows)
*/

