# CHAPTER 10: Joins Revisited

## Outer Joins

SELECT f.film_id, f.title, COUNT(*) AS num_copies
FROM film AS f
    INNER JOIN inventory AS i
    ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

SELECT f.film_id, f.title, COUNT(i.inventory_id) AS num_copies
FROM film AS f
    LEFT OUTER JOIN inventory AS i
    ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

SELECT f.film_id, f.title, i.inventory_id
FROM film AS f
    INNER JOIN inventory AS i
    ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 AND 15;

SELECT f.film_id, f.title, i.inventory_id
FROM film AS f
    LEFT OUTER JOIN inventory AS i
    ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 AND 15;

### Left Versus Right Outer Joins

SELECT f.film_id, f.title, i.inventory_id
FROM inventory AS i
    RIGHT OUTER JOIN film AS f
    ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 AND 15;

### Three-Way Outer Joins

SELECT f.film_id, f.title, i.inventory_id, r.rental_date
FROM film AS f
    LEFT OUTER JOIN inventory AS i
    ON f.film_id = i.film_id
    LEFT OUTER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE f.film_id BETWEEN 13 AND 15;

## Cross Joins

SELECT c.name AS category_name, l.name AS language_name
FROM category AS c
    CROSS JOIN language AS l;

SELECT COUNT(*)
FROM language;

SELECT COUNT(*)
FROM category;

SELECT 'Small Fry' AS name, 0 AS low_init, 74.99 AS high_limit
UNION
SELECT 'Average Joes' AS name, 75 AS low_init, 149.99 AS high_limit
UNION
SELECT 'Heavy Hitters' AS name, 150 AS low_init, 999999999.99 AS high_limit;

SELECT ones.num + tens.num + hundreds.num
FROM
    (SELECT 0 AS num UNION
    SELECT 1 AS num UNION
    SELECT 2 AS num UNION
    SELECT 3 AS num UNION
    SELECT 4 AS num UNION
    SELECT 5 AS num UNION
    SELECT 6 AS num UNION
    SELECT 7 AS num UNION
    SELECT 8 AS num UNION
    SELECT 9 AS num) AS ones
    CROSS JOIN
        (SELECT 0 AS num UNION
        SELECT 10 AS num UNION
        SELECT 20 AS num UNION
        SELECT 30 AS num UNION
        SELECT 40 AS num UNION
        SELECT 50 AS num UNION
        SELECT 60 AS num UNION
        SELECT 70 AS num UNION
        SELECT 80 AS num UNION
        SELECT 90 AS num) AS tens
    CROSS JOIN
        (SELECT 0 AS num UNION
        SELECT 100 AS num UNION
        SELECT 200 AS num UNION
        SELECT 300 AS num) AS hundreds
ORDER BY 1;

SELECT DATE_ADD('2020-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) AS dt
FROM
    (SELECT 0 AS num UNION
    SELECT 1 AS num UNION
    SELECT 2 AS num UNION
    SELECT 3 AS num UNION
    SELECT 4 AS num UNION
    SELECT 5 AS num UNION
    SELECT 6 AS num UNION
    SELECT 7 AS num UNION
    SELECT 8 AS num UNION
    SELECT 9 AS num) AS ones
    CROSS JOIN
        (SELECT 0 AS num UNION
        SELECT 10 AS num UNION
        SELECT 20 AS num UNION
        SELECT 30 AS num UNION
        SELECT 40 AS num UNION
        SELECT 50 AS num UNION
        SELECT 60 AS num UNION
        SELECT 70 AS num UNION
        SELECT 80 AS num UNION
        SELECT 90 AS num) AS tens
    CROSS JOIN
        (SELECT 0 AS num UNION
        SELECT 100 AS num UNION
        SELECT 200 AS num UNION
        SELECT 300 AS num) AS hundreds
WHERE DATE_ADD('2020-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2021-01-01'
ORDER BY 1;

SELECT days.dt, COUNT(r.rental_id) AS num_rentals
FROM rental AS r
    RIGHT OUTER JOIN (
        SELECT DATE_ADD('2005-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) AS dt
        FROM
            (SELECT 0 AS num UNION
            SELECT 1 AS num UNION
            SELECT 2 AS num UNION
            SELECT 3 AS num UNION
            SELECT 4 AS num UNION
            SELECT 5 AS num UNION
            SELECT 6 AS num UNION
            SELECT 7 AS num UNION
            SELECT 8 AS num UNION
            SELECT 9 AS num) AS ones
            CROSS JOIN
                (SELECT 0 AS num UNION
                SELECT 10 AS num UNION
                SELECT 20 AS num UNION
                SELECT 30 AS num UNION
                SELECT 40 AS num UNION
                SELECT 50 AS num UNION
                SELECT 60 AS num UNION
                SELECT 70 AS num UNION
                SELECT 80 AS num UNION
                SELECT 90 AS num) AS tens
            CROSS JOIN
                (SELECT 0 AS num UNION
                SELECT 100 AS num UNION
                SELECT 200 AS num UNION
                SELECT 300 AS num) AS hundreds
        WHERE DATE_ADD('2005-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2006-01-01'
    ) AS days
    ON days.dt = DATE(r.rental_date)
GROUP BY days.dt
ORDER BY 1;

## Natural Joins

SELECT c.first_name, c.last_name, DATE(r.rental_date)
FROM customer AS c
    NATURAL JOIN rental AS r;

SELECT cust.first_name, cust.last_name, DATE(r.rental_date)
FROM
    (SELECT customer_id, first_name, last_name
    FROM customer) AS cust
    NATURAL JOIN rental AS r;

## Test Your Knowledge

### Exercise 10-1

#### Personal

SELECT c.first_name, pymnt.tot_payments
FROM customer AS c
    LEFT OUTER JOIN (
        SELECT p.customer_id, SUM(p.amount) AS tot_payments
        FROM payment AS p
        GROUP BY p.customer_id
    ) AS pymnt
    ON c.customer_id = pymnt.customer_id;

SELECT c.first_name, SUM(p.amount) AS tot_payments
FROM customer AS c
    LEFT OUTER JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name;

### Exercise 10-2

#### Personal

SELECT c.first_name, SUM(p.amount) AS tot_payments
FROM payment AS p
    RIGHT OUTER JOIN customer AS c
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name;

### Exercise 10-3

#### Personal

WITH ones AS (
    SELECT 1 AS num UNION
    SELECT 2 AS num UNION
    SELECT 3 AS num UNION
    SELECT 4 AS num UNION
    SELECT 5 AS num UNION
    SELECT 6 AS num UNION
    SELECT 7 AS num UNION
    SELECT 8 AS num UNION
    SELECT 9 AS num UNION
    SELECT 10 AS num
),
tens AS (
    SELECT 0 AS num UNION
    SELECT 10 AS num UNION
    SELECT 20 AS num UNION
    SELECT 30 AS num UNION
    SELECT 40 AS num UNION
    SELECT 50 AS num UNION
    SELECT 60 AS num UNION
    SELECT 70 AS num UNION
    SELECT 80 AS num UNION
    SELECT 90 AS num
)
SELECT (o.num + t.num) AS num
FROM ones AS o
    CROSS JOIN tens AS t
ORDER BY 1;

#### Book

SELECT ones.x + tens.x + 1
FROM
    (SELECT 0 AS x UNION
    SELECT 1 AS x UNION
    SELECT 2 AS x UNION
    SELECT 3 AS x UNION
    SELECT 4 AS x UNION
    SELECT 5 AS x UNION
    SELECT 6 AS x UNION
    SELECT 7 AS x UNION
    SELECT 8 AS x UNION
    SELECT 9 AS x) AS ones
    CROSS JOIN
        (SELECT 0 AS x UNION
        SELECT 10 AS x UNION
        SELECT 20 AS x UNION
        SELECT 30 AS x UNION
        SELECT 40 AS x UNION
        SELECT 50 AS x UNION
        SELECT 60 AS x UNION
        SELECT 70 AS x UNION
        SELECT 80 AS x UNION
        SELECT 90 AS x) AS tens
ORDER BY 1;