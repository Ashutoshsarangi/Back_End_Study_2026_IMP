select * from movies where title = 'Shadow 1000007'; --157 ms

select * from stars;


-- Indexing 

create index title_index on movies ("title");

-- After indexing
select * from movies where title = 'Shadow 1000007'; --73 ms

-- It will explain the query
Explain select * from movies where title = 'Shadow 1000007';

----------------------

select * from people;
select * from stars;

-- 119ms
explain select * from movies where id in (
	select movie_id from stars where person_id in(
		select id from people where name = 'Maria Smith' and birth = '1934'
	)
)

-- indexes uses b-tree data structure under the hood


