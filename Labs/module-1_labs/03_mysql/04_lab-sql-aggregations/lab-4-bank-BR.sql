# 1. From the client table, of all districts with a district_id lower than 10, 
# how many clients are from each district_id? Show the results sorted by district_id in ascending order.

SELECT 
    district_id,
    COUNT(*) AS clients
FROM client
WHERE district_id < 10
GROUP BY district_id
ORDER BY district_id;

# 2. From the card table, how many cards exist for each type? Rank the result starting with the most frequent type.

SELECT
    type, 
    COUNT(1) AS cards 
FROM card 
GROUP BY type
ORDER BY cards DESC;

# 3. Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.

SELECT 
    account_id,
    SUM(amount) AS total_amount
FROM bank.loan
GROUP BY account_id
ORDER BY total_amount DESC
LIMIT 10;

# 4. From the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order

SELECT
    date,
    COUNT(*) AS loans_issued
FROM loan
WHERE date < 930907
GROUP BY date
ORDER BY date DESC;

# 5. From the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, 
# ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.

SELECT 
    date,
    duration,
    COUNT(*) AS loans_issed
FROM loan
WHERE 
    date >= 971201
    AND date < 980101
GROUP BY 
    date,
    duration
ORDER BY 
    date,
    duration;
    
    # 6. From the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). 
    # Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
    
    SELECT
    account_id,
    type,
    SUM(amount) AS total_amount
FROM trans
WHERE account_id = 396
GROUP BY
    account_id,
    type
ORDER BY type;

# 7. From the previous output, translate the values for type to English, rename the column to transaction_type, 
# round total_amount down to an integer

SELECT
    account_id,
    IF(type = 'PRIJEM', 'INCOMING', 'OUTGOING') AS transaction_type,
    FLOOR(SUM(amount)) AS total_amount
FROM trans
WHERE account_id = 396
GROUP BY 1, 2
ORDER BY 2;

# 8. From the previous result, modify you query so that it returns only one row, 
# with a column for incoming amount, outgoing amount and the difference

SELECT
    account_id,
    FLOOR(SUM(IF(type = 'PRIJEM', amount, 0))) AS incoming_amount,
    FLOOR(SUM(IF(type = 'VYDAJ', amount, 0))) AS outgoing_amount,
    FLOOR(SUM(IF(type = 'PRIJEM', amount, 0))) - FLOOR(SUM(IF(type = 'VYDAJ', amount, 0))) AS difference
FROM trans
WHERE account_id = 396
GROUP BY 1;

# 9. Continuing with the previous example, rank the top 10 account_ids based on their difference

SELECT 
    account_id,
    FLOOR(SUM(IF(type = 'PRIJEM', amount, 0))) - FLOOR(SUM(IF(type = 'VYDAJ', amount, 0))) AS difference
FROM trans
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;