# CHAPTER 14: Views

## What Are Views?

CREATE VIEW customer_vw (customer_id, first_name, last_name, email) AS
SELECT customer_id, first_name, last_name,
       CONCAT(SUBSTR(email,1,2), '*****', SUBSTR(email, -4)) AS email
FROM customer;

SELECT first_name, last_name, email
FROM customer_vw;

DESCRIBE customer_vw;

SELECT first_name, COUNT(*), MIN(last_name), MAX(last_name)
FROM customer_vw
WHERE first_name LIKE 'J%'
GROUP BY first_name
HAVING COUNT(*) > 1
ORDER BY 1;

SELECT cv.first_name, cv.last_name, p.amount
FROM customer_vw AS cv
    INNER JOIN payment AS p
    on cv.customer_id = p.customer_id
WHERE p.amount >= 11;

## Why Use Views?

### Data Security

DROP VIEW customer_vw;

CREATE VIEW customer_vw (
    customer_id,
    first_name,
    last_name,
    email
) AS
SELECT customer_id, first_name, last_name,
       CONCAT(SUBSTR(email,1,2), '*****', SUBSTR(email, -4)) AS email
FROM customer
WHERE active = 1;

### Data Aggregation

DROP VIEW sales_by_film_category;

CREATE VIEW sales_by_film_category
AS
SELECT
    c.name AS category,
    SUM(p.amount) AS total_sales
FROM payment AS p
    INNER JOIN rental AS r
    ON p.rental_id = r.rental_id
    INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
    INNER JOIN film AS f
    ON i.film_id = f.film_id
    INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
    INNER JOIN category AS c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;

SELECT *
FROM sales_by_film_category;

### Hiding Complexity

CREATE VIEW film_stats
AS
SELECT f.film_id, f.title, f.description, f.rating,
       (SELECT c.name
        FROM category AS c
            INNER JOIN film_category AS fc
            ON c.category_id = fc.category_id
        WHERE fc.film_id = f.film_id) AS category_name,
        (SELECT COUNT(*)
        FROM film_actor AS fa
        WHERE fa.film_id = f.film_id) AS num_actors,
        (SELECT COUNT(*)
        FROM inventory AS i
        WHERE i.film_id = f.film_id) AS inventory_cnt,
        (SELECT COUNT(*)
        FROM inventory AS i
            INNER JOIN rental AS r
            ON i.inventory_id = r.inventory_id
        WHERE i.film_id = f.film_id) AS num_rentals
FROM film AS f;

SELECT *
FROM film_stats;

SELECT num_rentals
FROM film_stats;

### Joining Partitioned Data

CREATE VIEW payment_all (
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date,
    last_update
) AS
SELECT payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
FROM payment_historic
UNION ALL
SELECT payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
FROM payment_current;

## Updatable Views

### Updating Simple Views

CREATE VIEW customer_vw (
    customer_id,
    first_name,
    last_name,
    email
) AS
SELECT customer_id,
       first_name,
       last_name,
       CONCAT(SUBSTR(email,1,2), '*****', SUBSTR(email, -4)) AS email
FROM customer;

UPDATE customer_vw
SET last_name = 'SMITH-ALLEN'
WHERE customer_id = 1;

SELECT first_name, last_name, email
FROM customer
WHERE customer_id = 1;

UPDATE customer_vw
SET email = 'MARY.SMITH-ALLEN@sakilacustomer.org'
WHERE customer_id = 1;

INSERT INTO customer_vw (customer_id, first_name, last_name)
VALUES (99999, 'ROBERT', 'SIMPSON');

### Updating Complex Views

CREATE VIEW customer_details
AS
SELECT c.customer_id,
       c.store_id,
       c.first_name,
       c.last_name,
       c.address_id,
       c.active,
       c.create_date,
       a.address,
       ct.city,
       cn.country,
       a.postal_code
FROM customer AS c
    INNER JOIN address AS a
    ON c.address_id = a.address_id
    INNER JOIN city AS ct
    ON a.city_id = ct.city_id
    INNER JOIN country AS cn
    ON ct.country_id = cn.country_id;

SELECT *
FROM customer_details;

UPDATE customer_details
SET last_name = 'SMITH-ALLEN', active = 0
WHERE customer_id = 1;

SELECT first_name, last_name, active
FROM customer
WHERE customer_id = 1;

UPDATE customer_details
SET address = '999 Mockingbird Lane'
WHERE customer_id = 1;

SELECT first_name, last_name, address
FROM customer AS c
    INNER JOIN address AS a
    ON c.address_id = a.address_id
WHERE customer_id = 1;

UPDATE customer_details
SET last_name = 'SMITH-ALLEN',
    active = 0,
    address = '999 Mockingbird Lane'
WHERE customer_id = 1;

INSERT INTO customer_details (customer_id, store_id, first_name, last_name, address_id, active, create_date)
VALUES (9998, 1, 'BRIAN', 'SALAZAR', 5, 1, NOW());

SELECT *
FROM customer
WHERE customer_id = 9998;

INSERT INTO customer_details (customer_id, store_id, first_name, last_name, address_id, active, create_date, address)
VALUES (9998, 1, 'BRIAN', 'SALAZAR', 5, 1, NOW(), '999 Mockingbird Lane');

## Test Your Knowledge

### Exercise 14-1

#### Personal

CREATE VIEW film_ctgry_actor
AS
SELECT f.title,
       c.name AS category_name,
       a.first_name,
       a.last_name
FROM film AS f
    INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
    INNER JOIN category AS c
    ON fc.category_id = c.category_id
    INNER JOIN film_actor AS fa
    ON f.film_id = fa.film_id
    INNER JOIN actor AS a
    ON fa.actor_id = a.actor_id;

SELECT title, category_name, first_name, last_name
FROM film_ctgry_actor
WHERE last_name = 'FAWCETT';

#### Book

CREATE VIEW film_ctgry_actor
AS
SELECT f.title,
       c.name AS category_name,
       a.first_name,
       a.last_name
FROM film AS f
    INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
    INNER JOIN category AS c
    ON fc.category_id = c.category_id
    INNER JOIN film_actor AS fa
    ON f.film_id = fa.film_id
    INNER JOIN actor AS a
    ON fa.actor_id = a.actor_id;

### Exercise 14-2

#### Personal

CREATE VIEW country_tot_payments
AS
SELECT country,
       (SELECT COUNT(*)
        FROM payment AS p
            INNER JOIN customer AS c
            ON p.customer_id = c.customer_id
            INNER JOIN address AS a
            ON c.address_id = a.address_id
            INNER JOIN city AS ct
            ON a.city_id = ct.city_id
        WHERE ct.country_id = country.country_id) AS tot_payments
FROM country;

SELECT *
FROM country_tot_payments;

#### Book

CREATE VIEW country_payments
AS
SELECT country,
       (SELECT SUM(p.amount)
        FROM city AS ct
            INNER JOIN address AS a
            ON ct.city_id = a.city_id
            INNER JOIN customer AS cst
            ON a.address_id = cst.address_id
            INNER JOIN payment AS p
            ON cst.customer_id = p.customer_id
        WHERE ct.country_id = c.country_id) AS tot_payments
FROM country AS c;

SELECT *
FROM country_payments;