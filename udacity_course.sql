-- Showing all columns
SELECT *
  FROM orders

-- Showing only the id, account_id, and occurred_at columns for all orders in the orders table
SELECT id, account_id, occurred_at
  FROM orders

### Limits
/*
Limiting the response to only the first 15 rows and includes the date, account_id, and channel fields in the web_event table. 
Note: usually LIMIT is put at the end of the query
*/
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;
