SELECT stores.stor_name, COUNT(DISTINCT(sales.ord_num)) AS Orders, COUNT(sales.title_id) AS Items, SUM(sales.qty) AS Qty
FROM sales
INNER JOIN stores
USING (stor_id)
GROUP BY stores.stor_name;

# Temp. Table created
CREATE TEMPORARY TABLE piblications.store_sales_summary
SELECT stores.stor_name, COUNT(DISTINCT(sales.ord_num)) AS Orders, COUNT(sales.title_id) AS Items, SUM(sales.qty) AS Qty
FROM sales
INNER JOIN stores
USING (stor_id)
GROUP BY stores.stor_name;

# Inspecting temporary table
SELECT *
FROM piblications.store_sales_summary;

#Referring to temp table
SELECT stor_name, Items/Orders AS AvgItems, QTY/Items
FROM piblications.store_sales_summary;

# Calculations based on Output, you need a temporary table
# Hold as long you are connected to SQL; lasts for a server session

#SUBQUERY: To combine two steps of temporary tables
SELECT stor_name, Items/Orders AS AvgItems, QTY/Items
FROM 
(SELECT stores.stor_name, COUNT(DISTINCT(sales.ord_num)) AS Orders, COUNT(sales.title_id) AS Items, SUM(sales.qty) AS Qty
	FROM sales
	INNER JOIN stores
	USING (stor_id)
	GROUP BY stores.stor_name) summary;