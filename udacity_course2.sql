Why do we see multi-table structure in SQL?
1. Orders and account tables store fundamentally different types of objects (different nature, different format).
2. This allows queries to execute more quickly. 

-- Database Normalization: When creating a database, it is really important to think about how data will be stored. This is known as normalization.

### JOINS 
-- The whole purpose of JOIN statements is to allow us to pull data from more than one table at a time. 
-- The JOIN clause is like a second FROM statement, indicating the second table.
-- The ON clause specifies a JOIN condition which is a logical statement to combine the table in FROM and JOIN statements. 
-- *(easier terms) It specifies the column on which you'd like to merge/link the two tables together.

Example:
SELECT orders.*,
       accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
Try pulling all the data from the accounts table, and all the data from the orders table.
*/
SELECT *  (or SELECT orders.*, accounts.*)
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

/*
Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
*/
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

