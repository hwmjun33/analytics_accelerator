### NULLS
-- Defintion: NULLS are not zero; they are cells where data does not exist.
-- When identifying NULLS in a WHERE clause, we write IS NULL or IS NOT NULL. (We don't use = because NULL is not a value in SQL)
-- NULLS often occur when performing a LEFT OR RIGHT JOIN as we saw in previous lessons when certain rows in the left table of a left join 
-- are not matched with rows in the right table; NULLS can also occur from simply missing data in our database.

e.g. choose a column to drop into the aggregation function of COUNT
SELECT COUNT(accounts.id)
FROM accounts;

OUTPUT: 351

/* The Count function is just looking at NON-NULL data, meaning it does not count rows that have NULL values. */

e.g.(2)
SELECT COUNT(primary_poc) AS account_primary_poc_count
FROM demo.accounts

OUTPUT: 345 
-- Note: There are 9 rows with null data so 351 - 9 = 345.

  
### SUM
-- Unlike COUNT, SUM can only be used on numeric columns. But SUM will ignore NULL values, treating them as 0. 

/*
Aggregation Questions
Use the SQL environment below to find the solution for each of the following questions. If you get stuck or want to check your answers, you can find the answers at the top of the next concept.
1. Find the total amount of poster_qty paper ordered in the orders table.
2. Find the total amount of standard_qty paper ordered in the orders table.
3. Find the total dollar amount of sales using the total_amt_usd in the orders table.
4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
*/

SOLUTIONS
1. 
SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;
/* OUTPUT:
sum
723646
*/

2. 
SELECT SUM(standard_qty) AS total_standard_sales
FROM orders;
/* OUTPUT:
sum
1938346
*/

3.
SELECT SUM(total_amt_usd) AS total_dollar_sales
FROM orders;
/* OUTPUT:
sum
23141511.83
*/

4.
SELECT standard_amt_usd standard, gloss_amt_usd gloss, (standard_amt_usd + gloss_amt_usd) total_standard_gloss
FROM orders;
/* OUTPUT:
standard	gloss	total
613.77	164.78	778.55
...
*/

5.
SELECT SUM(standard_amt_usd) AS total_amount,
SUM(standard_qty) AS total_quantity,
SUM(standard_amt_usd) / SUM(standard_qty) AS standard_price_per_unit
FROM orders;
/* OUTPUT:
total_amount	total_quantity	per_unit
9672346.54	  1938346	        4.9900000000000000
*/


### MIN & MAX
/* MIN and MAX are similar to COUNT in that they can be used on non-numerical columns. Depending on the column type, MIN will return the
lowest number, earliest date, or non-numerical value as early in the alphabet as possible. MAX does the opposite with returning the 
highest number, the latest date, or the non-numerical vaue closest alphabetically to "Z". */


### AVG
/* AVG returns the mean of the data. This aggregate function ignores the NULL values in both the numerator and denominator. 
Also it can only be used on numerical columns. And it ignores NULL values completely, meaning that rows with null values are not 
counted. So if you want to treat NULLs as zero, you'll need to take a SUM and divide it by COUNT, rather than just using the average
function. */

/*
Questions: MIN, MAX, & AVERAGE
Use the SQL environment below to find the solution for each of the following questions. If you get stuck or want to check your answers, you can find the answers at the top of the next concept.
1. When was the earliest order ever placed? You only need to return the date.
2. Try performing the same query as in question 1 without using an aggregation function.
3. When did the most recent (latest) web_event occur?
4. Try to perform the result of the previous query without using an aggregation function.
5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
6. Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far 
try finding - what is the MEDIAN total_usd spent on all orders?
*/

SOLUTIONS
1.
SELECT MIN(occurred_at)
FROM orders;

2. 
SELECT occurred_at
FROM orders
ORDER BY occurred_at 
LIMIT 1;

3.
SELECT MAX(occurred_at)
FROM web_events;

4. 
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

5.
SELECT 
AVG(standard_amt_usd) AS standard_amt_avg,
AVG(gloss_amt_usd) AS gloss_amt_avg,
AVG(poster_amt_usd) AS poster_amt_avg,
AVG(standard_qty) AS standard_qty_avg,
AVG(gloss_qty)AS gloss_qty_avg,
AVG(poster_qty) AS poster_qty_avg
FROM orders;

6. 
SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/* Explanation: Since there are 6912 orders - we want the average of the 3457th and 3456th order amounts when ordered, which is the 
average of 2483.16 and 2482.55. This gives the median of 2482.855. 
This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit. 
SQL didn't even calculate the median for us. 
The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them.
*/


### GROUP BY
-- The order of column names in your GORUP BY clause doesn't matter--the results will be the same regardless. 
-- Any column that is not within an aggregation must show up in your GROUP BY statement.
*See SQL Practice Group By Exercise on Google Doc

  
### DISTINCT
-- DISTINCT is always used in SELECT statements, and it provides the unique rows for all columns written in the SELECT statement. 
-- Therefore, you only use DISTINCT once in any particular SELECT statement.

e.g.
SELECT DISTINCT column1, column2, column3
FROM table1;

*This would return the unique (or DISTINCT) rows across all three columns.

/* Practice 
Q1. Use DISTINCT to test if there are any accounts associated with more than one region.
*/
My Attempt:
SELECT a.name, COUNT(DISTINCT r.id) as region_count
FROM sales_reps s
JOIN region r
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY a.name
HAVING COUNT(DISTINCT r.id) > 1;

/* 
Q2. Have any sales reps worked on more than one account?
*/
My Attempt (X)
SELECT s.name sales_reps, COUNT(DISTINCT a.id) account_count
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name;

SOLUTION:
SELECT s.id, s.name, COUNT(*) number_accounts
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
ORDER BY number_accounts;

*This one is to check number of unique sales reps.
SELECT DISTINCT id, name
FROM sales_reps;


### HAVING
-- Any time you want to perform a WHERE function on an element of your query that was created by an aggregate, 
-- you need to use HAVING instead.
*Note: WHERE cannot filter on aggregate columns!


