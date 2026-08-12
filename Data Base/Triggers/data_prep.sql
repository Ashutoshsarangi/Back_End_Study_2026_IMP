-- Book collection table
CREATE TABLE book_collection (
    book_id      SERIAL PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    author       VARCHAR(150) NOT NULL,
    isbn         VARCHAR(20) UNIQUE,
    genre        VARCHAR(50),
    publisher    VARCHAR(100),
    publish_year INT,
    price        NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    quantity     INT NOT NULL DEFAULT 1 CHECK (quantity >= 0),
    status       VARCHAR(20) NOT NULL DEFAULT 'available'
                 CHECK (status IN ('available', 'sold', 'reserved')),
    acquired_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    notes        TEXT
);

-- Sample rows
INSERT INTO book_collection (title, author, isbn, genre, publisher, publish_year, price, quantity, status, notes)
VALUES
('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Fantasy', 'Houghton Mifflin', 1937, 14.99, 3, 'available', 'Paperback edition'),
('Clean Code', 'Robert C. Martin', '9780132350884', 'Programming', 'Prentice Hall', 2008, 39.99, 2, 'available', 'Software craftsmanship'),
('1984', 'George Orwell', '9780451524935', 'Dystopian', 'Signet Classic', 1949, 9.99, 5, 'available', NULL),
('Atomic Habits', 'James Clear', '9780735211292', 'Self-help', 'Avery', 2018, 18.50, 4, 'available', 'Habit building'),
('Pride and Prejudice', 'Jane Austen', '9780141439518', 'Classic', 'Penguin Classics', 1813, 11.25, 1, 'available', 'Vintage cover');

CREATE TABLE audit_book_collection (
    audit_id       SERIAL PRIMARY KEY,
    book_id        INT NOT NULL,
    action_type    VARCHAR(20) NOT NULL
                   CHECK (action_type IN ('bought', 'sold')),
    action_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    notes          TEXT
);
