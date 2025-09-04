/* Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table. */

SELECT 
	id
FROM dev.orders
WHERE 
	gloss_qty > 4000 OR
	poster_qty > 4000;


/* Write a query that returns a list of orders where the standard_qty is zero 
and either the gloss_qty or poster_qty is over 1000. */

SELECT *
FROM dev.orders
WHERE 
	standard_qty = 0 AND 
	(gloss_qty > 1000 OR
	poster_qty > 1000);


/* Find all the company names that start with a 'C' or 'W', 
and where the primary contact contains 'ana' or 'Ana', 
but does not contain 'eana'. */

SELECT 
	id, 
	name, 
	primary_poc
FROM dev.accounts
WHERE
    (name LIKE 'C%' OR name LIKE 'W%')
    AND LOWER(primary_poc) LIKE '%ana%'
    AND LOWER(primary_poc) NOT LIKE '%eana%';

/* Provide a table that shows the region for each sales rep along with their associated accounts. 
Your final table should include three columns: the region name, 
the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) by account name. */

SELECT 
	s.name AS sales_rep_name, 
	r.name AS region_name, 
	a.name AS account_name
FROM dev.sales_reps s
JOIN dev.region r ON s.region_id=r.id
JOIN dev.accounts a ON s.id=a.sales_rep_id
ORDER BY account_name;