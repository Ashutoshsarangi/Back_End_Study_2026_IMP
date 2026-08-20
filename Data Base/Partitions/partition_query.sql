select * from books;

create view books_2002 as
	select title, isbn from books where publication_year='2002';

create view books_1967 as
	select title, isbn from books where publication_year='1967';
	
select * from books_2002;
select * from books_1967;

INSERT INTO public.books(
	title, isbn, publication_year, publisher_id, language, page_count)
	VALUES ('Half Girlfriend', '123456789', 2002, 2, 'Odia', 500);

-- With the views we can have 
	-- Security
		-- we will not show all the columns here.
		-- What ever we need only going to show and make anonomyse the rows
		-- Also we can grant Rolls / Access control to a user to only see the view not the table.
	-- Partitioning
		-- With this we can handle millions of recorded table to partion it with logical ways
	-- Soft Deletion
-- We can't directly modify the view, but we can set a trigger do do the same.
	-- we will add trigger to the view but in trigger function we will update the actual table
