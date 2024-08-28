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


An entity relationship diagram (ERD) is a common way to view data in a database. It is also a key element to understanding how we can pull data from multiple tables.
-- A primary key (PK) exists in every table, and it is usually the first column (only one column) that has a unique value for every row. (For this database it is always called 'id')
-- A foreign key (FK) is a column in one table that is also a primary key in a different table. (They are linked; 'Primary - Foreign Key Link')

### Primary-Foreign Key Relationship
/*
Foreign keys are always linked to a primary key, and they are associated with the crow-foot notation above to show they can appear multiple times in a particular table.
*/

-- JOIN Revisited
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

Notice our SQL query has the two tables we'd like to join - one in the FROM and the other in the JOIN. Then in the ON, we will ALWAYs have the PK equal to the FK:
The way we join any two tables is in this way: linking the PK and FK (generally in an ON statement).
*Again the actual ordering of which table name goes first in this statement doesn't matter.

### JOIN more than two tables
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id

/* Q1
Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
Be sure to include the primary_poc, time of the event, and the channel for each event. 
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
*/
       
My Answer (CORRECT!):
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

/* Q2
Provide a table that provides the region for each sales_rep along with their associated accounts. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.
*/

My Answer (INCORRECT X):
SELECT r.name, s.name, a.name
FROM region AS r
JOIN sales_reps AS s
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
ORDER BY a.name;

SOLUTION:
SELECT r.name AS region, s.name AS rep, a.name AS account
FROM sales_reps AS s
JOIN region AS r
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
ORDER BY a.name;

REMARK: Should start with the common table (in FROM statement) that is in the middle out of the three tables; in this case it was 'sales_reps' table. 
       
/* Q3
Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
Your final table should have 3 columns: region name, account name, and unit price. 
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
*/

My Answer (INCORRECT):
SELECT r.name, a.name, unit_price
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
JOIN region AS r
ON s.region_id = r.id
WHERE (o.total_amt_usd / (o.total+0.01)) AS unit_price;

SOLUTION:
SELECT r.name AS region, a.name AS account, o.total_amt_usd/(o.total+0.01) AS unit_price
FROM regions AS r
JOIN sales_reps AS s
ON s.region_id = r.id
JOIN accounts AS a
ON a.sales_rep_id = s.id
JOIN orders AS o
ON o.account_id = a.id;

REMARK: 
1) For creating a column that derives from a calculation, no need to use a WHERE statement (simply just type in the formula in SELECT statement)
2) If joining more than 3 tables, start from the table that is mentioned first in the question (in this case, region).


### INNER JOIN (MOST COMMON)
Definition: Only return rows that appear in both tables. The inclusive part in the middle of a Venn Diagram. 

*There are other ways to join our data depending on the question we are asking.
### LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN
.
### LEFT JOIN & RIGHT JOIN
Refer to the lesson video here: https://learn.udacity.com/courses/ud198/lessons/61a9a6ad-3c2e-457a-ba5f-78d38d11b91a/concepts/c06af590-dcfc-40f9-a3f1-e929c2dcb8b9
       Main Idea: They allow us to pull rows that might only exist in one of the two tables. This will introduce a new data type called NULL. 
*Note: LEFT JOIN is used more commonly than RIGHT JOIN.




