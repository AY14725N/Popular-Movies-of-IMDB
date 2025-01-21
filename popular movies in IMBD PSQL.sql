CREATE TABLE TMDB (
    num INT,
    title VARCHAR(150),
    overview VARCHAR(1000), 
    original_language VARCHAR(50),
    vote_count INT,
    vote_average NUMERIC 
);

ALTER TABLE TMDB
ADD CONSTRAINT pk_tmdb PRIMARY KEY (num);

ALTER TABLE TMDB
ALTER COLUMN title SET NOT NULL,
ALTER COLUMN overview SET NOT NULL,
ALTER COLUMN original_language SET NOT NULL,
ALTER COLUMN vote_average SET NOT NULL;

UPDATE TMDB
SET overview = 'Some non-null value'
WHERE overview IS NULL;

SELECT * FROM TMDB LIMIT 10;

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

-- Create a procedure that retrieves information from the TMDB table
CREATE OR REPLACE FUNCTION get_movie_info(movie_id INT) 
RETURNS TABLE (
    title VARCHAR(150),
    overview VARCHAR(1000),
    original_language VARCHAR(50),
    vote_count INT,
    vote_average NUMERIC
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT title, overview, original_language, vote_count, vote_average
    FROM TMDB
    WHERE id = movie_id;
END;
$$ LANGUAGE plpgsql;

-- Create a view that displays movie information from TMDB
CREATE VIEW MovieView AS
SELECT  title, overview, original_language, vote_count, vote_average
FROM TMDB
WHERE vote_average > 7;

SELECT * FROM MovieView;

-- Create an index on the 'title' column of the TMDB table
CREATE INDEX tmdb_title_index ON TMDB (title);

CREATE UNIQUE INDEX idx_title_movie ON TMDB (overview);

-- Retrieve movies from TMDB, ordered by vote_average in descending order
SELECT *
FROM TMDB
ORDER BY vote_average DESC;

-- Calculate the average vote average for all movies in the TMDB table
SELECT AVG(vote_average) FROM TMDB;

NESTED QUERY

SELECT *
FROM TMDB
WHERE vote_average > (SELECT AVG(vote_average) FROM TMDB);

Scalar Subquery

SELECT *
FROM TMDB
WHERE vote_average = (SELECT MAX(vote_average) FROM TMDB);













