-- 1. PUBLISHERS TABLE
CREATE TABLE publishers (
    publisher_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    website VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 2. AUTHORS TABLE
CREATE TABLE authors (
    author_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    bio TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. TRANSLATORS TABLE
CREATE TABLE translators (
    translator_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    primary_language VARCHAR(50),
    bio TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. BOOKS TABLE
CREATE TABLE books (
    book_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publication_year INT CHECK (publication_year > 0 AND publication_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 1),
    publisher_id BIGINT REFERENCES publishers(publisher_id) ON DELETE SET NULL,
    language VARCHAR(50) DEFAULT 'English',
    page_count INT CHECK (page_count > 0),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4a. JUNCTION TABLE: BOOK <-> AUTHOR (Many-to-Many)
CREATE TABLE book_authors (
    book_id BIGINT REFERENCES books(book_id) ON DELETE CASCADE,
    author_id BIGINT REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

-- 4b. JUNCTION TABLE: BOOK <-> TRANSLATOR (Many-to-Many)
CREATE TABLE book_translators (
    book_id BIGINT REFERENCES books(book_id) ON DELETE CASCADE,
    translator_id BIGINT REFERENCES translators(translator_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, translator_id)
);

-- 5. RATINGS TABLE
CREATE TABLE ratings (
    rating_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    book_id BIGINT NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
    reviewer_name VARCHAR(100) DEFAULT 'Anonymous',
    score NUMERIC(2, 1) NOT NULL CHECK (score >= 1.0 AND score <= 5.0),
    review_text TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 1. INSERT PUBLISHERS
INSERT INTO publishers (name, country, website) VALUES
('HarperCollins', 'United States', 'https://www.harpercollins.com'),
('Penguin Random House', 'United States', 'https://www.penguinrandomhouse.com'),
('O''Reilly Media', 'United States', 'https://www.oreilly.com');

-- 2. INSERT AUTHORS
INSERT INTO authors (first_name, last_name, bio) VALUES
('Gabriel', 'García Márquez', 'Colombian novelist and Nobel laureate in Literature.'),
('Haruki', 'Murakami', 'Japanese writer known for surrealist fiction.'),
('Ursula K.', 'Le Guin', 'American author of acclaimed science fiction and fantasy.'),
('Martin', 'Kleppmann', 'Computer science researcher, speaker, and author.');

-- 3. INSERT TRANSLATORS
INSERT INTO translators (first_name, last_name, primary_language, bio) VALUES
('Edith', 'Grossman', 'Spanish', 'Renowned Spanish-to-English literary translator.'),
('Philip', 'Gabriel', 'Japanese', 'Prominent Japanese-to-English translator.');

-- 4. INSERT BOOKS
INSERT INTO books (title, isbn, publication_year, publisher_id, language, page_count) VALUES
('One Hundred Years of Solitude', '9780060883287', 1967, 1, 'English', 417),
('Kafka on the Shore', '9781400079278', 2002, 2, 'English', 505),
('The Left Hand of Darkness', '9780441478125', 1969, 3, 'English', 304),
('Designing Data-Intensive Applications', '9781449373320', 2017, 3, 'English', 616);

-- 5. LINK BOOKS & AUTHORS (book_authors)
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- One Hundred Years of Solitude -> Gabriel García Márquez
(2, 2), -- Kafka on the Shore -> Haruki Murakami
(3, 3), -- The Left Hand of Darkness -> Ursula K. Le Guin
(4, 4); -- Designing Data-Intensive Applications -> Martin Kleppmann

-- 6. LINK BOOKS & TRANSLATORS (book_translators)
INSERT INTO book_translators (book_id, translator_id) VALUES
(1, 1), -- One Hundred Years of Solitude -> Edith Grossman
(2, 2); -- Kafka on the Shore -> Philip Gabriel

-- 7. INSERT RATINGS
INSERT INTO ratings (book_id, reviewer_name, score, review_text) VALUES
(1, 'Alice Johnson', 5.0, 'A masterpiece of magical realism. Stunning prose and translation.'),
(1, 'Bob Smith', 4.5, 'Captivating multi-generational saga.'),
(2, 'Carol Danvers', 4.8, 'Surreal, atmospheric, and deeply thought-provoking.'),
(3, 'David Miller', 4.9, 'A landmark achievement in science fiction worldbuilding.'),
(4, 'Eve Adams', 5.0, 'Essential reading for systems architects and backend engineers.');