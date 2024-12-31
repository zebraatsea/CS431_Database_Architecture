-- 1. lists the artists (on screen and offscreen) that
	-- worked in more than 1 movie

CREATE OR REPLACE VIEW popular_technicians 
	(technicians, no_of_movies_worked)
    AS
		SELECT a.last_name AS technicians, COUNT(DISTINCT m.movie_id) AS no_of_movies_worked
        -- display last name of technitian and # of distinct movies they've worked
		FROM artists a 
			JOIN movie_cast mc
				ON a.artist_id = mc.person_id
			JOIN movies m
				ON mc.movie_id = m.movie_id
		GROUP BY a.artist_id
		HAVING COUNT(DISTINCT m.movie_id) > 1  -- only showing technitians who've worked 
												 -- on more than 1 distinct movie
        ORDER BY COUNT(DISTINCT m.movie_id) ASC;
-- end view
        
SELECT * FROM popular_technicians;


-- 2. Creates a cursor for a result set that contains the movie name, 
	-- distributor, and year of release for ea/ movie with gross > $2million
DROP PROCEDURE IF EXISTS must_watch_movies;
DELIMITER //

CREATE PROCEDURE must_watch_movies()
BEGIN
	DECLARE m_name VARCHAR(45);
    DECLARE m_distributor VARCHAR(45);
    DECLARE m_release DATETIME;
    DECLARE movie_data VARCHAR(500) DEFAULT "";
    DECLARE m_gross DECIMAL(6,2);
    
    -- declare continue handler
    DECLARE no_records INT DEFAULT FALSE;
    
    -- declare cursor
	DECLARE movie_cursor CURSOR
		FOR SELECT title, Distributor, release_date, gross
        FROM movies
        ORDER BY title ASC;
	
    -- set up declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET no_records = TRUE;
	
    OPEN movie_cursor;
    WHILE no_records = FALSE DO
		-- fetch new values
		FETCH movie_cursor INTO m_name, m_distributor, m_release, m_gross;
    
		-- check if gross over $2 mil
		IF m_gross > 2.0 THEN
			SET movie_data = CONCAT(movie_data, '\'', m_name, ' ', YEAR(m_release), '\' ||| ');
		END IF;
    END WHILE;
    CLOSE movie_cursor;
    
    -- display result
    SELECT movie_data AS "Must Watch Movies";
END//

DELIMITER ;
CALL must_watch_movies();
