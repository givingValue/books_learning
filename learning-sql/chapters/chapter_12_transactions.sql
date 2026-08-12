# CHAPTER 12: Transactions

## What Is a Transaction?

START TRANSACTION;

/* withdraw money from first account, making sure balance is sufficient */
UPDATE account SET avail_balance = avail_balance - 500
WHERE account_id = 9988 and avail_balance > 500;

IF <exactly one row was updated by the previous statement> THEN
    /* deposit money into the second account */
    UPDATE account SET avail_balance = avail_balance + 500
    WHERE account_id = 9989;

    IF <exactly one row was updated by the previous statement> THEN
        /* everything worked, make the changes permanent */
        COMMIT;
    ELSE
        /* something went wrong, undo all changes in this transaction */
        ROLLBACK;
    END IF;

ELSE
    /* insufficient funds, or error encountered during update */
    ROLLBACK;
END IF;

### Starting a Transaction

SET AUTOCOMMIT = 0;

### Transaction Savepoints

SHOW TABLE STATUS LIKE 'customer';

ALTER TABLE customer ENGINE = INNODB;

SAVEPOINT my_savepoint;

ROLLBACK TO SAVEPOINT my_savepoint;

START TRANSACTION;

UPDATE product
SET date_retired = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';

SAVEPOINT before_close_accounts;

UPDATE account
SET status = 'CLOSED', close_date = CURRENT_TIMESTAMP(), last_activity_date = CURRENT_TIMESTAMP()
WHERE product_cd = 'XYZ';

ROLLBACK TO SAVEPOINT before_close_accounts;

COMMIT;

## Test Your Knowledge

### Exercise 12-1

#### Personal

START TRANSACTION;

UPDATE account
SET avail_balance = avail_balance - 50
WHERE account_id = 123;

INSERT INTO transaction (txn_date, account_id, txn_type_cd, amount)
VALUES (CURRENT_DATE(), 123, 'D', 50);

UPDATE account
SET avail_balance = avail_balance + 50
WHERE account_id = 789;

INSERT INTO transaction (txn_date, account_id, txn_type_cd, amount)
VALUES (CURRENT_DATE(), 789, 'C', 50);

COMMIT;

#### Book

START TRANSACTION;

INSERT INTO transaction (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1003, NOW(), 123, 'D', 50);

INSERT INTO transaction (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1004, NOW(), 789, 'C', 50);

UPDATE account
SET avail_balance = avail_balance - 50,
    last_activity_date = NOW()
WHERE account_id = 123;

UPDATE account
SET avail_balance = avail_balance + 50,
    last_activity_date = NOW()
WHERE account_id = 789;

COMMIT;