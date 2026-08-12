# CHAPTER 5: Querying Multiple Tables

## What Is a Join?

DESC customer;

DESC address;

### Cartesian Product

SELECT c.first_name, c.last_name, a.address
FROM customer AS c
    JOIN address AS a;

### inner Joins

SELECT c.first_name, c.last_name, a.address
FROM customer AS c
    JOIN address AS a
    ON c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer AS c
    INNER JOIN address AS a
    ON c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer AS c
    INNER JOIN address AS a
    USING(address_id);

### The ANSI Join Syntax

SELECT c.first_name, c.last_name, a.address
FROM customer AS c, address AS a
WHERE c.address_id = a.address_id;

SELECT c.first_name, c.last_name, a.address
FROM customer AS c, address AS a
WHERE c.address_id = a.address_id
  AND a.postal_code = 52137;

SELECT c.first_name, c.last_name, a.address
FROM customer AS c INNER JOIN address AS a
    ON c.address_id = a.address_id
WHERE a.postal_code = 52137;

## Joining Three or More Tables

DESC address;

DESC city;

SELECT c.last_name, c.first_name, ct.city
FROM customer AS c
    INNER JOIN address AS a
    ON c.address_id = a.address_id
    INNER JOIN city as ct
    ON a.city_id = ct.city_id;

SELECT c.last_name, c.first_name, ct.city
FROM city AS ct
    INNER JOIN address AS a
    ON ct.city_id = a.city_id
    INNER JOIN customer as c
    ON c.address_id = a.address_id;

SELECT c.last_name, c.first_name, ct.city
FROM address AS a
    INNER JOIN city AS ct
    ON a.city_id = ct.city_id
    INNER JOIN customer as c
    ON c.address_id = a.address_id;

SELECT STRAIGHT_JOIN c.last_name, c.first_name, ct.city
FROM city AS ct
    INNER JOIN address AS a
    ON ct.city_id = a.city_id
    INNER JOIN customer as c
    ON c.address_id = a.address_id;

### Using Subqueries Tables

SELECT c.first_name, c.last_name, addr.address, addr.city
FROM customer AS c
    INNER JOIN
        (SELECT a.address_id, a.address, ct.city
         FROM address AS a
            INNER JOIN city as ct
            ON a.city_id = ct.city_id
         WHERE a.district = 'California') AS addr
    ON c.address_id = addr.address_id;

SELECT a.address_id, a.address, ct.city
FROM address AS a
    INNER JOIN city as ct
    ON a.city_id = ct.city_id
WHERE a.district = 'California';

### Using the Same Table Twice

SELECT f.title
FROM film AS f
    INNER JOIN film_actor AS fa
    ON f.film_id = fa.film_id
    INNER JOIN actor AS a
    ON fa.actor_id = a.actor_id
WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
    OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));

SELECT COUNT(*)
FROM film AS f
    INNER JOIN film_actor AS fa1
    ON f.film_id = fa1.film_id
    INNER JOIN actor AS a1
    ON fa1.actor_id = a1.actor_id;

SELECT f.title
FROM film AS f
    INNER JOIN film_actor AS fa1
    ON f.film_id = fa1.film_id
    INNER JOIN actor AS a1
    ON fa1.actor_id = a1.actor_id
    INNER JOIN film_actor AS fa2
    ON f.film_id = fa2.film_id
    INNER JOIN actor AS a2
    ON fa2.actor_id = a2.actor_id
WHERE ((a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
    AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH'));

SELECT COUNT(*)
FROM film AS f
    INNER JOIN film_actor AS fa1
    ON f.film_id = fa1.film_id
    INNER JOIN actor AS a1
    ON fa1.actor_id = a1.actor_id;

SELECT COUNT(*)
FROM film AS f
    INNER JOIN film_actor AS fa1
    ON f.film_id = fa1.film_id
    INNER JOIN actor AS a1
    ON fa1.actor_id = a1.actor_id
    INNER JOIN film_actor AS fa2
    ON f.film_id = fa2.film_id;

SELECT COUNT(*)
FROM film AS f
    INNER JOIN film_actor AS fa1
    ON f.film_id = fa1.film_id
    INNER JOIN actor AS a1
    ON fa1.actor_id = a1.actor_id
    INNER JOIN film_actor AS fa2
    ON f.film_id = fa2.film_id
    INNER JOIN actor AS a2
    ON fa2.actor_id = a2.actor_id;


SELECT f.title
FROM film AS f
    INNER JOIN film_actor AS fa
    ON f.film_id = fa.film_id
    INNER JOIN actor AS a
    ON fa.actor_id = a.actor_id
WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
    OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'))
GROUP BY f.film_id
HAVING COUNT(*) > 1;

## Self-Joins

DESC film;

SELECT *
FROM film AS f
    INNER JOIN film AS f_prnt
    ON f.prequel_film_id = f_prnt.film_id
WHERE f.prequel_film_id IS NOT NULL;

## Test Your Knowledge

### Exercise 5-1

#### Personal

SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer AS c
    INNER JOIN  address AS a
    ON c.address_id = a.address_id
    INNER JOIN city as ct
    ON a.city_id = ct.city_id
WHERE a.district = 'California';

#### Book

SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer AS c
    INNER JOIN  address AS a
    ON c.address_id = a.address_id
    INNER JOIN city as ct
    ON a.city_id = ct.city_id
WHERE a.district = 'California';

### Exercise 5-2

#### Personal

SELECT DISTINCT f.title, a.first_name, a.last_name
FROM film as f
    INNER JOIN film_actor as fa
    ON f.film_id = fa.film_id
    INNER JOIN actor as a
    ON fa.actor_id = a.actor_id
WHERE a.first_name = 'JOHN';

#### Book

SELECT f.title
FROM film as f
    INNER JOIN film_actor as fa
    ON f.film_id = fa.film_id
    INNER JOIN actor as a
    ON fa.actor_id = a.actor_id
WHERE a.first_name = 'JOHN';

### Exercise 5-3

#### Book

SELECT a1.address AS addr1, a2.address AS addr2, a1.city_id
FROM address AS a1
    INNER JOIN address a2
    ON a1.city_id = a2.city_id
    AND a1.address < a2.address;

SELECT a1.address AS addr1, a2.address AS addr2, a1.city_id
FROM address AS a1
    INNER JOIN address a2
    ON a1.city_id = a2.city_id
    AND a1.address > a2.address;

SELECT city_id, COUNT(address)
FROM address
GROUP BY city_id
HAVING COUNT(address) > 1;