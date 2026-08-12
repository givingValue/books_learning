# CHAPTER 11: Conditional Logic

## What Is Conditional Logic?

SELECT first_name, last_name,
       CASE
            WHEN active = 1 THEN 'ACTIVE'
            ELSE 'INACTIVE'
        END AS activity_type
FROM customer;

## The case Expression

### Searched case Expressions

SELECT category.name,
    (CASE
        WHEN category.name IN ('Children', 'Family', 'Sports', 'Animation') THEN 'All Ages'
        WHEN category.name = 'Horror' THEN 'Adult'
        WHEN category.name IN ('Music', 'Games') THEN 'Teens'
        ELSE 'Other'
    END) AS age_category
FROM category;

SELECT c.first_name, c.last_name,
    CASE
        WHEN c.active = 0 THEN 0
        ELSE
            (SELECT COUNT(*)
             FROM rental AS r
             WHERE r.customer_id = c.customer_id)
    END AS num_rentals
FROM customer AS c;

### Simple case Expressions

SELECT category.name,
    (CASE category.name
        WHEN 'Children' THEN 'All Ages'
        WHEN 'Family' THEN 'All Ages'
        WHEN 'Sports' THEN 'All Ages'
        WHEN 'Animation' THEN 'All Ages'
        WHEN 'Horror' THEN 'Adult'
        WHEN 'Music' THEN 'Teens'
        WHEN 'Games' THEN 'Teens'
        ELSE 'Other'
    END) AS age_category
FROM category;

## Examples of case Expressions

### Result Set Transformations

SELECT MONTHNAME(r.rental_date) AS rental_month, COUNT(*) AS num_rentals
FROM rental AS r
WHERE r.rental_date BETWEEN '2005-05-01' AND '2005-08-01'
GROUP BY MONTHNAME(r.rental_date);

SELECT
    SUM(
        CASE
            WHEN MONTHNAME(r.rental_date) = 'May' THEN 1
            ELSE 0
        END
    ) AS may_rentals,
    SUM(
        CASE
            WHEN MONTHNAME(r.rental_date) = 'June' THEN 1
            ELSE 0
        END
    ) AS june_rentals,
    SUM(
        CASE
            WHEN MONTHNAME(r.rental_date) = 'July' THEN 1
            ELSE 0
        END
    ) AS july_rentals
FROM rental AS r
WHERE r.rental_date BETWEEN '2005-05-01' AND '2005-08-01';

WITH month_rentals AS (
    SELECT
        CASE
            WHEN MONTHNAME(r.rental_date) = 'May' THEN 1
            ELSE 0
        END AS may_rentals,
        CASE
            WHEN MONTHNAME(r.rental_date) = 'June' THEN 1
            ELSE 0
        END AS june_rentals,
        CASE
            WHEN MONTHNAME(r.rental_date) = 'July' THEN 1
            ELSE 0
        END AS july_rentals
    FROM rental AS r
    WHERE r.rental_date BETWEEN '2005-05-01' AND '2005-08-01'
)
SELECT SUM(month_rentals.may_rentals) AS may_rentals,
       SUM(month_rentals.june_rentals) AS june_rentals,
       SUM(month_rentals.july_rentals) AS july_rentals
FROM month_rentals;

### Checking for Existence

SELECT a.first_name, a.last_name,
       CASE
           WHEN EXISTS
               (SELECT 1
                FROM film_actor AS fa
                    INNER JOIN film AS f
                    ON fa.film_id = f.film_id
                WHERE fa.actor_id = a.actor_id
                AND f.rating = 'G') THEN 'Y'
           ELSE 'N'
       END AS g_actor,
       CASE
           WHEN EXISTS
               (SELECT 1
                FROM film_actor AS fa
                    INNER JOIN film AS f
                    ON fa.film_id = f.film_id
                WHERE fa.actor_id = a.actor_id
                AND f.rating = 'PG') THEN 'Y'
           ELSE 'N'
       END AS pg_actor,
       CASE
           WHEN EXISTS
               (SELECT 1
                FROM film_actor AS fa
                    INNER JOIN film AS f
                    ON fa.film_id = f.film_id
                WHERE fa.actor_id = a.actor_id
                AND f.rating = 'NC-17') THEN 'Y'
           ELSE 'N'
       END AS nc17_actor
FROM actor AS a
WHERE a.last_name LIKE 'S%' OR a.first_name LIKE 'S%';

WITH film_actor_g AS ( # My alternative for the last query
    SELECT fa.actor_id, f.rating
    FROM film_actor AS fa
        INNER JOIN film AS f
        ON fa.film_id = f.film_id
    GROUP BY fa.actor_id, f.rating
),
actors_g AS (
    SELECT a.first_name, a.last_name,
        CASE
            WHEN fa1.rating IS NULL THEN 'N'
            ELSE 'Y'
        END AS g_actor,
        CASE
            WHEN fa2.rating IS NULL THEN 'N'
            ELSE 'Y'
        END AS pg_actor,
        CASE
            WHEN fa3.rating IS NULL THEN 'N'
            ELSE 'Y'
        END AS nc_17_actor
    FROM actor AS a
        LEFT OUTER JOIN film_actor_g AS fa1
        ON a.actor_id = fa1.actor_id AND fa1.rating = 'G'
        LEFT OUTER JOIN film_actor_g AS fa2
        ON a.actor_id = fa2.actor_id AND fa2.rating = 'PG'
        LEFT OUTER JOIN film_actor_g AS fa3
        ON a.actor_id = fa3.actor_id AND fa3.rating = 'NC-17'
)
SELECT *
FROM actors_g
WHERE last_name LIKE 'S%' OR first_name LIKE 'S%';

SELECT f.title,
       CASE (SELECT COUNT(*) FROM inventory AS i WHERE i.film_id = f.film_id)
           WHEN 0 THEN 'Out Of Stock'
           WHEN 1 THEN 'Scarce'
           WHEN 2 THEN 'Scarce'
           WHEN 3 THEN 'Available'
           WHEN 4 THEN 'Available'
           ELSE 'Common'
       END AS film_aVailability
FROM film AS f;

### Division-by-Zero Errors

SELECT 100 / 0;

SELECT c.first_name, c.last_name,
       SUM(p.amount) AS tot_payment_amt,
       COUNT(p.amount) AS num_payments,
       SUM(p.amount) /
            CASE
                WHEN COUNT(p.amount) = 0 THEN 1
                ELSE COUNT(p.amount)
            END AS avg_payment
FROM customer AS c
    LEFT OUTER JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

### Conditional Updates

UPDATE customer AS c
SET active =
    CASE
        WHEN 90 <= (SELECT DATEDIFF(NOW(), MAX(r.rental_date))
                    FROM rental AS r
                    WHERE r.customer_id = c.customer_id)
            THEN 0
        ELSE 1
    END
WHERE c.active = 1;

### Handling Null Values

SELECT c.first_name, c.last_name,
       CASE
           WHEN a.address IS NULL THEN 'Unknown'
           ELSE a.address
       END as address,
       CASE
           WHEN ct.city IS NULL THEN 'Unknown'
           ELSE ct.city
       END as city,
       CASE
           WHEN cn.country IS NULL THEN 'Unknown'
           ELSE cn.country
       END as country
FROM customer AS c
    LEFT OUTER JOIN address AS a
    ON c.address_id = a.address_id
    LEFT OUTER JOIN city AS ct
    ON a.city_id = ct.city_id
    LEFT OUTER JOIN country AS cn
    ON ct.country_id = cn.country_id;

SELECT (7 * 5) / ((3 + 14) * NULL);

## Test Your Knowledge

### Exercise 11-1

#### Personal

SELECT l.name,
       CASE
           WHEN l.name IN ('English', 'Italian', 'French', 'German') THEN 'latin1'
           WHEN l.name IN ('Japanese', 'Mandarin') THEN 'utf8'
           ELSE 'Unknown'
       END AS character_set
FROM language AS l;

#### Book

SELECT name,
       CASE
           WHEN name IN ('English', 'Italian', 'French', 'German')
               THEN 'latin1'
           WHEN name IN ('Japanese', 'Mandarin')
               THEN 'utf8'
           ELSE 'Unknown'
       END AS character_set
FROM language;

### Exercise 11-1

#### Personal

SELECT
    SUM(
        CASE
            WHEN f.rating = 'G' THEN 1
            ELSE 0
        END
    ) AS G,
    SUM(
        CASE
            WHEN f.rating = 'PG' THEN 1
            ELSE 0
        END
    ) AS PG,
    SUM(
        CASE
            WHEN f.rating = 'PG-13' THEN 1
            ELSE 0
        END
    ) AS PG_13,
    SUM(
        CASE
            WHEN f.rating = 'R' THEN 1
            ELSE 0
        END
    ) AS R,
    SUM(
        CASE
            WHEN f.rating = 'NC-17' THEN 1
            ELSE 0
        END
    ) AS NC_17
FROM film AS f;

#### Book

SELECT
    SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS G,
    SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS PG,
    SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS PG_13,
    SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS R,
    SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS NC_17
FROM film;