-- In the problems related to simulating MapReduce in
-- Object-Relational PostgreSQL, we face the problem of "encoding"
-- relations (or multiple relations) into key-value stores.  In
-- addition, since a MapReduce program maps a key-value store to
-- another key-value store, we need to "decode" the output key-value
-- store to an relation of object-relation.  So the general method to
-- do is simulation is as followss:

--   1. Encode the relation (or relations) into a single key-value store
--   2. Run the MapReduce phase (map, group, reduce) on this key-value store
--   3. Decode the key-value store that is the result of this Mapreduce program
--      back to a relation (or relations).

-- There is a general strategy to transform a relation (or multiple
-- relations ) into a single key-value store. 

-- Consider the following relation R:

drop table r;

create table R (a int, b int, c int);
insert into R values (1,2,3), (4,5,6), (1,2,4);

table R;

-- a | b | c 
-----+---+---
-- 1 | 2 | 3
-- 4 | 5 | 6
-- 1 | 2 | 4
-- (3 rows)


-- Starting from this relation R, we can, using json objects, come up
-- with an encoding of R as a key-value store as follows:
-- Take for example the tuple (1,2,3) in R.
-- We will encode this tuple as the key-value pair 
--        ('R',{"a": 1, "b":2, "c": 1})
-- To do this, we will use the json_build_object PostgreSQL function:

drop table encodingofR;

create table encodingofR (key text, value jsonb);

insert into encodingofR select 'R' as Key, json_build_object('a', r.a, 'b', r.b, 'c', r.c)::jsonb as Value
                        from   R r;

table encodingofR;

-- This gives the following encoding for R. Each tuple of R is
-- represent using a json object with fields that correspond to the
-- attributes of that tuple in R.  Notice that this strategy works in
-- general for any relation, independent of the number of attributes
-- in that relations schema.

--  key |            value            
-----+-----------------------------
-- R   | {"a" : 1, "b" : 2, "c" : 3}   -- this key-value pair represents the R-tuple (1,2,3)
-- R   | {"a" : 4, "b" : 5, "c" : 6}   -- this key-value pair represents the R-tuple (4,5,6)
-- R   | {"a" : 1, "b" : 2, "c" : 4}   -- this key-value pair represents the R-tuple (1,2,4)
--(3 rows)


-- We can also then "decode" the encodingofR key-value store back to the relation R:

select r.value->'a' as a, r.value->'b' as b, r.value->'c' as c from encodingofR r;

-- a | b | c 
-----+---+---
-- 1 | 2 | 3
-- 4 | 5 | 6
-- 1 | 2 | 4
--(3 rows)


-- Another interesting aspect of this encoding strategy is that it is
-- possible to put multiple relations into the same key value store.

-- Let us add a binary relation S:

drop table S;

create table S (a int, d int);

insert into S values (1,2), (5,6), (2,1), (2,3);

drop table encodingofRandS;

create table encodingofRandS(key text, value jsonb);


insert into encodingofRandS select 'R' as Key, json_build_object('a', a, 'b', b, 'c', c)::jsonb as Value
                            from   R
                            union
                            select 'S' as Key, json_build_object('a', a, 'd', d)::jsonb as Value
                            from   S order by 1, 2;

table encodingofRandS;

-- key |          value           
-----+--------------------------
-- R   | {"a": 1, "b": 2, "c": 3}
-- R   | {"a": 1, "b": 2, "c": 4}
-- R   | {"a": 4, "b": 5, "c": 6}
-- S   | {"a": 1, "d": 2}
-- S   | {"a": 2, "d": 1}
-- S   | {"a": 2, "d": 3}
-- S   | {"a": 5, "d": 6}
--(7 rows)


-- Sample problem
-- Write, in PostgreSQL, a basic MapReduce program, i.e., a mapper
-- function and a reducer function, as well as a 3-phases simulation that
-- implements the set intersection of two unary relations $R(A$) and
-- $S(A)$, i.e., the relation $R intersect S$.  You can assume that the domain of
-- $A$ is integer.

-- EncodingOfRandS;

drop table R; drop table S;

create table R(a int); create table S(a int);

insert into R values (1),(2),(3),(4);
insert into S values (2),(4),(5);

drop table EncodingOfRandS;
create table EncodingOfRandS(key text, value jsonb);

insert into EncodingOfRandS
   select 'R' as Key, json_build_object('a', a)::jsonb as Value
   from   R
   union
   select 'S' as Key, json_build_object('a', a)::jsonb as Value
   from   S order by 1;

table EncodingOfRandS;

-- key |  value   
-------+----------
-- R   | {"a": 1}
-- R   | {"a": 2}
-- R   | {"a": 3}
-- R   | {"a": 4}
-- S   | {"a": 2}
-- S   | {"a": 4}
-- S   | {"a": 5}
--(7 rows)



-- Map function
CREATE OR REPLACE FUNCTION Map(KeyIn text, ValueIn jsonb)
RETURNS TABLE(KeyOut jsonb, ValueOut jsonb) AS
$$
    SELECT ValueIn::jsonb, json_build_object('RelName', KeyIn::text)::jsonb;
$$ LANGUAGE SQL;

-- Reduce function
CREATE OR REPLACE FUNCTION Reduce(KeyIn jsonb, ValuesIn jsonb[])
RETURNS TABLE(KeyOut text, ValueOut jsonb) AS
$$
    SELECT 'R intersect S'::text, KeyIn WHERE 
            array['{"RelName": "R"}','{"RelName": "S"}']::jsonb[] <@ ValuesIn::jsonb[];
$$ LANGUAGE SQL;

-- Simulate MapReduce Program and decode

WITH
Map_Phase AS (
    SELECT m.KeyOut, m.ValueOut 
    FROM   encodingOfRandS, LATERAL(SELECT KeyOut, ValueOut FROM Map(key, value)) m
),
Group_Phase AS (
    SELECT KeyOut, array_agg(Valueout) as ValueOut
    FROM   Map_Phase
    GROUP  BY (KeyOut)
),
Reduce_Phase AS (
    SELECT r.KeyOut, r.ValueOut
    FROM   Group_Phase gp, LATERAL(SELECT KeyOut, ValueOut FROM Reduce(gp.KeyOut, gp.ValueOut)) r
)
SELECT valueOut->'a' as A FROM Reduce_Phase order by 1;

-- a 
-- ---
-- 2
-- 4
--(2 rows)

