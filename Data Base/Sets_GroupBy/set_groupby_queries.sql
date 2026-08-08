select * from translators;
select * from authors;


-- Union 

select first_name, last_name from translators union select first_name, last_name from authors;

-- intersect

select first_name, last_name from translators intersect select first_name, last_name from authors;

-- Except (Only translator + not in both)

select first_name, last_name from translators except select first_name, last_name from authors;

-- Except (Only author + not in both)

select first_name, last_name from authors except select first_name, last_name from translators;

--- Group By

select * from ratings;

select book_id, ROUND(avg(score), 2) as "Average Score" from ratings group by book_id;


-- Wrong Query for PostgresSQL
select book_id, ROUND(avg(score), 2) as "Average Score" from ratings group by book_id 
	having "Average Score" > 4.80;

-- When PostgreSQL evaluates a query, it runs clauses in the following sequence:

-- FROM
-- GROUP BY
-- HAVING
-- SELECT (Aliases like "Average Score" are created here)

-- Because the HAVING clause is evaluated before the SELECT clause, PostgreSQL does not know what "Average Score" means yet.

-- Correct Query 

select book_id, ROUND(avg(score), 2) as "Average Score" from ratings group by book_id 
	having avg(score) > 4.80;

-- Group by + having + Order by
select book_id, ROUND(avg(score), 2) as "Average Score" from ratings group by book_id 
	having avg(score) > 4.80 order by book_id DESC;
