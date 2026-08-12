# CHAPTER 2: Creating and Populating Database

## Using the mysql Command-Line Tool

SHOW DATABASES;

USE sakila;

SELECT NOW();

SELECT NOW()
FROM dual;

## MySQL Data Types

### Character Data

#### Character sets

SHOW CHARACTER SET;

VARCHAR(20) CHARACTER SET latin1,

CREATE DATABASE european_sakes CHARACTER SET latin1;

## Table Creation

### Step 3: Building SQL Schema Statements

CREATE TABLE person (
    person_id SMALLINT UNSIGNED,
    fname VARCHAR(20),
    lname VARCHAR(20),
    eye_color CHAR(2),
    birth_date DATE,
    street VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20),
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

eye_color CHAR(2) CHECK (eye_color IN ('BR', 'BL', 'GR')),

eye_color ENUM('BR', 'BL', 'GR'),

CREATE TABLE person (
    person_id SMALLINT UNSIGNED,
    fname VARCHAR(20),
    lname VARCHAR(20),
    eye_color ENUM('BR', 'BL', 'GR'),
    birth_date DATE,
    street VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20),
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

CREATE TABLE favorite_food (
    person_id SMALLINT UNSIGNED,
    food VARCHAR(20),
    CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id) REFERENCES person (person_id)
);

DESC favorite_food;

## Populating and Modifying Tables

### Inserting Date

#### Generating numeric key data

ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;

SET foreign_key_checks = 0;

ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;

SET foreign_key_checks = 1;

DESC person;

#### The insert statement

INSERT INTO person (person_id, fname, lname, eye_color, birth_date)
VALUES (NULL, 'William', 'Turner', 'BR', '1972-05-27');

SELECT person_id, fname, lname, birth_date
FROM person;

SELECT person_id, fname, lname, birth_date
FROM person
WHERE person_id = 1;

SELECT person_id, fname, lname, birth_date
FROM person
WHERE lname = 'Turner';

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'pizza');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'cookies');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'nachos');

SELECT food
FROM favorite_food
WHERE person_id = 1
ORDER BY food;

INSERT INTO person (person_id, fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
VALUES (NULL, 'Susan', 'Smith', 'BL', '1975-11-02', '23 Maple St.', 'Arlington', 'VA', 'USA', '20220');

SELECT person_id, fname, lname, birth_date
FROM person;

SELECT *
FROM favorite_food
FOR XML AUTO, ELEMENTS;

### Updating Data

UPDATE person
    SET street = '1225 Tremont St.',
        city = 'Boston',
        state = 'MA',
        country = 'USA',
        postal_code = '02138'
WHERE person_id = 1;

### Deleting Data

DELETE FROM person
WHERE person.person_id = 2;

## When Good Statements Go Bad

### Nonunique Primary Key

INSERT INTO person (person_id, fname, lname, eye_color, birth_date)
VALUES (1, 'Charles', 'Fulton', 'GR', '1968-01-15');

### Nonexistent Foreign Key

INSERT INTO favorite_food (person_id, food)
VALUES (999, 'lasagna');

### Column Value Violations

UPDATE person
SET eye_color = 'ZZ'
WHERE person_id = 1;

### Invalid Date Conversions

UPDATE person
SET birth_date = 'DEC-21-1980'
WHERE person_id = 1;

UPDATE person
SET birth_date = STR_TO_DATE('DEC-21-1980', '%b-%d-%Y')
WHERE person_id = 1;

## The Sakila Database

SHOW TABLES;

DROP TABLE favorite_food;

DROP TABLE person;

DESC customer;