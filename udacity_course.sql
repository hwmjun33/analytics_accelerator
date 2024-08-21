-- Showing all columns
SELECT *
  FROM orders

-- Showing only the id, account_id, and occurred_at columns for all orders in the orders table
SELECT id, account_id, occurred_at
  FROM orders

  
### LIMIT (=show how many #)
/*
Limiting the response to only the first 15 rows and includes the date, account_id, and channel fields in the web_event table. 
Note: usually LIMIT is put at the end of the query
*/
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;


### ORDER BY (=sort)
/*
Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
*/
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

/*
Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC 
LIMIT 5;

/*
Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;


### ORDER BY 2
-- We can ORDER BY more than one column at a time. When you provide a list of columns in an ORDER BY command, 
-- the sorting occurs using the leftmost column in your list first, then the next column from the left, and so on. 

/*
Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), 
and then by the total dollar amount (in descending order).
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC 

/*
Write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), 
and then by account ID (in ascending order).
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id

  
### WHERE (=set conditions) *NUMERIC*
-- Using the WHERE statement, we can display subsets of tables based on CONDITIONS that must be met. You can also think of the WHERE command as filtering the data.
-- Comparison operators used: >, <, >=, <=, =, != 

/*
Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
*/
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*
Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
*/
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

-- Note: When using these WHERE statements, we do not need to ORDER BY unless we want to actually order our data. 
-- Our condition will work without having to do any sorting of the data.


### WHERE 2 (=set conditions) *NON-NUMERIC*
-- The WHERE statement can also be used with non-numeric data. We can use the = and != operators here. 
-- You need to be sure to use single quotes (just be careful if you have quotes in the original text) with the text data, not double quotes.
-- Note: Commonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators. 

/*
Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';


### Arithmetic Operations (+,-,*,/)

Derived Columns
-- Creating a new column that is a combination of existing columns is known as a Derived Column (or "calculated" or "computed" column). 
-- Usually you want to give a name, or "alias," to your new column using the AS keyword.
-- This derived column, and its alias, are generally only temporary, existing just for the duration of your query.
-- The next time you run a query and access this table, the new column will not be there.

-- If you are deriving the new column from existing columns using a mathematical expression, then these familiar mathematical operators will be useful:
* (Multiplication)
+ (Addition)
- (Subtraction)
/ (Division)

Consider this example:
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

-- Here we divide the standard paper dollar amount by the total order amount to find the standard paper percent for the order, 
-- and use the AS keyword to name this new column "std_percent."

/*
Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. 
Limit the results to the first 10 orders, and include the id and account_id fields.
*/

SELECT id, account_id, (standard_amt_usd/standard_qty) AS unit_price
FROM orders
LIMIT 10;

/*
Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd.
(Try to do this without using the total column.) Display the id and account_id fields also. 
*/

SELECT id, account_id,
       poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd)*100 AS post_percentage
FROM orders
LIMIT 10;


### LOGICAL OPERATORS (LIKE, IN, NOT, AND&BETWEEN, OR)
-- LIKE This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
-- IN This allows you to perform operations similar to using WHERE and =, but for more than one condition.
-- NOT This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.
-- AND & BETWEEN These allow you to combine operations where all combined conditions must be true.
-- OR This allows you to combine operations where at least one of the combined conditions must be true.

### LIKE
-- The LIKE operator is extremely useful for working with text. You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %. 
-- The % tells us that we might want any number of characters leading up to a particular set of characters or following a certain set of characters, 
-- as we saw with the google syntax above. Remember you will need to use single quotes for the text you pass to the LIKE operator, 
-- because of this lower and uppercase letters are not the same within the string. Searching for 'T' is not the same as searching for 't'. 

/*
Use the accounts table to find:
- All the companies whose names start with 'C'.
- All companies whose names contain the string 'one' somewhere in the name.
- All companies whose names end with 's'.
*/

SELECT name
FROM accounts
WHERE name LIKE 'C%';

SELECT name
FROM accounts
WHERE name LIKE '%one%';

SELECT name
FROM accounts
WHERE name LIKE '%s';


### IN
-- The IN operator is useful for working with both numeric and text columns. This operator allows you to use an =, but for more than one item of that particular column. 
-- We can check one, two or many column values for which we want to pull data, but all within the same query. 
-- Differences between '=' and 'IN': 
    -- The '=' operator is used for exact equality comparison. It compares a column or expression to a single value.
    -- The 'IN' operator allows you to specify multiple values in a WHERE clause. It's essentially a shorthand for multiple OR conditions.  
-- In the upcoming concepts, you will see the OR operator that would also allow us to perform these tasks, but the IN operator is a cleaner way to write these queries.
e.g. SELECT * FROM Orders WHERE Status = 'Shipped' OR Status = 'Delivered';
     SELECT * FROM Orders WHERE Status IN ('Shipped', 'Delivered');

/*
Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

/*
Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
*/

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

