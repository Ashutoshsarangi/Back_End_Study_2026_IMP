-- Functions
CREATE OR REPLACE FUNCTION get_book_by_language(p_language VARCHAR)
RETURNS SETOF books
LANGUAGE sql
AS $$
    SELECT * FROM books WHERE language = p_language;
	-- we can add more insert / update to other tables as well
$$;


SELECT * FROM get_book_by_language('Odia');


-- Procedures
	-- Here in POSTGRESQL, the procedure concept is bit different
	