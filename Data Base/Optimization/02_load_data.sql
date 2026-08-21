-- Bulk load synthetic IMDB-scale data with generate_series.
-- Expected volumes:
--   people  : 500,000
--   movies  : 400,000
--   stars   : 800,000  (2 billed stars per movie)
--   ratings : 200,000  (first 200k movies)
--
-- Prerequisites: 01_create_tables.sql
-- Typical runtime: a few seconds to ~1 minute depending on machine.
--
--   psql -d your_db -f 02_load_data.sql

TRUNCATE ratings, stars, movies, people;

-- Faster bulk insert for this session (does not persist in postgresql.conf).
SET synchronous_commit = off;

INSERT INTO people (id, name, birth)
SELECT
    gs AS id,
    first_names[1 + ((gs - 1) % ARRAY_LENGTH(first_names, 1))]
        || ' '
        || last_names[1 + (((gs - 1) / ARRAY_LENGTH(first_names, 1)) % ARRAY_LENGTH(last_names, 1))]
        AS name,
    CASE
        WHEN gs % 17 = 0 THEN NULL
        ELSE 1920 + ((gs * 7) % 85)
    END AS birth
FROM generate_series(1, 500000) AS gs
CROSS JOIN LATERAL (
    SELECT
        ARRAY[
            'James', 'Maria', 'Robert', 'Jennifer', 'Michael', 'Linda',
            'David', 'Elizabeth', 'William', 'Barbara', 'Richard', 'Susan',
            'Joseph', 'Jessica', 'Thomas', 'Sarah', 'Christopher', 'Karen',
            'Charles', 'Nancy', 'Daniel', 'Lisa', 'Matthew', 'Betty',
            'Anthony', 'Margaret', 'Mark', 'Sandra', 'Donald', 'Ashley',
            'Steven', 'Kimberly', 'Paul', 'Emily', 'Andrew', 'Donna',
            'Joshua', 'Michelle', 'Kenneth', 'Dorothy', 'Kevin', 'Carol',
            'Brian', 'Amanda', 'George', 'Melissa', 'Timothy', 'Deborah',
            'Ronald', 'Stephanie', 'Edward', 'Rebecca', 'Jason', 'Sharon',
            'Jeffrey', 'Laura', 'Ryan', 'Cynthia', 'Jacob', 'Kathleen',
            'Gary', 'Amy', 'Nicholas', 'Angela', 'Eric', 'Shirley',
            'Jonathan', 'Anna', 'Stephen', 'Brenda', 'Larry', 'Pamela',
            'Justin', 'Emma', 'Scott', 'Nicole', 'Brandon', 'Helen',
            'Benjamin', 'Samantha', 'Samuel', 'Katherine', 'Raymond', 'Christine',
            'Gregory', 'Debra', 'Frank', 'Rachel', 'Alexander', 'Carolyn',
            'Patrick', 'Janet', 'Jack', 'Catherine', 'Dennis', 'Maria',
            'Jerry', 'Heather', 'Tyler', 'Diane', 'Aaron', 'Ruth',
            'Jose', 'Julie', 'Adam', 'Olivia', 'Henry', 'Joyce',
            'Nathan', 'Virginia', 'Douglas', 'Victoria', 'Peter', 'Kelly',
            'Zachary', 'Lauren', 'Kyle', 'Christina', 'Noah', 'Joan',
            'Ethan', 'Evelyn', 'Jeremy', 'Judith', 'Walter', 'Andrea',
            'Christian', 'Hannah', 'Keith', 'Megan', 'Roger', 'Cheryl',
            'Terry', 'Jacqueline', 'Austin', 'Martha', 'Sean', 'Gloria',
            'Gerald', 'Teresa', 'Carl', 'Ann', 'Dylan', 'Sara',
            'Harold', 'Madison', 'Jordan', 'Frances', 'Jesse', 'Kathryn',
            'Bryan', 'Janice', 'Billy', 'Jean', 'Joe', 'Abigail',
            'Bruce', 'Alice', 'Gabriel', 'Judy', 'Logan', 'Sophia',
            'Albert', 'Grace', 'Willie', 'Denise', 'Alan', 'Amber',
            'Eugene', 'Doris', 'Russell', 'Marilyn', 'Vincent', 'Danielle',
            'Philip', 'Beverly', 'Bobby', 'Isabella', 'Johnny', 'Theresa',
            'Bradley', 'Diana', 'Lawrence', 'Natalie', 'Harry', 'Brittany',
            'Ralph', 'Charlotte', 'Roy', 'Marie', 'Elijah', 'Kayla',
            'Randy', 'Alexis', 'Wayne', 'Lori', 'Louis', 'Marie'
        ] AS first_names,
        ARRAY[
            'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia',
            'Miller', 'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez',
            'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore',
            'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White',
            'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson',
            'Walker', 'Young', 'Allen', 'King', 'Wright', 'Scott',
            'Torres', 'Nguyen', 'Hill', 'Flores', 'Green', 'Adams',
            'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell',
            'Carter', 'Roberts', 'Gomez', 'Phillips', 'Evans', 'Turner',
            'Diaz', 'Parker', 'Cruz', 'Edwards', 'Collins', 'Reyes',
            'Stewart', 'Morris', 'Morales', 'Murphy', 'Cook', 'Rogers',
            'Gutierrez', 'Ortiz', 'Morgan', 'Cooper', 'Peterson', 'Bailey',
            'Reed', 'Kelly', 'Howard', 'Ramos', 'Kim', 'Cox',
            'Ward', 'Richardson', 'Watson', 'Brooks', 'Chavez', 'Wood',
            'James', 'Bennett', 'Gray', 'Mendoza', 'Ruiz', 'Hughes',
            'Price', 'Alvarez', 'Castillo', 'Sanders', 'Patel', 'Myers',
            'Long', 'Ross', 'Foster', 'Jimenez'
        ] AS last_names
) AS name_bank;

INSERT INTO movies (id, title, year)
SELECT
    gs AS id,
    genres[1 + ((gs - 1) % ARRAY_LENGTH(genres, 1))]
        || ' '
        || (1000000 + gs)::TEXT AS title,
    1920 + ((gs * 13) % 106) AS year
FROM generate_series(1, 400000) AS gs
CROSS JOIN LATERAL (
    SELECT ARRAY[
        'The Lost', 'Midnight', 'Silent', 'Hidden', 'Broken', 'Eternal',
        'Shadow', 'Golden', 'Iron', 'Crystal', 'Fading', 'Rising',
        'Distant', 'Frozen', 'Burning', 'Quiet', 'Wild', 'Secret',
        'Last', 'First', 'Dark', 'Bright', 'Fallen', 'Sacred',
        'Ocean', 'Desert', 'Mountain', 'River', 'City', 'Forest',
        'Winter', 'Summer', 'Autumn', 'Spring', 'Night', 'Dawn',
        'Echo', 'Storm', 'Ember', 'Glass'
    ] AS genres
) AS title_bank;

-- 2 stars per movie => 400,000 * 2 = 800,000 rows
INSERT INTO stars (movie_id, person_id)
SELECT
    m.id AS movie_id,
    1 + ((m.id + star_slot - 1) % 500000) AS person_id
FROM movies AS m
CROSS JOIN generate_series(1, 2) AS star_slot;

-- Ratings for the first 200,000 movies only
INSERT INTO ratings (movie_id, rating, votes)
SELECT
    id AS movie_id,
    ROUND((1.0 + ((id * 37) % 90) / 10.0)::NUMERIC, 1) AS rating,
    50 + ((id * 91) % 2000000) AS votes
FROM movies
WHERE id <= 200000;

ANALYZE movies;
ANALYZE people;
ANALYZE stars;
ANALYZE ratings;

SELECT 'people'  AS table_name, COUNT(*) AS row_count FROM people
UNION ALL
SELECT 'movies',  COUNT(*) FROM movies
UNION ALL
SELECT 'stars',   COUNT(*) FROM stars
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings
ORDER BY table_name;
