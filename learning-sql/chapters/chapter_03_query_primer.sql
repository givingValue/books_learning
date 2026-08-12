# CHAPTER 3: Query Primer

## Query Mechanics

SELECT first_name, last_name
FROM customer
WHERE last_name = 'ZIEGLER';

SELECT *
FROM category;

## The select Clause

SELECT *
FROM language;

SELECT language_id, name, last_update
from language;

SELECT name
FROM language;

SELECT language_id,
       'COMMON' AS language_usage,
       language_id * 3.14 AS lang_pi_value,
       UPPER(name) AS language_name
FROM language;

SELECT VERSION(), USER(), DATABASE();

### Column Aliases

SELECT language_id,
       'COMMON' language_usage,
       language_id * 3.14 lang_pi_value,
       UPPER(name) language_name
FROM language;

SELECT language_id,
       'COMMON' AS language_usage,
       language_id * 3.14 AS lang_pi_value,
       UPPER(name) AS language_name
FROM language;

### Removing Duplicates

SELECT actor_id
FROM film_actor
ORDER BY actor_id;

SELECT DISTINCT actor_id
FROM film_actor
ORDER BY actor_id;

## The from Clause

### Tables

#### Derived (subquery-generated) tables

SELECT CONCAT(cust.first_name, ', ', cust.last_name) AS full_name
FROM (
    SELECT first_name, last_name, email
    FROM customer
    WHERE first_name = 'JESSIE'
) AS cust;

#### Temporary tables

CREATE TEMPORARY TABLE actors_j(
  actor_id smallint(5),
  first_name varchar(45),
  last_name varchar(45)
);

SELECT * FROM actors_j;

INSERT INTO actors_j
    SELECT actor_id, first_name, last_name
    FROM actor
    WHERE last_name LIKE 'J%';

#### Views

CREATE VIEW cust_vw AS
    SELECT customer_id, first_name, last_name, active
    FROM customer;

SELECT first_name, last_name
FROM cust_vw
WHERE active = 0;

### Table Links

SELECT customer.first_name, customer.last_name,
       TIME(rental.rental_date) AS rental_time
FROM customer
    INNER JOIN rental
    ON customer.customer_id = rental.customer_id
WHERE DATE(rental.rental_date) = '2005-06-14';

### Defining Table Aliases

SELECT c.first_name, c.last_name,
       TIME(r.rental_date) AS rental_time
FROM customer c
    INNER JOIN rental r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

SELECT c.first_name, c.last_name,
       TIME(r.rental_date) AS rental_time
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

## The where Clause

SELECT title
FROM film
WHERE rating = 'G' AND rental_duration >= 7;

SELECT title
FROM film
WHERE rating = 'G' OR rental_duration >= 7;

SELECT title, rating, rental_duration
FROM film
WHERE (rating = 'G' AND rental_duration >= 7)
    OR (rating = 'PG-13' AND rental_duration < 4);

## The group by and having Clauses

SELECT c.first_name, c.last_name, COUNT(*)
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY  c.first_name, c.last_name
HAVING COUNT(*) >= 40;

SELECT c.first_name, c.last_name, COUNT(*) AS rental_number
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY  c.customer_id
HAVING COUNT(*) >= 40;

## The order by Clause

SELECT c.first_name, c.last_name,
    TIME(r.rental_date) AS rental_time
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

SELECT c.first_name, c.last_name,
    TIME(r.rental_date) AS rental_time
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY c.last_name;

SELECT c.first_name, c.last_name,
    TIME(r.rental_date) AS rental_time
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY c.last_name, c.first_name;

### Ascending Versus Descending Sort Order

SELECT c.first_name, c.last_name,
    TIME(r.rental_date) AS rental_time
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY TIME(r.rental_date) DESC ;

### Sorting via Numeric Placeholders

SELECT c.first_name, c.last_name,
       TIME(r.rental_date) AS rental_time
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY 3 DESC;

## Test Your Knowledge

### Exercise 3-1

#### Personal

SELECT  actor_id, first_name, last_name
FROM actor
ORDER BY last_name, first_name;

#### Book

SELECT  actor_id, first_name, last_name
FROM actor
ORDER BY 3, 2;

### Exercise 3-2

#### Personal

SELECT  actor_id, first_name, last_name
FROM actor
WHERE (last_name = 'WILLIAMS')
    OR (last_name = 'DAVIS');

#### Book

SELECT  actor_id, first_name, last_name
FROM actor
WHERE last_name = 'WILLIAMS' OR last_name = 'DAVIS';

### Exercise 3-3

#### Personal

SELECT DISTINCT customer_id
FROM rental
WHERE DATE(rental.rental_date) = '2005-07-05';

#### Book

SELECT DISTINCT customer_id
FROM rental
WHERE DATE(rental.rental_date) = '2005-07-05';

### Exercise 3-4

#### Personal

SELECT c.email, r.return_date
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY r.return_date DESC;

#### Book

SELECT c.email, r.return_date
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14'
ORDER BY 2 DESC;