# CHAPTER 7: Data Generation, Manipulation, and Conversion

## Working with String Data

CREATE TABLE string_tbl(
    char_fld CHAR(30),
    vchar_fld VARCHAR(30),
    text_fld TEXT
);

### String Generation

INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This is char data', 'This is varchar data', 'This is text data');

SELECT *
FROM string_tbl;

UPDATE string_tbl
SET vchar_fld = 'This is a piece of extremely long varchar data'
WHERE char_fld = 'This is char data';

SELECT @@session.sql_mode;

SET sql_mode = 'ansi';

SELECT @@session.sql_mode;

UPDATE string_tbl
SET vchar_fld = 'This is a piece of extremely long varchar data'
WHERE char_fld = 'This is char data';

SHOW WARNINGS;

SELECT vchar_fld
FROM string_tbl;

#### Including single quotes

#UPDATE string_tbl
#SET text_fld = 'This string doesn't work'
#WHERE char_fld = 'This is char data';

UPDATE string_tbl
SET text_fld = 'This string didn''t work, but it does now'
WHERE char_fld = 'This is char data';

UPDATE string_tbl
SET text_fld = 'This string didn\'t work, but it does now'
WHERE char_fld = 'This is char data';

SELECT text_fld
FROM string_tbl;

SELECT QUOTE(text_fld)
FROM string_tbl;

#### Including special characters

SELECT 'abcdefg', CHAR(97,98,99,100,101,102,103);

SELECT @@session.sql_mode;

SHOW VARIABLES LIKE 'sql_mode';

SELECT CHAR(128,129,130,131,132,133,134,135,136,137);

SELECT CHAR(138,139,140,141,142,143,144,145,146,147);

SELECT CHAR(148,149,150,151,152,153,154,155,156,157);

SELECT CHAR(158,159,160,161,162,163,164,165);

SELECT CONCAT('danke sch', CHAR(148), 'n');

SELECT ASCII('abd');

SELECT ASCII('ö');

### String Manipulation

DELETE FROM string_tbl
WHERE char_fld = 'This is char data';

INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This string is 28 characters', 'This string is 28 characters', 'This string is 28 characters');

SELECT *
FROM string_tbl;

SELECT @@VERSION;

SELECT CCSA.character_set_name
FROM information_schema.`TABLES` T, information_schema.`COLLATION_CHARACTER_SET_APPLICABILITY` CCSA
WHERE CCSA.collation_name = T.table_collation
    AND T.table_schema = 'sakila'
    AND T.table_name = 'string_tbl';

SELECT
    LENGTH(char_fld) AS char_lenght,
    LENGTH(vchar_fld) AS varchar_lenght,
    LENGTH(text_fld) AS text_lenght
FROM string_tbl;

SELECT LENGTH('');

SELECT POSITION('characters' IN vchar_fld)
FROM string_tbl;

SELECT POSITION('is' IN vchar_fld)
FROM string_tbl;

SELECT LOCATE('is', vchar_fld, 5)
FROM string_tbl;

DELETE FROM string_tbl
WHERE char_fld = 'This string is 28 characters';

INSERT INTO string_tbl (vchar_fld)
VALUES
    ('abcd'),
    ('xyz'),
    ('QRSTUV'),
    ('qrstuv'),
    ('12345');

SELECT vchar_fld
FROM string_tbl
ORDER BY vchar_fld;

SELECT
    STRCMP('12345', '12345') AS 12345_12345,
    STRCMP('abcd', 'xyz') AS abcd_xyz,
    STRCMP('abcd', 'QRSTUV') AS abcd_QRSTUV,
    STRCMP('qrstuv', 'QRSTUV') AS qrstuv_QRSTUV,
    STRCMP('12345', 'xyz') AS 12345_xyz,
    STRCMP('xyz', 'qrstuv') AS xyz_qrstuv;

SELECT name, name LIKE '%y' AS ends_in_y
FROM category;

SELECT name, name REGEXP 'y$' AS ends_in_y
FROM category;

DELETE FROM string_tbl
WHERE char_fld IS NULL;

DELETE FROM string_tbl
WHERE char_fld = 'This string is 28 characters';

INSERT INTO string_tbl (text_fld)
VALUES ('This string was 29 characters');

UPDATE string_tbl
SET text_fld = CONCAT(text_fld, ', but now it is longer')
WHERE char_fld IS NULL;

SELECT *
FROM string_tbl;

SELECT CONCAT(first_name, ' ', last_name, ' has been a customer since ', DATE(create_date)) AS cust_narrative
FROM customer;

SELECT first_name || ' ' || last_name || ' has been a customer since ' || DATE(create_date) AS cust_narrative
FROM customer;

SELECT INSERT('goodbye world', 9, 0, 'cruel ') AS string;

SELECT INSERT('goodbye world', 1, 7, 'hello') AS string;

SELECT REPLACE('goodbye world', 'goodbye', 'hello');

SELECT SUBSTRING('goodbye cruel world', 9, 5);

## Working with Numeric Data

SELECT (37 * 59) / (78 - (8 * 6));

### Performing Arithmetic Functions

SELECT MOD(10, 4);

SELECT MOD(22.75, 5);

SELECT POW(2, 8);

SELECT
    POW(2, 10) AS kilobyte,
    POW(2, 20) AS megabyte,
    POW(2, 30) AS gigabyte,
    POW(2, 40) AS terabyte;

### Controlling Number Precision

SELECT CEIL(72.445), FLOOR(72.445);

SELECT CEIL(72.000000001), FLOOR(72.999999999);

SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.50001);

SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3);

SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2), TRUNCATE(72.0909, 3);

SELECT ROUND(17, -1), TRUNCATE(17, -1);

### Handling Signed Data

SELECT account_id, SIGN(balance), ABS(balance)
FROM account;

## Working with Temporal Data

### Dealing with Time Zones

SELECT @@global.time_zone, @@session.time_zone;

SET TIME_ZONE = 'Europe/Zurich';

SELECT @@global.time_zone, @@session.time_zone;

SELECT UTC_TIMESTAMP();

SELECT CURRENT_TIMESTAMP();

SET TIME_ZONE = 'SYSTEM';

SELECT CURRENT_TIMESTAMP;

### Generating Temporal Data

UPDATE rental
SET return_date = '2019-09-17 15:30:00'
WHERE rental_id = 99999;

#### String-to-date conversions

SELECT CAST('2019-09-17 15:30:00' AS DATETIME);

SELECT CAST('2019-09-17' AS DATE) data_field, CAST('108:17:57' AS TIME) time_field;

#### Functions for generating dates

UPDATE rental
SET return_date = STR_TO_DATE('September 17, 2019', '%M %d, %Y')
WHERE rental_id = 99999;

SELECT STR_TO_DATE('September 17, 2019', '%M %d, %Y');

SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP();

### Manipulating Temporal Data

#### Temporal functions that return dates

SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);

UPDATE rental
SET return_date = DATE_ADD(return_date, INTERVAL '3:27:11' HOUR_SECOND)
WHERE rental_id = 99999;

SELECT DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL '3:27:11' HOUR_SECOND);

UPDATE employee
SET birth_date = DATE_ADD(return_date, INTERVAL '9-11' YEAR_MONTH)
WHERE emp_id = 4789;

SELECT DATE_ADD(CURRENT_DATE(), INTERVAL '9-11' YEAR_MONTH );

SELECT LAST_DAY('2019-09-17');

#### Temporal functions that return strings

SELECT DAYNAME('2019-09-18');

SELECT EXTRACT(YEAR FROM '2019-09-18 22:19:05');

#### Temporal functions that return numbers

SELECT DATEDIFF('2019-09-03', '2019-06-21');

SELECT DATEDIFF('2019-09-03 23:59:59', '2019-06-21 00:00:01');

SELECT DATEDIFF('2019-06-21', '2019-09-03');

## Conversion Functions

SELECT CAST('1456328' AS SIGNED INTEGER);

SELECT CAST('999ABC111' AS UNSIGNED INTEGER);

SHOW WARNINGS;

## Test Your Knowledge

### Exercise 7-1

#### Personal

SELECT SUBSTRING('Please find the substring in this string', 17, 9);

#### Book

SELECT SUBSTRING('Please find the substring in this string', 17, 9);

### Exercise 7-2

#### Personal

SELECT ABS(-25.76823), SIGN(-25.76823), ROUND(-25.76823, 2);

#### Book

SELECT ABS(-25.76823), SIGN(-25.76823), ROUND(-25.76823, 2);

### Exercise 7-1

#### Personal

SELECT EXTRACT(MONTH FROM CURRENT_DATE());

#### Book

SELECT EXTRACT(MONTH FROM CURRENT_DATE());