# CHAPTER 4: Filtering

## Condition Evaluation

SELECT *
FROM customer
WHERE first_name = 'STEVEN' AND create_date > '2006-01-01';

SELECT *
FROM customer
WHERE first_name = 'STEVEN' OR create_date > '2006-01-01';

### Using Parentheses

SELECT *
FROM customer
WHERE (first_name = 'STEVEN' OR last_name = 'YOUNG')
    AND create_date > '2006-01-01';

### Using the not Operator

SELECT *
FROM customer
WHERE NOT (first_name = 'STEVEN' OR last_name = 'YOUNG')
    AND create_date > '2006-01-01';

SELECT *
FROM customer
WHERE first_name <> 'STEVEN' AND last_name <> 'YOUNG'
    AND create_date > '2006-01-01';

## Condition Types

### Equality Conditions

SELECT *
FROM film
WHERE title = 'RIVER OUTLAW';

SELECT *
FROM payment
WHERE amount = 375.25;

SELECT *
FROM film
WHERE film_id = (SELECT film_id film WHERE title = 'RIVER OUTLAW');

SELECT c.email
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

#### Inequality Conditions

SELECT c.email
FROM customer AS c
    INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE DATE(r.rental_date) <> '2005-06-14';

#### Data modification using equality conditions

DELETE FROM rental
WHERE YEAR(rental_date) = 2004;

DELETE FROM rental
WHERE YEAR(rental_date) <> 2004 AND YEAR(rental_date) <> 2006;

### Range Conditions

SELECT customer_id, rental_date
FROM rental
WHERE rental_date < '2005-05-25';

SELECT customer_id, rental_date
FROM rental
WHERE rental_date <= '2005-06-16'
  AND rental_date >= '2005-06-14';

#### The between operator

SELECT customer_id, rental_date
FROM rental
WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

SELECT customer_id, rental_date
FROM rental
WHERE rental_date BETWEEN '2005-06-16' AND '2005-06-14';

SELECT customer_id, rental_date
FROM rental
WHERE rental_date >= '2005-06-16'
  AND rental_date <= '2005-06-14';

SELECT customer_id, payment_date, amount
FROM payment
WHERE amount BETWEEN 10.0 AND 11.99;

#### String ranges

SELECT last_name, first_name
FROM customer
WHERE last_name  BETWEEN 'FA' AND 'FR';

SELECT last_name, first_name
FROM customer
WHERE last_name  BETWEEN 'FA' AND 'FRB';

### Membership Conditions

SELECT title, rating
FROM film
WHERE rating = 'G' OR rating = 'PG';

SELECT title, rating
FROM film
WHERE rating IN ('G', 'PG');

#### Using subqueries

SELECT title, rating
FROM film
WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');

#### Using not in

SELECT title, rating
FROM film
WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

### Matching Conditions

SELECT last_name, first_name
FROM customer
WHERE LEFT(last_name, 1) = 'Q';

#### Using wildcards

SELECT last_name, first_name
FROM customer
WHERE last_name LIKE '_A_T%S';

SELECT last_name, first_name
FROM customer
WHERE last_name LIKE 'Q%' OR last_name like 'Y%';

#### Using regular expressions

SELECT last_name, first_name
FROM customer
WHERE last_name REGEXP '^[QY]';

## Null: That Four-Letter Word

SELECT rental_id, customer_id
FROM rental
WHERE return_date IS NULL;

SELECT rental_id, customer_id
FROM rental
WHERE return_date = NULL;

SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NOT NULL;

SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NULL
   OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

## Test Your Knowledge

### Exercise 4-1

#### Personal

SELECT payment_id, customer_id, amount, DATE(payment_date) AS payment_date
FROM payment
WHERE payment_id BETWEEN 101 AND 120
  AND (customer_id <> 5)
  AND (amount > 8 OR DATE(payment_date) = '2005-08-23');

### Exercise 4-2

#### Personal

SELECT payment_id, customer_id, amount, DATE(payment_date) AS payment_date
FROM payment
WHERE payment_id BETWEEN 101 AND 120
  AND (customer_id = 5)
  AND NOT (amount > 6 OR DATE(payment_date) = '2005-06-19');

### Exercise 4-3

#### Personal

SELECT *
FROM payment
WHERE amount IN(1.98,7.98,9.98);

#### Book

SELECT amount
FROM payment
WHERE amount IN(1.98,7.98,9.98);

### Exercise 4-4

#### Personal

SELECT *
FROM customer
WHERE last_name LIKE '_A%W%';

#### Book

SELECT first_name, last_name
FROM customer
WHERE last_name LIKE '_A%W%';