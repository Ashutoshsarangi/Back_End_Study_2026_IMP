-- IMDB schema (CS50-style): movies, people, stars, ratings
-- Run against PostgreSQL, e.g.:
--   psql -d your_db -f 01_create_tables.sql
--
-- Load order: 01_create_tables.sql -> 02_load_data.sql -> 03_indexes.sql

DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS stars CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS people CASCADE;

CREATE TABLE movies (
    id    BIGINT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year  INT NOT NULL CHECK (year >= 1870 AND year <= 2100)
);

CREATE TABLE people (
    id    BIGINT PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    birth INT CHECK (birth IS NULL OR (birth >= 1800 AND birth <= 2100))
);

-- Many-to-many: which person starred in which movie
CREATE TABLE stars (
    movie_id  BIGINT NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
    person_id BIGINT NOT NULL REFERENCES people(id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, person_id)
);

-- One aggregated rating row per movie (IMDB-style score + vote count)
CREATE TABLE ratings (
    movie_id BIGINT PRIMARY KEY REFERENCES movies(id) ON DELETE CASCADE,
    rating   NUMERIC(3, 1) NOT NULL CHECK (rating >= 1.0 AND rating <= 10.0),
    votes    INT NOT NULL CHECK (votes >= 0)
);
