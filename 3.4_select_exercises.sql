use albums_db;

describe albums;

-- The name of all albums by Pink Floyd
SELECT * FROM albums WHERE artist ='Pink Floyd';

-- The year Sgt. Pepper's Lonely Hearts Club Band was released
SELECT release_date FROM albums WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band';

-- The genre for the album Nevermind
describe albums;
SELECT genre FROM albums WHERE name = 'Nevermind';

-- Which albums were released in the 1990s
describe albums;
SELECT * FROM albums
WHERE release_date >= 1990 AND release_date < 2000;

-- Which albums had less than 20 million certified sales
SELECT * FROM albums
WHERE sales < 20.0;

-- All the albums with a genre of "Rock". Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?
SELECT * FROM albums
WHERE genre = "Rock";

-- ANSWER TO WHY QUESTION: Query is searching a specific genre "Rock". To inclusively show albums that have a tag "rock", the following query should be run:

SELECT * FROM albums
WHERE genre LIKE '%rock%';
