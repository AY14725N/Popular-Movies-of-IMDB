CREATE TABLE "TMDB" (
    num INT,
    title VARCHAR(150),
    overview VARCHAR(1000), 
    original_language VARCHAR(50),
    vote_count INT,
    vote_average FLOAT 
);


CREATE OR REPLACE FUNCTION copy_data() RETURNS VOID AS $$
BEGIN
    EXECUTE 'COPY "TMDB" FROM ''C:/Users/akshi/Downloads/TMDb_updated.CSV'' DELIMITER '','' CSV HEADER;';
END;
$$ LANGUAGE plpgsql;
SELECT copy_data();

SELECT * FROM "TMDB" LIMIT 10; -- This will return the first 10 records from the "TMDB" table.

CREATE TABLE TMDB (
    num INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    overview VARCHAR(1000) NOT NULL,
    original_language VARCHAR(50) NOT NULL,
    vote_count INT CHECK (vote_count >= 0),
    vote_average FLOAT CHECK (vote_average >= 0.0 AND vote_average <= 10.0)
);

CREATE TABLE Movies (
    num INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    overview VARCHAR(1000),
    original_language VARCHAR(50),
    vote_count INT,
    vote_average FLOAT,
    CONSTRAINT chk_vote_count CHECK (vote_count >= 0),
    CONSTRAINT chk_vote_average CHECK (vote_average >= 0.0 AND vote_average <= 10.0)
);

CREATE TABLE Languages (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);
-- Add a new column for original_language_id
ALTER TABLE TMDB ADD COLUMN original_language_id INT;

-- Create a foreign key constraint
ALTER TABLE TMDB ADD CONSTRAINT fk_original_language
    FOREIGN KEY (original_language_id) REFERENCES Languages(language_id);
	
	-- Create a procedure to retrieve movie information by title
CREATE OR REPLACE FUNCTION get_movie_info_by_title(title_param VARCHAR) RETURNS TABLE (
    movie_id INT,
    title VARCHAR,
    overview VARCHAR,
    original_language VARCHAR,
    vote_count INT,
    vote_average FLOAT
) AS $$
BEGIN
    RETURN QUERY SELECT num, title, overview, original_language, vote_count, vote_average
                 FROM TMDB
                 WHERE title = title_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_numbers(a INT, b INT) RETURNS INT AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION concat_strings(first_name VARCHAR, last_name VARCHAR) RETURNS VARCHAR AS $$
BEGIN
    RETURN first_name || ' ' || last_name;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW movie_info AS
SELECT num, title, overview
FROM TMDB;

CREATE VIEW movie_language_info AS
SELECT m.num, m.title, m.overview, l.language_name AS original_language
FROM TMDB m
JOIN Languages l ON m.original_language_id = l.language_id;

CREATE INDEX idx_title ON TMDB (title);

CREATE INDEX idx_language_vote ON TMDB (original_language, vote_average);

SELECT * FROM TMDB
ORDER BY vote_average DESC;

SELECT * FROM TMDB
WHERE vote_average BETWEEN 7.0 AND 9.0;

SELECT original_language, COUNT(*) as movie_count
FROM TMDB
GROUP BY original_language;

SELECT * FROM TMDB
WHERE original_language = 'English' AND vote_average > 7.0;

WITH high_rated_movies AS (
    SELECT *
    FROM TMDB
    WHERE vote_average > 8.0
)
SELECT * FROM high_rated_movies;

SELECT COUNT(*) FROM TMDB;

SELECT SUM(vote_count) FROM TMDB;

SELECT MIN(vote_average), MAX(vote_average) FROM TMDB;

SELECT original_language, AVG(vote_average) as avg_vote
FROM TMDB
GROUP BY original_language;

SELECT original_language, AVG(vote_average) as avg_vote
FROM TMDB
GROUP BY original_language
HAVING AVG(vote_average) > 7.0;

SELECT title
FROM TMDB
WHERE vote_count > (SELECT AVG(vote_count) FROM TMDB);

SELECT title,
       (SELECT AVG(vote_average) FROM TMDB) AS avg_vote_average
FROM TMDB;

SELECT title,
       vote_count,
       (SELECT AVG(vote_count) FROM TMDB) AS avg_vote_count
FROM TMDB
WHERE vote_count > (SELECT AVG(vote_count) FROM TMDB);
