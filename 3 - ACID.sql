/***********************************************
* ACID Transactions in MySQL
* Author: [Your Name]
* Date: 2025-10-09
* Description: Complete demonstration of ACID
* properties (Atomicity, Consistency, Isolation, Durability)
* with practical examples: Bank Transfer & E-commerce Order
***********************************************/

/*======================================================
1. Transaction Basics
========================================================
A transaction is a sequence of database operations
performed as a single logical unit. Either all operations
succeed (COMMIT) or all fail (ROLLBACK).

MySQL Transaction Commands:
- START TRANSACTION;  -- begin transaction
- COMMIT;             -- save changes permanently
- ROLLBACK;           -- undo changes
======================================================*/

/*======================================================
2. ACID Concepts Explanation
========================================================*/

/* A = Atomicity (All or Nothing)
   - Either all steps of a transaction succeed or none.
   - Prevents partial updates.
*/

/* C = Consistency (Data Validity)
   - Database rules, constraints, relationships must be satisfied.
   - Transaction should not violate constraints.
*/

/* I = Isolation (Transactions Don’t Interfere)
   - Concurrent transactions do not affect each other.
   - Use isolation levels to control visibility.
*/

/* D = Durability (Permanent Save)
   - Once committed, data changes are permanent even if system crashes.
*/

/*======================================================
3. BANK TRANSFER EXAMPLE
========================================================*/

/* Step 1: Create Accounts Table */
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    name VARCHAR(50),
    balance INT CHECK (balance >= 0) -- Consistency
);

/* Step 2: Insert Sample Data */
INSERT INTO accounts VALUES (1, 'Alice', 1000);
INSERT INTO accounts VALUES (2, 'Bob', 500);

/* Step 3: Show Initial State */
SELECT * FROM accounts;
-- Output:
-- +------------+-------+---------+
-- | account_id | name  | balance |
-- +------------+-------+---------+
-- | 1          | Alice | 1000    |
-- | 2          | Bob   | 500     |
-- +------------+-------+---------+

/* Step 4: Successful Transaction */
START TRANSACTION;

UPDATE accounts SET balance = balance - 200 WHERE account_id = 1; -- deduct from Alice
UPDATE accounts SET balance = balance + 200 WHERE account_id = 2; -- add to Bob

COMMIT;

SELECT * FROM accounts;
-- Output after COMMIT:
-- +------------+-------+---------+
-- | account_id | name  | balance |
-- +------------+-------+---------+
-- | 1          | Alice | 800     |
-- | 2          | Bob   | 700     |
-- +------------+-------+---------+

/* Step 5: Failed Transaction (Atomicity Demo) */
START TRANSACTION;

UPDATE accounts SET balance = balance - 1000 WHERE account_id = 1; -- Alice has only 800
UPDATE accounts SET balance = balance + 1000 WHERE account_id = 2; -- would fail CHECK

ROLLBACK;

SELECT * FROM accounts;
-- Output after ROLLBACK:
-- +------------+-------+---------+
-- | account_id | name  | balance |
-- +------------+-------+---------+
-- | 1          | Alice | 800     |
-- | 2          | Bob   | 700     |
-- +------------+-------+---------+

/* Step 6: Isolation Example
   - Concurrent transactions can be controlled using:
     SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
*/

/*======================================================
4. E-COMMERCE ORDER EXAMPLE
========================================================*/

/* Step 1: Create Orders & Payments Tables */
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    product VARCHAR(50),
    status VARCHAR(20)
);

CREATE TABLE payments(
    payment_id INT PRIMARY KEY,
    order_id INT,
    amount INT,
    status VARCHAR(20),
    FOREIGN KEY(order_id) REFERENCES orders(order_id)
);

/* Step 2: Place Order with Successful Payment */
START TRANSACTION;

INSERT INTO orders VALUES (1, 'Laptop', 'PENDING');
INSERT INTO payments VALUES (101, 1, 50000, 'SUCCESS');

UPDATE orders SET status = 'CONFIRMED' WHERE order_id = 1;

COMMIT;

SELECT * FROM orders;
-- Output:
-- +----------+---------+-----------+
-- | order_id | product | status    |
-- +----------+---------+-----------+
-- | 1        | Laptop  | CONFIRMED |
-- +----------+---------+-----------+

SELECT * FROM payments;
-- Output:
-- +-----------+----------+--------+--------+
-- | payment_id| order_id | amount | status |
-- +-----------+----------+--------+--------+
-- | 101       | 1        | 50000  | SUCCESS|
-- +-----------+----------+--------+--------+

/* Step 3: Place Order with Failed Payment (Atomicity Demo) */
START TRANSACTION;

INSERT INTO orders VALUES (2, 'Mobile', 'PENDING');
INSERT INTO payments VALUES (102, 2, 20000, 'FAILED');

-- Payment failed, rollback everything
ROLLBACK;

SELECT * FROM orders;
-- Output:
-- +----------+---------+-----------+
-- | order_id | product | status    |
-- +----------+---------+-----------+
-- | 1        | Laptop  | CONFIRMED |
-- +----------+---------+-----------+

SELECT * FROM payments;
-- Output:
-- +-----------+----------+--------+--------+
-- | payment_id| order_id | amount | status |
-- +-----------+----------+--------+--------+
-- | 101       | 1        | 50000  | SUCCESS|
-- +-----------+----------+--------+--------+

/*======================================================
5. MOST ASKED ACID INTERVIEW QUESTIONS (Bottom)
========================================================*/

/*
Q1: What is ACID in databases?
A1: ACID stands for Atomicity, Consistency, Isolation, and Durability. 
It ensures safe, reliable, and correct database transactions.

Q2: Give a real-life example of ACID.
A2: Bank money transfer. Steps: deduct money from sender, add to receiver. 
- Atomicity: either both happen or none. 
- Consistency: balance cannot go negative. 
- Isolation: multiple transfers handled separately. 
- Durability: once committed, changes are permanent.

Q3: Which ACID property is most important in banking?
A3: Atomicity, to ensure partial money transfers do not occur, preventing loss.

Q4: Difference between Atomicity and Consistency?
A4: 
- Atomicity = all-or-nothing execution of transaction steps.
- Consistency = database rules, constraints, and data validity maintained before and after transactions.

Q5: What happens if we don’t use transactions?
A5: Partial updates may occur leading to incorrect data, lost money, or inconsistent database state.

Q6: Explain Isolation levels in MySQL.
A6: Controls visibility of concurrent transactions:
- READ UNCOMMITTED
- READ COMMITTED
- REPEATABLE READ (default)
- SERIALIZABLE

Q7: What is dirty read / non-repeatable read / phantom read?
A7: 
- Dirty read: reading uncommitted changes from another transaction.
- Non-repeatable read: same row gives different results in one transaction.
- Phantom read: new rows appear in subsequent query within a transaction.

Q8: How to set isolation level in MySQL?
A8: SET TRANSACTION ISOLATION LEVEL <level>;

Q9: Default isolation level in MySQL?
A9: REPEATABLE READ

Q10: COMMIT vs ROLLBACK vs SAVEPOINT?
A10: 
- COMMIT = permanently save all changes in transaction.
- ROLLBACK = undo all changes in transaction.
- SAVEPOINT = set a point in transaction to rollback partially if needed.

Q11: How does Consistency prevent wrong data?
A11: By enforcing constraints (PRIMARY KEY, FOREIGN KEY, CHECK, NOT NULL) and business rules, ensuring database always remains valid.

Q12: Can Isolation levels affect Consistency?
A12: Yes. Higher isolation (SERIALIZABLE) prevents dirty/non-repeatable reads, ensuring data integrity under concurrent access.

Q13: Give example of Durability in real-life.
A13: After a money transfer is successful and committed, even if power fails, the balances remain correct and saved permanently.

Q14: What is Atomicity in simple terms?
A14: “All or nothing”: Either all steps of a transaction complete successfully or none at all, preventing partial changes.

Q15: How to test ACID properties practically?
A15: Use START TRANSACTION, simulate failure (invalid update, crash), check rollback (Atomicity), constraints (Consistency), multiple concurrent transactions (Isolation), and committed changes (Durability).
*/
