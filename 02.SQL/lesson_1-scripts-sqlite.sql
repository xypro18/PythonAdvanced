-- ***************
-- Part 1
-- ***************

-- create new db - sql_lesson.db

-- creating tables
CREATE TABLE zoo (
    id integer PRIMARY KEY,
    animal varchar(10),
    water_need integer
);

-- inserting values
INSERT INTO zoo (id,animal,water_need) VALUES
    (1001,'elephant',500),
    (1002,'elephant',600),
    (1003,'elephant',550),
    (1004,'tiger',300),
    (1005,'tiger',320),
    (1006,'tiger',330),
    (1007,'tiger',290),
    (1008,'tiger',310),
    (1009,'zebra',200),
    (1010,'zebra',220),
    (1011,'zebra',240),
    (1012,'zebra',230),
    (1013,'zebra',220),
    (1014,'zebra',100),
    (1015,'zebra',80),
    (1016,'lion',420),
    (1017,'lion',600),
    (1018,'lion',500),
    (1019,'lion',390),
    (1020,'kangaroo',410),
    (1021,'kangaroo',430),
    (1022,'kangaroo',410);

-- select everything  
select * from zoo;

-- select only some columns
select animal, water_need from zoo;

-- select only some rows
select id, animal from zoo limit 10;

-- filtering results
select * from zoo where animal = 'tiger';

select * from zoo where animal <> 'tiger';

select * from zoo where id > 1010;

select * from zoo where water_need between 100 and 400;

-- Exercise: Select the first 3 zebras from the zoo table
-- Answer:

-- filtering results - text search
select * from zoo where animal like '%e%';

select * from zoo where animal like 'e%';

select * from zoo where animal like '_____';

select * from zoo where animal like 'z____';

select * from zoo where animal like '%e___';

select * from zoo where animal like '%e_e%';

-- filtering results - multiple conditions
select * from zoo where animal = 'zebra' and water_need > 200;

-- Imagine a situation where you want to select all the animals whose unique id is any of these: 1001, 1008, 1012, 1015, 1018.
-- You could do this:
select * from zoo
where
  id = 1001
  or id = 1008
  or id = 1012
  or id = 1015
  or id = 1018;
  
-- Or use the IN operator:
select * from zoo where id in (1001,1008,1012,1015,1018);

-- filtering results - negating conditions
select * from zoo where id not in (1001,1008,1012,1015,1018);

-- Exercise: we want all the zebras that either consume more than 220 or have an id lower than 1012
-- Answer:

-- ***************
-- Part 2
-- ***************

-- Working with big datasets
-- arrival and departure details of all commercial flights in the US from 2007

-- File -> Import -> Table from CSV file -> flight_delays.csv

-- check if import was successful
SELECT * FROM flight_delays LIMIT 10;

-- Exercise:
-- How many flights did the plane with the tail-number ‘N253WN’ take on 23rd April, 2007?

  
-- Exercise 2:
-- Select all the rows with these conditions:
	-- the flight was in April 2007
	-- it was an even weekday (2nd, 4th or 6th day of the week)
	-- the flight distance was less than 50 miles
	-- either the departure or the arrival delay was less than 0 (means the plane took off or landed earlier than planned)

  
-- Aggregation
SELECT COUNT(*) FROM flight_delays LIMIT 10;

SELECT SUM(airtime) FROM flight_delays;

SELECT AVG(depdelay) FROM flight_delays;

SELECT MIN(distance) FROM flight_delays;

SELECT MAX(distance) FROM flight_delays;

-- Segmentation
-- Imagine you wanted the average departure delay by airport (origin column) 
SELECT
  AVG(depdelay),
  origin
FROM flight_delays
GROUP BY origin;

-- This will take a long time! 183 seconds..
-- Let's create an index of origins and see if that helps:
CREATE INDEX "origins" ON "flight_delays" (
	"Origin"	ASC
);
-- Wow! 13 seconds!

-- We could create indexes on the other categorical columns as well, but that would take too long right now.
-- Close this database and open sql_lesson-indexed.db
CREATE INDEX "months" ON "flight_delays" (
	"Month"	ASC
)
CREATE INDEX "tailnums" ON "flight_delays" (
	"TailNum"	ASC
)
CREATE INDEX "dests" ON "flight_delays" (
	"Dest"	ASC
);
CREATE INDEX "daysofweek" ON "flight_delays" (
	"DayOfWeek"	ASC
);

-- Exercise: Get the total monthly airtime
-- Answer:


-- Exercise 2:
-- Calculate the average departure delay by airport again, but this time use only those flights that flew more than 2000 miles (you will find this info in the distance column)


-- Ordering results
-- Ascending order
SELECT
  COUNT(*),
  origin
FROM flight_delays
GROUP BY origin
ORDER BY count(*);

-- Quick note on aliases: when you call functions like sum() or avg(), SQL will try to automatically rename that column,
-- but you can rename it (to whatever you want) using aliases, like this:
SELECT
  COUNT(*) as total_flights,
  origin
FROM flight_delays
GROUP BY origin
ORDER BY total_flights;
-- Just remember that if you need to use that column in a GROUP or ORDER clause you have to use the alias, not the original name.

-- Descending order
SELECT
  COUNT(*) as total_flights,
  origin
FROM flight_delays
GROUP BY origin
ORDER BY total_flights DESC;

-- Distinct
-- Imagine you wanted a list of all the airports, without duplicates:
SELECT DISTINCT(origin)
FROM flight_delays;

-- Exercise:
-- List the top 5 planes (identified by the tailnum), by the number of landings, at PHX or SEA airport, on Sundays


-- ***************
-- Part 3
-- ***************

-- Joins
-- Setup the database first:
CREATE TABLE playlist (
  artist VARCHAR(255),
  song VARCHAR(255));
  
INSERT INTO playlist (artist,song) VALUES
  ('ABBA','Dancing Queen'),
  ('ABBA','Gimme!'),
  ('ABBA','The Winner Takes It All'),
  ('ABBA','Mamma Mia'),
  ('ABBA','Take a Chance On Me'),
  ('Tove Lo','Cool Girl'),
  ('Tove Lo','Stay High'),
  ('Tove Lo','Talking Body'),
  ('Tove Lo','Habits'),
  ('Tove Lo','True Disaster'),
  ('Avicii','Wake Me Up'),
  ('Avicii','Waiting For Love'),
  ('Avicii','The Nights'),
  ('Avicii','Hey Brother'),
  ('Avicii','Levels'),
  ('Zara Larsson','Lush Life');
  
SELECT
  artist,
  song
FROM
  playlist;
  
CREATE TABLE toplist (
  tophit VARCHAR(255),
  play INT);
  
INSERT INTO toplist (tophit,play) VALUES
  ('Dancing Queen',95145796),
  ('Gimme!',32785696),
  ('The Winner Takes It All',34458597),
  ('Mamma Mia',47901900),
  ('Take a Chance On Me',30654536),
  ('Cool Girl',227055115),
  ('Stay High',263901766),
  ('Talking Body',272334711),
  ('Habits',214685822),
  ('True Disaster',27028538),
  ('Wake Me Up',520259542),
  ('Waiting For Love',399906192),
  ('The Nights',278063930),
  ('Hey Brother',321270703),
  ('Levels',206004691),
  ('Despacito',519689490);
  
SELECT
  tophit,
  play
FROM
  toplist;
  
-- Our first join (usually called an INNER JOIN):
SELECT *
FROM toplist
JOIN playlist
ON tophit = song;

-- This syntax works for simple joins, but it should have been done like this:
SELECT
  toplist.tophit,
  toplist.play,
  playlist.artist,
  playlist.song
FROM toplist
JOIN playlist
ON toplist.tophit = playlist.song;

-- But writing the table name every single time is not very productive, right? Here's an alternative, that uses aliases for 
-- table names:
SELECT
  a.tophit,
  a.play,
  b.artist,
  b.song
FROM toplist a
JOIN playlist b
ON a.tophit = b.song;

-- And remove one of the song columns, it's duplicated:
SELECT
  a.tophit,
  a.play,
  b.artist
FROM toplist a
JOIN playlist b
ON a.tophit = b.song;

-- Noticed anything missing in the result?

-- LEFT JOIN - you want all the records from the left table, and all those from the right table, if they match.
SELECT
  a.tophit,
  a.play,
  b.artist
FROM toplist a
LEFT JOIN playlist b
ON a.tophit = b.song;

-- RIGHT JOIN (not supported by SQLite) - you want all the records from the right table, and all those from the left table, if they match.
SELECT
  a.tophit,
  a.play,
  b.artist
FROM toplist a
RIGHT JOIN playlist b
ON a.tophit = b.song;

-- Exercise: print the top 5 ABBA songs ordered by number of plays


-- ***************
-- Part 4
-- ***************

-- CASE statement
-- Let’s say we want to see how many need exactly 220 of water, above that and below that.
-- We could do 3 queries: 
SELECT COUNT(*)
FROM zoo
WHERE water_need = 220;
-- WHERE water_need > 220
-- WHERE water_need < 220

-- Or we can use the CASE statement:
SELECT COUNT(*),
  CASE WHEN water_need < 220 THEN 'below'
       WHEN water_need > 220 THEN 'above'
       ELSE 'exact'
  END as segment
FROM zoo
GROUP BY segment;

-- If it’s not clear to you at first sight, I recommend running the query without the GROUP BY statement, like this:
SELECT *,
  CASE WHEN water_need < 220 THEN 'below'
       WHEN water_need > 220 THEN 'above'
       ELSE 'exact'
  END as segment
FROM zoo;
-- Notice that the CASE statement is creating a new column at the end of the table, that you'll use to group the rows afterwards.

-- HAVING clause
-- The HAVING clause exists because you can't use WHERE with aggregate functions.
-- This won't work:
SELECT COUNT(*) as nmbr, animal
FROM zoo
GROUP BY animal
WHERE nmbr > 1;

-- This will:
SELECT COUNT(*) as nmbr, animal
FROM zoo
GROUP BY animal
HAVING nmbr > 1;

-- Why the WHERE doesn't work:
-- Keyword order of sql statements:
SELECT
FROM
WHERE
GROUP BY
ORDER BY
LIMIT

-- How SQL actually parses it:
FROM
WHERE
GROUP BY
SELECT
ORDER BY
LIMIT

-- ***************
-- Part 5
-- ***************

-- Subqueries
-- Imagine the following problem: Select the average departure delay by tail numbers (or, in other words, by plane), and return the tail numbers (and only the tail numbers) of the planes that have the top 10 average delay times.
-- You could solve it like this:
SELECT
  tailnum,
  AVG(depdelay) as avg_dd
FROM
  flight_delays
GROUP BY tailnum
ORDER BY avg_dd DESC
LIMIT 10;

-- Nice. Except that this is not the 100% correct answer for this question. The description was really specific 
-- that we only want to see the tailnums in our results – and not the average departure time value. 
-- The problem is that you have to have the AVG(depdelay) in your SELECT statement – since you are using it 
-- to find out the average departure delays of the planes.

-- The solution is to handle this query as a table – but in reality, put it as a subquery into another query.
SELECT
  tailnum
FROM
  (SELECT
     tailnum,
     AVG(depdelay) as avg_dd
   FROM
     flight_delays
   GROUP BY tailnum
   ORDER BY avg_dd DESC
   LIMIT 10) as my_original_query;
   
-- Exercise: get the top 10 destinations, where the planes with the top 10 average departure delays (see previous example) showed up the most
