# CHAPTER 1: A Little Background

## What Is SQL?

### SQL Statement Classes

CREATE TABLE corporation(
    corp_id SMALLINT,
    name VARCHAR(30),
    CONSTRAINT pk_corporation PRIMARY KEY (corp_id)
);

INSERT INTO corporation (corp_id, name)
VALUES (27, 'Acme Paper Corporation');

SELECT name
FROM corporation
WHERE corp_id = 27;

### SQL Examples

SELECT t.txn_id, t.txn_type_cd, t.txn_date, t.amount
FROM individual AS i
    INNER JOIN account AS a
    ON i.cust_id = a.cust_id
    INNER JOIN product AS p
    ON p.product_cd = a.product_cd
    INNER JOIN transaction AS t
    ON t.account_id = a.account_id
WHERE i.fname = 'George' AND i.lname = 'Blake' AND p.name = 'checking account';

SELECT t.txn_id, t.txn_type_cd, t.txn_date, t.amount
FROM account AS a
    INNER JOIN transaction AS t
    ON t.account_id = a.account_id
WHERE a.cust_id = 8 AND a.product_cd = 'CHK';

SELECT cust_id, fname
FROM individual
WHERE lname = 'Smith';

INSERT INTO product (product_cd, name)
VALUES ('CD', 'Certificate of Depysit');

UPDATE product
SET name = 'Certificate of Deposit'
WHERE product_cd = 'CD';