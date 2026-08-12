# CHAPTER 6: Working with Sets

## Set Theory in Practice

SELECT 1 AS num, 'abc' AS str
UNION
SELECT 9 AS num, 'xyz' AS str;

## Set Operators

### The union Operator

SELECT COUNT(*)
FROM customer;

SELECT COUNT(*)
FROM (
    SELECT 'CUST' AS typ, c.first_name, c.last_name
    FROM customer AS c
    UNION ALL
    SELECT 'CUST' AS typ, c.first_name, c.last_name
    FROM customer AS c
) AS union_all;

SELECT 'CUST' AS typ, c.first_name, c.last_name
FROM customer AS c
UNION ALL
SELECT 'ACTR' AS typ, a.first_name, a.last_name
FROM actor AS a;

SELECT 'ACTR' AS typ, a.first_name, a.last_name
FROM actor AS a
UNION ALL
SELECT 'ACTR' AS typ, a.first_name, a.last_name
FROM actor AS a;

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
UNION ALL
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
UNION
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

### The intersect Operator

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'D%' AND c.last_name LIKE 'T%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'D%' AND a.last_name LIKE 'T%';

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

### The except Operator

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
EXCEPT
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

## Set Operation Rules

### Sorting Compound Query Results

SELECT a.first_name AS fname, a.last_name AS lname
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
ORDER BY fname, lname;

SELECT a.first_name AS fname, a.last_name AS lname
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
ORDER BY first_name, last_name;

### Set Operation Precedence

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
UNION
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION
(SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%');

## Test Your Knowledge

### Exercise 6-1

#### Personal

# A = {L, M, N, O, P}
# B = {P, Q, R, S, T}

# A union B = {L, M, N, O, P, Q, R, S, T}
# A union all B = {L, M, N, O, P, P, Q, R, S, T}
# A intersect B = {P}
# A except B = {L, M, N, O}

### Exercise 6-2

#### Personal

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.last_name LIKE 'L%'
UNION
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.last_name LIKE 'L%';

#### Book

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE 'L%'
UNION
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'L%';

### Exercise 6-3

#### Personal

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.last_name LIKE 'L%'
UNION
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.last_name LIKE 'L%'
ORDER BY last_name;

#### Book

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE 'L%'
UNION
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'L%'
ORDER BY last_name;