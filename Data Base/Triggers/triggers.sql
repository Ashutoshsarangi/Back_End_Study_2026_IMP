--- Creating Trigger Function ---
create or replace function sell_book_collection_fn()
returns trigger as $$
BEGIN
  INSERT INTO audit_book_collection (book_id, action_type, notes)
  VALUES (OLD.book_id, 'sold', 'This is a some note');
  RETURN OLD;  -- required for BEFORE DELETE so the delete continues
END;
$$ LANGUAGE plpgsql;

-- 2
create or replace function buy_book_collection_fn()
returns trigger as $$
BEGIN
  INSERT INTO audit_book_collection (book_id, action_type, notes)
  VALUES (NEW.book_id, 'bought', NEW.title);
  RETURN NEW;  -- required for BEFORE DELETE so the delete continues
END;
$$ LANGUAGE plpgsql;

-- Creating Trigger to Use the Function ---

create trigger sell_book_collection
before delete on book_collection
for each row
EXECUTE FUNCTION sell_book_collection_fn();

-- 2
create trigger buy_book_collection
before insert on book_collection
for each row
EXECUTE FUNCTION buy_book_collection_fn();

-- Now testing queries

select * from book_collection

delete from book_collection where book_id in (1, 5);

select * from audit_book_collection;

-- Testing on 2nd Trigger buy_book_collection
INSERT INTO book_collection (title, author, isbn, genre, publisher, publish_year, price, quantity, status, notes)
VALUES
('The Hobbit 123', 'Ashu', '97805479282271', 'Fantasy', 'Houghton Mifflin', 1937, 14.99, 3, 'available', 'Paperback edition'),
('Clean Code updated', 'Anshuman', '97801323508841', 'Programming', 'Prentice Hall', 2008, 39.99, 2, 'available', 'Software craftsmanship'),
('1984 updated', 'Ishanwit', '97804515249351', 'Dystopian', 'Signet Classic', 1949, 9.99, 5, 'available', NULL);

select * from audit_book_collection;