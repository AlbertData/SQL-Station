
#SQL Basics

#Create Table
CREATE TABLE table_name (column_1 datatype, column_2 datatype, column_3 datatype);

#Alter Table
ALTER TABLE table_name ADD column datatype;

#Insert
INSERT INTO table_name (column_1, column_2, column_3) VALUES (value_1, 'value_2', value_3);

#SELECT
SELECT column_name FROM table_name;

#SELECT DISTINCT
SELECT DISTINCT column_name FROM table_name;

#AS
SELECT column_name AS 'Alias'
FROM table_name;

#AND
SELECT column_name(s)
FROM table_name
WHERE column_1 = value_1
AND column_2 = value_2;

#AVERAGE
SELECT AVG(column_name)
FROM table_name;


#BETWEEN
SELECT column_name(s)
FROM table_name
WHERE column_name BETWEEN value_1 AND value_2;

#COUNT
SELECT COUNT(column_name)
FROM table_name;

#DELETE
DELETE FROM table_name WHERE some_column = some_value;

#GROUP BY
SELECT COUNT(*)
FROM table_name
GROUP BY column_name;

#ORDER BY
SELECT column_name
FROM table_name
ORDER BY column_name ASC|DESC;

#INNER JOIN
SELECT column_name(s) FROM table_1
JOIN table_2
ON table_1.column_name = table_2.column_name;

#OUTER JOIN
SELECT column_name(s) FROM table_1
LEFT JOIN table_2
ON table_1.column_name = table_2.column_name;

#LIKE
SELECT column_name(s)
FROM table_name
WHERE column_name LIKE pattern;

#LIMIT
SELECT column_name(s)
FROM table_name
LIMIT number;

#MAX
SELECT MAX(column_name)
FROM table_name;

#MIN
SELECT MIN(column_name)
FROM table_name;

#OR
SELECT column_name
FROM table_name
WHERE column_name = value_1
OR column_name = value_2;

#ROUND
SELECT ROUND(column_name, integer)
FROM table_name;

#SUM
SELECT SUM(column_name)
FROM table_name;

#UPDATE
UPDATE table_name
SET some_column = some_value
WHERE some_column = some_value;

#WHERE
SELECT column_name(s)
FROM table_name
WHERE column_name operator value;


#SQL Basics - By Albert Klein
