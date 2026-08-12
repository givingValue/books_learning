# CHAPTER 13: Indexes and Constraints

## Indexes

SELECT first_name, last_name
FROM customer
WHERE last_name LIKE 'Y%';

### Index Creation

ALTER TABLE customer
ADD INDEX idx_email (email);

SHOW INDEX FROM customer;

ALTER TABLE customer
DROP INDEX idx_email;

#### Unique indexes

ALTER TABLE customer
ADD UNIQUE idx_email (email);

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (1, 'ALAN', 'KAHN', 'ALAN.KAHN@sakilacustomer.org', 394, 1);

#### Multicolumn indexes

ALTER TABLE customer
ADD INDEX idx_full_name (last_name, first_name);

SHOW INDEX FROM customer;

### Types of Indexes

#### Bitmap indexes

CREATE BITMAP INDEX idx_active ON customer (active);

### How Indexes Are Used

SELECT customer_id, first_name, last_name
FROM customer
WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

EXPLAIN
SELECT customer_id, first_name, last_name
FROM customer
WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

## Constraints

### Constraint Creation

CREATE TABLE customer
(
    customer_id SMALLINT UNSIGNED AUTO_INCREMENT,
    store_id    TINYINT UNSIGNED NOT NULL,
    first_name  VARCHAR(45) NOT NULL,
    last_name   VARCHAR(45) NOT NULL,
    email       VARCHAR(50) NOT NULL,
    address_id  SMALLINT UNSIGNED NOT NULL,
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    create_date DATETIME NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id),
    KEY idx_fk_store_id (store_id),
    KEY idx_fk_address_id (address_id),
    KEY idx_fk_last_name (last_name),
    CONSTRAINT idx_email UNIQUE (email),
    CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
        REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_customer_store FOREIGN KEY (store_id)
        REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE customer
ADD CONSTRAINT fk_customer_address FOREIGN KEY (address_id)
REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE customer
ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id)
REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE;

SELECT c.first_name, c.last_name, c.address_id, a.address
FROM customer AS c
    INNER JOIN address AS a
    ON c.address_id = a.address_id
WHERE a.address_id = 123;

DELETE FROM address
WHERE address_id = 123;

UPDATE address
SET address_id = 9999
WHERE address_id = 123;

SELECT c.first_name, c.last_name, c.address_id, a.address
FROM customer AS c
    INNER JOIN address AS a
    ON c.address_id = a.address_id
WHERE a.address_id = 9999;

ALTER TABLE customer
DROP CONSTRAINT fk_customer_store;

## Test Your Knowledge

### Exercise 13-1

#### Personal

SHOW INDEX FROM rental;

ALTER TABLE rental
DROP CONSTRAINT fk_rental_customer;

ALTER TABLE rental
ADD CONSTRAINT  fk_rental_customer FOREIGN KEY (customer_id)
REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

DELETE FROM customer
WHERE customer_id = 1;

#### Book

ALTER TABLE rental
ADD CONSTRAINT  fk_rental_customer_id FOREIGN KEY (customer_id)
REFERENCES customer (customer_id) ON DELETE RESTRICT;

### Exercise 13-2

#### Personal

ALTER TABLE payment
ADD INDEX idx_pymtdate_amount (payment_date, amount);

SHOW INDEX FROM payment;

EXPLAIN
SELECT customer_id, payment_date, amount
FROM payment
WHERE payment_date > CAST('2019-12-31 23:59:59' AS DATETIME);

EXPLAIN
SELECT customer_id, payment_date, amount
FROM payment
WHERE payment_date > CAST('2019-12-31 23:59:59' AS DATETIME)
    AND amount < 5;

#### Book

CREATE INDEX idx_payment01
ON payment (payment_date, amount);