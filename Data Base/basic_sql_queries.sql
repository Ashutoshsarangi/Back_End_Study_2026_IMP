SELECT * from public.orders;

SELECT product from public.orders LIMIT 5;

SELECT * from public.orders WHERE amount > 200 and product != 'Laptop';

 -- _  ( Undescore) also there for some spec character
SELECT * from public.orders WHERE product like '%o%';

SELECT * from public.orders ORDER BY amount LIMIT 5; -- default AScending
SELECT * from public.orders ORDER BY amount DESC LIMIT 5;

-- SQL Agrregater Function
	-- COUNT
	-- AVG
	-- MIN
	-- MAX
	-- SUM


