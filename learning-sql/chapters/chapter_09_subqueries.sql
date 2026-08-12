# CHAPTER 9: Subqueries

## What Is a Subquery?

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = (SELECT MAX(customer_id) FROM customer);

SELECT MAX(customer_id)
FROM customer;

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = 599;

## Noncorrelated Subqueries

SELECT city_id, city
FROM city
WHERE country_id <>
      (SELECT country_id FROM country where country = 'India')
ORDER BY city_id;

SELECT city_id, city
FROM city
WHERE country_id <>
      (SELECT country_id FROM country where country <> 'India')
ORDER BY city_id;

SELECT country_id
FROM country
WHERE country <> 'India';

### Multiple-Row, Single-Column Subqueries

#### The in and not operators

SELECT country_id
FROM country
WHERE country IN ('Canada', 'Mexico');

SELECT country_id
FROM country
WHERE country = 'Canada' OR country = 'Mexico';

SELECT city_id, city
FROM city
WHERE country_id IN
    (SELECT country_id
     FROM country
     WHERE country IN ('Canada', 'Mexico'));

SELECT city_id, city
FROM city
WHERE country_id NOT IN
    (SELECT country_id
     FROM country
     WHERE country IN ('Canada', 'Mexico'));

SELECT first_name, last_name
FROM customer
WHERE customer_id <> ALL
    (SELECT customer_id
     FROM payment
     WHERE amount = 0);

SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN
    (SELECT customer_id
     FROM payment
     WHERE amount = 0);

SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN (122,452, NULL);

SELECT first_name, last_name
FROM customer
WHERE customer_id <> ALL (122, 452, 120); # Can not be used with simple sets, apparently only subqueries 

SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) > ALL
    (SELECT COUNT(*)
     FROM rental AS r
        INNER JOIN customer AS c
        ON r.customer_id = c.customer_id
        INNER JOIN address AS a
        ON c.address_id = a.address_id
        INNER JOIN city AS ct
        ON a.city_id = ct.city_id
        INNER JOIN country as co
        on ct.country_id = co.country_id
     WHERE co.country IN ('United States', 'Mexico', 'Canada')
     GROUP BY r.customer_id);

#### The any operator

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > ANY
    (SELECT SUM(p.amount)
    FROM payment AS p
        INNER JOIN customer AS c
        ON p.customer_id = c.customer_id
        INNER JOIN address AS a
        ON c.address_id = a.address_id
        INNER JOIN city AS ct
        ON a.city_id = ct.city_id
        INNER JOIN country AS co
        ON ct.country_id = co.country_id
    WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
    GROUP BY co.country);

### Multicolumn Subqueries

SELECT fa.actor_id, fa.film_id
FROM film_actor AS fa
WHERE fa.actor_id IN
    (SELECT actor_id FROM actor WHERE last_name = 'MONROE')
    AND film_id IN
    (SELECT film_id FROM film WHERE rating = 'PG');

SELECT c.actor_id, f.film_id
FROM actor AS c
    INNER JOIN film_actor AS fa
    ON c.actor_id = fa.actor_id
    INNER JOIN film AS f
    ON fa.film_id = f.film_id
WHERE c.last_name = 'MONROE' AND f.rating = 'PG';

SELECT actor_id, film_id
FROM film_actor
WHERE (actor_id, film_id) IN
    (SELECT a.actor_id, f.film_id
    FROM actor AS a
        CROSS JOIN film AS f
    WHERE a.last_name = 'MONROE'
    AND f.rating = 'PG');

SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM actor AS a
    CROSS JOIN film AS f
WHERE a.last_name = 'MONROE' AND f.rating = 'PG'
ORDER BY a.actor_id;

SELECT COUNT(*)
FROM actor AS a
    CROSS JOIN film AS f
WHERE a.last_name = 'MONROE' AND f.rating = 'PG';

SELECT COUNT(*)
FROM actor
WHERE last_name = 'MONROE';

SELECT COUNT(*)
FROM film
WHERE rating = 'PG';

(SELECT actor_id, film_id
FROM film_actor)
INTERSECT
(SELECT a.actor_id, f.film_id
FROM actor AS a
    CROSS JOIN film AS f
WHERE a.last_name = 'MONROE'
AND f.rating = 'PG')
ORDER BY actor_id, film_id;

## Correlated Subqueries

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE 20 =
      (SELECT COUNT(*) FROM rental AS r
        WHERE r.customer_id = c.customer_id);

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE
    (SELECT SUM(p.amount)
     FROM payment AS p
     WHERE p.customer_id = c.customer_id)
    BETWEEN 180 AND 240;

### The exist Operator

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE EXISTS
    (SELECT 1
    FROM rental AS r
    WHERE r.customer_id = c.customer_id
        AND DATE(r.rental_date) < '2005-05-25');

SELECT 1
FROM rental AS r
WHERE DATE(r.rental_date) < '2005-05-25';

SELECT c.first_name, c.last_name
FROM customer AS c
WHERE EXISTS
    (SELECT r.rental_date, r.customer_id, 'ABCD' AS str, 2 * 3 / 7 AS nmbr
    FROM rental AS r
    WHERE r.customer_id = c.customer_id
        AND DATE(r.rental_date) < '2005-05-25');

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE NOT EXISTS
    (SELECT 1
    FROM film_actor AS fa
        INNER JOIN film AS f
        ON fa.film_id = f.film_id
    WHERE fa.actor_id = a.actor_id
        AND f.rating = 'R');

### Data Manipulation Using Correlated Subqueries

UPDATE customer AS c
SET c.last_update =
    (SELECT MAX(r.rental_date)
     FROM rental AS r
     WHERE r.customer_id = c.customer_id);

UPDATE customer AS c
SET c.last_update =
    (SELECT MAX(r.rental_date)
     FROM rental AS r
     WHERE r.customer_id = c.customer_id)
WHERE EXISTS
    (SELECT 1
     FROM rental AS r
     WHERE r.customer_id = c.customer_id);

DELETE FROM customer AS c
WHERE 365 < ALL
    (SELECT DATEDIFF(NOW(), r.rental_date) AS days_since_last_rental
     FROM rental AS r
     WHERE r.customer_id = c.customer_id);

DELETE FROM customer AS c
WHERE DATEDIFF(
        NOW(),
        (SELECT MAX(r.rental_date)
        FROM rental AS r
        WHERE r.customer_id = c.customer_id)
      ) > 365;

SELECT MAX(r.rental_date)
FROM rental AS r
WHERE r.customer_id = 1;

SELECT rental_date
FROM rental AS r
WHERE r.customer_id = 1
ORDER BY rental_date DESC;

SELECT COUNT(*)
FROM customer AS c
WHERE DATEDIFF(
        NOW(),
        (SELECT MAX(r.rental_date)
        FROM rental AS r
        WHERE r.customer_id = c.customer_id)
      ) > 365;

WITH temp AS (
    SELECT r.customer_id, DATEDIFF(NOW(), MAX(rental_date)) AS last_rental_diff
    FROM rental AS r
    GROUP BY r.customer_id
)
SELECT t.customer_id
FROM temp AS t
WHERE last_rental_diff > 365;

SELECT *
FROM customer AS c
WHERE c.customer_id IN (
    WITH temp AS (
        SELECT r.customer_id, DATEDIFF(NOW(), MAX(rental_date)) AS last_rental_diff
        FROM rental AS r
        GROUP BY r.customer_id
    )
    SELECT t.customer_id
    FROM temp AS t
    WHERE last_rental_diff > 365
);

DELETE FROM customer AS c
WHERE c.customer_id IN (
    WITH temp AS (
        SELECT r.customer_id, DATEDIFF(NOW(), MAX(rental_date)) AS last_rental_diff
        FROM rental AS r
        GROUP BY r.customer_id
    )
    SELECT t.customer_id
    FROM temp AS t
    WHERE last_rental_diff > 365
);

## When to Use Subqueries

### Subqueries as Data Sources

SELECT c.first_name, c.last_update, pymnt.num_rentals, pymnt.tot_payments
FROM customer AS c
    INNER JOIN (
        SELECT customer_id, COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
        FROM payment
        GROUP BY customer_id
    ) AS pymnt
    ON c.customer_id = pymnt.customer_id;

SELECT customer_id, COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
FROM payment
GROUP BY customer_id;

#### Data fabrication

SELECT 'Small Fry' AS name, 0 AS low_init, 74.99 AS high_limit
UNION
SELECT 'Average Joes' AS name, 75 AS low_init, 149.99 AS high_limit
UNION
SELECT 'Heavy Hitters' AS name, 150 AS low_init, 999999999.99 AS high_limit;

SELECT pymnt_grps.name, COUNT(*) AS num_customers
FROM
    (SELECT customer_id, COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
    FROM payment
    GROUP BY customer_id) AS pymnt
    INNER JOIN
        (SELECT 'Small Fry' AS name, 0 AS low_init, 74.99 AS high_limit
        UNION
        SELECT 'Average Joes' AS name, 75 AS low_init, 149.99 AS high_limit
        UNION
        SELECT 'Heavy Hitters' AS name, 150 AS low_init, 999999999.99 AS high_limit) AS pymnt_grps
    ON pymnt.tot_payments BETWEEN pymnt_grps.low_init AND pymnt_grps.high_limit # Interesting Join
GROUP BY pymnt_grps.name;

#### Task-oriented subqueries

SELECT c.first_name, c.last_name, ct.city,
       SUM(p.amount) AS tot_payments, COUNT(*) AS tot_rentals
FROM payment AS p
    INNER JOIN customer AS c
    ON p.customer_id = c.customer_id
    INNER JOIN address AS a
    ON c.address_id = a.address_id
    INNER JOIN city AS ct
    ON a.city_id = ct.city_id
GROUP BY c.first_name, c.last_name, ct.city;

SELECT p.customer_id, COUNT(*) AS tot_rentals, SUM(p.amount) AS tot_payments
FROM payment AS p
GROUP BY p.customer_id;

SELECT c.first_name, c.last_name, ct.city, pymnt.tot_payments, pymnt.tot_rentals
FROM
    (SELECT p.customer_id, COUNT(*) AS tot_rentals, SUM(p.amount) AS tot_payments
    FROM payment AS p
    GROUP BY p.customer_id) AS pymnt
    INNER JOIN customer AS c
    ON pymnt.customer_id = c.customer_id
    INNER JOIN address AS a
    ON c.address_id = a.address_id
    INNER JOIN city AS ct
    ON a.city_id = ct.city_id;

WITH actor_s AS (
    SELECT actor_id, first_name, last_name
    FROM actor
    WHERE last_name LIKE 'S%'
), actor_s_pg AS (
    SELECT s.actor_id, s.first_name, s.last_name, f.film_id, f.title
    FROM actor_s AS s
        INNER JOIN film_actor AS fa
        ON s.actor_id = fa.actor_id
        INNER JOIN film AS f
        ON fa.film_id = f.film_id
    WHERE f.rating = 'PG'
), actor_s_pg_revenue AS (
    SELECT spg.first_name, spg.last_name, p.amount
    FROM actor_s_pg AS spg
        INNER JOIN inventory AS i
        ON spg.film_id = i.film_id
        INNER JOIN rental AS r
        ON i.inventory_id = r.inventory_id
        INNER JOIN payment AS p
        ON r.rental_id = p.rental_id
)
SELECT spg_rev.first_name, spg_rev.last_name, SUM(spg_rev.amount) AS tot_revenue
FROM actor_s_pg_revenue AS spg_rev
GROUP BY spg_rev.first_name, spg_rev.last_name
ORDER BY 3 DESC;

### Subqueries as Expression Generators

SELECT
    (SELECT c.first_name
     FROM customer AS c
     WHERE c.customer_id = p.customer_id) AS first_name,
    (SELECT c.last_name
     FROM customer AS c
     WHERE c.customer_id = p.customer_id) AS last_name,
    (SELECT ct.city
     FROM customer AS c
        INNER JOIN address AS a
        ON c.address_id = a.address_id
        INNER JOIN city AS ct
        ON a.city_id = ct.city_id
     WHERE c.customer_id = p.customer_id) AS city,
    SUM(p.amount) AS tot_payments,
    COUNT(*) AS tot_rentals
FROM payment AS p
GROUP BY p.customer_id;

SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
ORDER BY
    (SELECT COUNT(*)
     FROM film_actor AS fa
     WHERE fa.actor_id = a.actor_id) DESC;

SELECT actor_id, COUNT(*)
FROM film_actor
GROUP BY actor_id
ORDER BY 2 DESC;

INSERT INTO film_actor (actor_id, film_id, last_update)
VALUES (
    (SELECT c.actor_id
     FROM actor AS c
     WHERE c.first_name = 'JENNIFER' AND c.last_name = 'DAVID'),
    (SELECT f.film_id
     FROM film AS f
     WHERE f.title = 'ACE GOLDFINGER'),
    NOW()
);

## Test Your Knowledge

### Exercise 9-1

#### Personal

SELECT *
FROM film AS f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category AS fc
    WHERE fc.category_id = (SELECT category_id FROM category AS c WHERE c.name = 'Action')
);

#### Book

SELECT title
FROM film AS f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category AS fc
        INNER JOIN category AS c
        ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
);

### Exercise 9-2

#### Personal

SELECT *
FROM film AS f
WHERE EXISTS
    (SELECT 1
    FROM film_category AS fc
        INNER JOIN category AS c
        ON fc.category_id = c.category_id
    WHERE fc.film_id = f.film_id AND c.name = 'ACTION');

#### Book

SELECT f.title
FROM film AS f
WHERE EXISTS
    (SELECT 1
    FROM film_category AS fc
        INNER JOIN category AS c
        ON fc.category_id = c.category_id
    WHERE c.name = 'ACTION' AND fc.film_id = f.film_id);

### Exercise 9-3

#### Personal

SELECT a.first_name, a.last_name, ac.level
FROM actor AS a
    INNER JOIN (
        SELECT fa.actor_id, COUNT(*) as actor_films
        FROM film_actor AS fa
        GROUP BY fa.actor_id
    ) AS fac
    ON a.actor_id = fac.actor_id
    INNER JOIN (
        SELECT 'Hollywood Star' AS level, 30 AS min_roles, 99999 AS max_roles
        UNION
        SELECT 'Prolific Actor' AS level, 20 AS min_roles, 29 AS max_roles
        UNION
        SELECT 'Newcomer' AS level, 1 AS min_roles, 19 AS max_roles
    ) AS ac
    ON fac.actor_films BETWEEN ac.min_roles AND ac.max_roles;

#### Book

SELECT actr.actor_id, grps.level
FROM
    (SELECT fa.actor_id, COUNT(*) AS num_roles
    FROM film_actor AS fa
    GROUP BY fa.actor_id) AS actr
    INNER JOIN
        (SELECT 'Hollywood Star' AS level, 30 AS min_roles, 99999 AS max_roles
        UNION
        SELECT 'Prolific Actor' AS level, 20 AS min_roles, 29 AS max_roles
        UNION
        SELECT 'Newcomer' AS level, 1 AS min_roles, 19 AS max_roles) AS grps
    ON actr.num_roles BETWEEN grps.min_roles AND grps.max_roles;