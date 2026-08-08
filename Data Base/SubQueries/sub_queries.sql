select * from books;

select * from publishers;

select * from books where publisher_id = 5

select publisher_id from publishers where name = 'Ashu';

select * from ratings;

select * from book_authors;

select * from authors;

-- Subquery
select * from books where publisher_id = (
	select publisher_id from publishers where name = 'Ashu'
)

select *, CONCAT(first_name, ' ', last_name) as full_name from authors where author_id = (
	select author_id from book_authors where book_id = (
		select book_id from books where title = 'Designing Data-Intensive Applications'
	)
);

