# CHAPTER 8: Grouping and Aggregates

## Grouping Concepts

SELECT customer_id
FROM rental;

SELECT customer_id
FROM rental
GROUP BY customer_id;

SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id;

SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

SELECT customer_id, COUNT(*)
FROM rental
WHERE COUNT(*) >= 40
GROUP BY customer_id;

SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 40;

## Aggregate Functions

SELECT MAX(amount) AS max_amt,
       MIN(amount) AS min_amt,
       AVG(amount) AS avg_amt,
       SUM(amount) AS tot_amt,
       COUNT(*) AS num_payments
FROM payment;

SELECT rental_id, SUM(amount), COUNT(*)
FROM payment
GROUP BY rental_id
ORDER BY 2 DESC;

### implicit Versus Explicit Groups

SELECT customer_id,
       MAX(amount) AS max_amt,
       MIN(amount) AS min_amt,
       AVG(amount) AS avg_amt,
       SUM(amount) AS tot_amt,
       COUNT(*) AS num_payments
FROM payment;

SELECT customer_id,
       MAX(amount) AS max_amt,
       MIN(amount) AS min_amt,
       AVG(amount) AS avg_amt,
       SUM(amount) AS tot_amt,
       COUNT(*) AS num_payments
FROM payment
GROUP BY customer_id;

### Counting Distinct Values

SELECT COUNT(customer_id) AS num_rows,
       COUNT(DISTINCT customer_id) AS num_customers
FROM payment;

### Using Expressions

SELECT MAX(DATEDIFF(return_date, rental_date))
FROM rental;

### How Nulls Are Handled

DROP TABLE IF EXISTS number_tbl;

CREATE TABLE number_tbl(
  val SMALLINT
);

INSERT INTO number_tbl VALUES (1);

INSERT INTO number_tbl VALUES (3);

INSERT INTO number_tbl VALUES (5);

SELECT COUNT(*) AS num_rows,
       COUNT(val) AS num_vals,
       SUM(val) AS total,
       MAX(val) AS max_val,
       AVG(val) AS avg_val
FROM number_tbl;

INSERT INTO number_tbl VALUES (NULL);

SELECT COUNT(*) AS num_rows,
       COUNT(val) AS num_vals, #Important
       SUM(val) AS total,
       MAX(val) AS max_val,
       AVG(val) AS avg_val
FROM number_tbl;

## Generating Groups

### Single-Column Grouping

SELECT actor_id, COUNT(*)
FROM film_actor
GROUP BY actor_id;

### Multicolumn Grouping

SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor AS fa
    INNER JOIN film AS f
    ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating
ORDER BY 1, 2;

### Grouping via Expressions

SELECT EXTRACT(YEAR FROM rental_date) AS year,
       COUNT(*) AS how_many
FROM rental
GROUP BY EXTRACT(YEAR FROM rental_date);

### Generating Rollups

SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor AS fa
    INNER JOIN film AS f
    ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating WITH ROLLUP
ORDER BY 1, 2;

SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor AS fa
    INNER JOIN film AS f
    ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating WITH CUBE
ORDER BY 1, 2;

## Group Filter Conditions

SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor AS fa
    INNER JOIN film AS f
    ON fa.film_id = f.film_id
WHERE f.rating IN ('G','PG')
GROUP BY fa.actor_id, f.rating
HAVING COUNT(*) > 9;

SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor AS fa
    INNER JOIN film AS f
    ON fa.film_id = f.film_id
WHERE f.rating IN ('G','PG') AND COUNT(*) > 9
GROUP BY fa.actor_id, f.rating;

WITH film_actor_data AS (
    SELECT fa.actor_id, f.rating
    FROM film_actor AS fa
        INNER JOIN film AS f
        ON fa.film_id = f.film_id
    WHERE rating IN ('G','PG')
)
SELECT DISTINCT actor_id, rating,
    (SELECT COUNT(*)
     FROM film_actor_data AS fda2
     WHERE fda2.actor_id = fad1.actor_id
        AND fda2.rating = fad1.rating) AS count_f
FROM film_actor_data AS fad1
WHERE (SELECT COUNT(*)
       FROM film_actor_data AS fda2
       WHERE fda2.actor_id = fad1.actor_id
         AND fda2.rating = fad1.rating) > 9;

## Test Your Knowledge

### Exercise 8-1

#### Personal

SELECT COUNT(*) AS num_rows
FROM payment;

#### Book

SELECT COUNT(*)
FROM payment;

### Exercise 8-2

#### Book

SELECT customer_id, COUNT(*), SUM(amount)
FROM payment
GROUP BY customer_id ;

### Exercise 8-3

#### Personal

SELECT customer_id,
       SUM(amount) AS total_amount,
       COUNT(*) AS num_payments
FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40;

#### Book

SELECT customer_id, COUNT(*), SUM(amount)
FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40;