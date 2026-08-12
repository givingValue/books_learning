# CHAPTER 15: Metadata

## information_schema

SELECT TABLE_NAME, TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sakila'
ORDER BY 1;

SELECT TABLE_NAME, TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sakila'
    AND TABLE_TYPE = 'BASE TABLE'
ORDER BY 1;

SELECT TABLE_NAME, IS_UPDATABLE
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'sakila'
ORDER BY 1;

SELECT COLUMN_NAME, DATA_TYPE,
       CHARACTER_MAXIMUM_LENGTH AS CHAR_MAX_LEN,
       NUMERIC_PRECISION AS NUM_PRCSN, NUMERIC_SCALE AS NUM_SCALE
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'sakila' and TABLE_NAME = 'film'
ORDER BY ORDINAL_POSITION;

SELECT INDEX_NAME, NON_UNIQUE, SEQ_IN_INDEX, COLUMN_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'rental'
ORDER BY 1, 3;

SELECT CONSTRAINT_NAME, TABLE_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila'
ORDER BY 3, 1;

SELECT *
FROM information_schema.SCHEMATA;

SELECT *
FROM information_schema.TABLES;

SELECT *
FROM information_schema.COLUMNS;

SELECT *
FROM information_schema.STATISTICS;

SELECT *
FROM information_schema.USER_PRIVILEGES;

SELECT *
FROM information_schema.SCHEMA_PRIVILEGES;

SELECT *
FROM information_schema.TABLE_PRIVILEGES;

SELECT *
FROM information_schema.COLUMN_PRIVILEGES;

SELECT *
FROM information_schema.CHARACTER_SETS;

SELECT *
FROM information_schema.COLLATIONS;

SELECT *
FROM information_schema.COLLATION_CHARACTER_SET_APPLICABILITY;

SELECT *
FROM information_schema.TABLE_CONSTRAINTS;

SELECT *
FROM information_schema.KEY_COLUMN_USAGE;

SELECT *
FROM information_schema.ROUTINES;

SELECT *
FROM information_schema.VIEWS;

SELECT *
FROM information_schema.TRIGGERS;

SELECT *
FROM information_schema.PLUGINS;

SELECT *
FROM information_schema.ENGINES;

SELECT *
FROM information_schema.PARTITIONS;

SELECT *
FROM information_schema.EVENTS;

SELECT *
FROM information_schema.PROCESSLIST;

SELECT *
FROM information_schema.REFERENTIAL_CONSTRAINTS;

SELECT *
FROM information_schema.PARAMETERS;

SELECT *
FROM information_schema.PROFILING;

## Working with Metadata

### Schema Generation Scripts

CREATE TABLE category (
    category_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

SELECT 'CREATE TABLE category (' AS create_table_statment
UNION ALL
SELECT cols.txt
FROM (
    SELECT CONCAT(' ', COLUMN_NAME, ' ', COLUMN_TYPE,
        CASE
            WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
        END,
        CASE
            WHEN EXTRA IS NOT NULL AND EXTRA LIKE 'DEFAULT_GENERATED%'
                THEN CONCAT(' DEFAULT ', COLUMN_DEFAULT, SUBSTR(EXTRA, 18))
            WHEN EXTRA IS NOT NULL
                THEN CONCAT(' ', EXTRA)
            ELSE ''
        END,
        ','
    ) AS txt
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'category'
    ORDER BY ORDINAL_POSITION
) AS cols
UNION ALL
SELECT ')';

SELECT 'CREATE TABLE category (' AS create_table_statment
UNION ALL
SELECT cols.txt
FROM (
    SELECT CONCAT(' ', COLUMN_NAME, ' ', COLUMN_TYPE,
        CASE
            WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL'
            ELSE ''
        END,
        CASE
            WHEN EXTRA IS NOT NULL AND EXTRA LIKE 'DEFAULT_GENERATED%'
                THEN CONCAT(' DEFAULT ', COLUMN_DEFAULT, SUBSTR(EXTRA, 18))
            WHEN EXTRA IS NOT NULL
                THEN CONCAT(' ', EXTRA)
            ELSE ''
        END,
        ','
    ) AS txt
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'category'
    ORDER BY ORDINAL_POSITION
) AS cols
UNION ALL
SELECT CONCAT(' CONSTRAINT PRIMARY KEY (')
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'category'
    AND CONSTRAINT_TYPE = 'PRIMARY KEY'
UNION ALL
SELECT cols.txt
FROM (
    SELECT CONCAT(
        CASE
            WHEN ORDINAL_POSITION > 1 THEN '    ,'
            ELSE '    '
        END,
        COLUMN_NAME
    ) AS txt
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'category'
        AND CONSTRAINT_NAME = 'PRIMARY'
    ORDER BY ORDINAL_POSITION
) AS cols
UNION ALL
SELECT '   )'
UNION ALL
SELECT ')';

CREATE TABLE category2 (
    category_id tinyint unsigned NOT NULL auto_increment,
    name varchar(25) NOT NULL ,
    last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    CONSTRAINT PRIMARY KEY (
        category_id
    )
);

DESC category2;

### Deployment Verification

SELECT tbl.TABLE_NAME,
       (
        SELECT COUNT(*)
        FROM information_schema.COLUMNS AS clm
        WHERE clm.TABLE_NAME = tbl.TABLE_NAME
       ) AS num_columns,
       (
        SELECT COUNT(*)
        FROM information_schema.STATISTICS AS sta
        WHERE sta.TABLE_NAME = tbl.TABLE_NAME
       ) AS num_indexes,
       (
        SELECT COUNT(*)
        FROM information_schema.TABLE_CONSTRAINTS AS tc
        WHERE tc.TABLE_SCHEMA = tbl.TABLE_SCHEMA
            AND tc.TABLE_NAME = tbl.TABLE_NAME
            AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
       ) AS num_primary_keys
FROM information_schema.TABLES AS tbl
WHERE tbl.TABLE_SCHEMA = 'sakila' AND tbl.TABLE_TYPE = 'BASE TABLE'
ORDER BY 1;

SELECT tbl.TABLE_NAME,
       (
        SELECT COUNT(*)
        FROM information_schema.COLUMNS AS clm
        WHERE clm.TABLE_NAME = tbl.TABLE_NAME
       ) AS num_columns,
       (
        SELECT COUNT(*)
        FROM information_schema.STATISTICS AS sta
        WHERE sta.TABLE_NAME = tbl.TABLE_NAME
       ) AS num_indexes,
       (
        SELECT COUNT(*)
        FROM information_schema.TABLE_CONSTRAINTS AS tc
        WHERE tc.TABLE_NAME = tbl.TABLE_NAME
            AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
       ) AS num_primary_keys,
       (
        SELECT COUNT(*)
        FROM information_schema.TABLE_CONSTRAINTS AS tc
        WHERE tc.TABLE_NAME = tbl.TABLE_NAME
            AND tc.CONSTRAINT_TYPE = 'FOREIGN KEY'
       ) AS num_primary_keys
FROM information_schema.TABLES AS tbl
WHERE tbl.TABLE_SCHEMA = 'sakila' AND tbl.TABLE_TYPE = 'BASE TABLE'
ORDER BY 1;

### Dynamic SQL Generation

SET @qry = 'SELECT customer_id, first_name, last_name FROM customer';

PREPARE dynsql1 FROM @qry;

EXECUTE dynsql1;

DEALLOCATE PREPARE dynsql1;

SET @qry = 'SELECT customer_id, first_name, last_name FROM customer WHERE customer_id = ?';

PREPARE dynsql2 FROM @qry;

SET @custid = 9;

EXECUTE dynsql2 USING @custid;

SET @custid = 145;

EXECUTE dynsql2 USING @custid;

DEALLOCATE PREPARE dynsql2;

SELECT CONCAT('SELECT ',
       CONCAT_WS(',', cols.col1, cols.col2, cols.col3, cols.col4,
        cols.col5, cols.col6, cols.col7, cols.col8, cols.col9),
       ' FROM customer WHERE customer_id = ?') INTO @qry
FROM
    (
        SELECT
            MAX(CASE WHEN ORDINAL_POSITION = 1 THEN COLUMN_NAME ELSE NULL END) AS col1,
            MAX(CASE WHEN ORDINAL_POSITION = 2 THEN COLUMN_NAME ELSE NULL END) AS col2,
            MAX(CASE WHEN ORDINAL_POSITION = 3 THEN COLUMN_NAME ELSE NULL END) AS col3,
            MAX(CASE WHEN ORDINAL_POSITION = 4 THEN COLUMN_NAME ELSE NULL END) AS col4,
            MAX(CASE WHEN ORDINAL_POSITION = 5 THEN COLUMN_NAME ELSE NULL END) AS col5,
            MAX(CASE WHEN ORDINAL_POSITION = 6 THEN COLUMN_NAME ELSE NULL END) AS col6,
            MAX(CASE WHEN ORDINAL_POSITION = 7 THEN COLUMN_NAME ELSE NULL END) AS col7,
            MAX(CASE WHEN ORDINAL_POSITION = 8 THEN COLUMN_NAME ELSE NULL END) AS col8,
            MAX(CASE WHEN ORDINAL_POSITION = 9 THEN COLUMN_NAME ELSE NULL END) AS col9
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'customer'
        GROUP BY TABLE_NAME
    ) AS cols;


SELECT
    MAX(CASE WHEN ORDINAL_POSITION = 1 THEN COLUMN_NAME ELSE NULL END) AS col1, # You have access to the individual columns inside the group in an aggregation function
    MAX(CASE WHEN ORDINAL_POSITION = 2 THEN COLUMN_NAME ELSE NULL END) AS col2,
    MAX(CASE WHEN ORDINAL_POSITION = 3 THEN COLUMN_NAME ELSE NULL END) AS col3,
    MAX(CASE WHEN ORDINAL_POSITION = 4 THEN COLUMN_NAME ELSE NULL END) AS col4,
    MAX(CASE WHEN ORDINAL_POSITION = 5 THEN COLUMN_NAME ELSE NULL END) AS col5,
    MAX(CASE WHEN ORDINAL_POSITION = 6 THEN COLUMN_NAME ELSE NULL END) AS col6,
    MAX(CASE WHEN ORDINAL_POSITION = 7 THEN COLUMN_NAME ELSE NULL END) AS col7,
    MAX(CASE WHEN ORDINAL_POSITION = 8 THEN COLUMN_NAME ELSE NULL END) AS col8,
    MAX(CASE WHEN ORDINAL_POSITION = 9 THEN COLUMN_NAME ELSE NULL END) AS col9
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'customer'
GROUP BY TABLE_NAME;

SELECT
    CASE WHEN ORDINAL_POSITION = 1 THEN COLUMN_NAME ELSE NULL END AS col1,
    CASE WHEN ORDINAL_POSITION = 2 THEN COLUMN_NAME ELSE NULL END AS col2,
    CASE WHEN ORDINAL_POSITION = 3 THEN COLUMN_NAME ELSE NULL END AS col3,
    CASE WHEN ORDINAL_POSITION = 4 THEN COLUMN_NAME ELSE NULL END AS col4,
    CASE WHEN ORDINAL_POSITION = 5 THEN COLUMN_NAME ELSE NULL END AS col5,
    CASE WHEN ORDINAL_POSITION = 6 THEN COLUMN_NAME ELSE NULL END AS col6,
    CASE WHEN ORDINAL_POSITION = 7 THEN COLUMN_NAME ELSE NULL END AS col7,
    CASE WHEN ORDINAL_POSITION = 8 THEN COLUMN_NAME ELSE NULL END AS col8,
    CASE WHEN ORDINAL_POSITION = 9 THEN COLUMN_NAME ELSE NULL END AS col9
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'customer';

SELECT @qry;

PREPARE dynsql3 FROM @qry;

SET @custid = 45;

EXECUTE dynsql3 USING @custid;

DEALLOCATE PREPARE dynsql3;

## Test your Knowledge

### Exercise 15-1

#### Personal

SELECT INDEX_NAME, TABLE_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila';

#### Book

SELECT DISTINCT TABLE_NAME, INDEX_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila';

### Exercise 15-2

#### Personal

WITH query_sections AS (
    SELECT CONCAT('ALTER TABLE ', TABLE_NAME, ' ADD INDEX ', INDEX_NAME, ' (') AS part1,
           (SELECT GROUP_CONCAT(COLUMN_NAME ORDER BY s2.SEQ_IN_INDEX SEPARATOR ',')
           FROM information_schema.STATISTICS AS s2
           WHERE s2.TABLE_SCHEMA = s.TABLE_SCHEMA
             AND s2.TABLE_NAME = s.TABLE_NAME
             AND s2.INDEX_NAME = s.INDEX_NAME
           GROUP BY INDEX_NAME) AS part2,
           ')' AS part3
    FROM information_schema.STATISTICS AS s
    WHERE TABLE_SCHEMA = 'sakila'
    GROUP BY TABLE_NAME, INDEX_NAME
)
SELECT CONCAT(part1, part2, part3) AS index_query
FROM query_sections;

SELECT GROUP_CONCAT(COLUMN_NAME SEPARATOR ',')
FROM information_schema.STATISTICS AS s2
WHERE s2.TABLE_SCHEMA = 'sakila'
AND s2.TABLE_NAME = 'rental'
AND s2.INDEX_NAME = 'rental_date'
GROUP BY INDEX_NAME;

#### Book

WITH idx_info AS (
    SELECT s1.TABLE_NAME, s1.INDEX_NAME,
           s1.COLUMN_NAME, s1.SEQ_IN_INDEX,
           (SELECT MAX(s2.SEQ_IN_INDEX)
            FROM information_schema.STATISTICS AS s2
            WHERE s2.TABLE_SCHEMA = s1.TABLE_SCHEMA
                AND s2.TABLE_NAME = s1.TABLE_NAME
                AND s2.INDEX_NAME = s1.INDEX_NAME) AS num_columns
    FROM information_schema.STATISTICS AS s1
    WHERE s1.TABLE_SCHEMA = 'sakila'
      AND s1.TABLE_NAME = 'customer'
)
SELECT CONCAT(
       CASE
           WHEN SEQ_IN_INDEX = 1 THEN
               CONCAT('ALTER TABLE ', TABLE_NAME, ' ADD INDEX ', INDEX_NAME, '(', COLUMN_NAME)
           ELSE CONCAT('    , ', COLUMN_NAME)
       END,
       CASE
           WHEN SEQ_IN_INDEX = num_columns THEN ');'
           ELSE ''
       END
       ) AS index_creation_statement
FROM idx_info
ORDER BY  INDEX_NAME, SEQ_IN_INDEX;

SELECT CONCAT('ALTER TABLE ', TABLE_NAME, ' ADD INDEX ',
              INDEX_NAME, ' (',
              GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX SEPARATOR ', '),
              ');') AS index_creation_statement
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'sakila'
    AND TABLE_NAME = 'customer'
GROUP BY TABLE_NAME, INDEX_NAME;