#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#

## Que_1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales. ##
# PART_1 #
SELECT 
    sr.name AS Rep_Name,
    r.name AS Reg_Name,
    SUM(o.total_amt_usd) AS Total_Amt
FROM
    sales_reps AS sr
        JOIN
    accounts AS a ON a.Sales_Rep_ID = sr.ID
        JOIN
    orders AS o ON o.Account_ID = a.ID
        JOIN
    region AS r ON r.ID = sr.Region_ID
GROUP BY 1 , 2
ORDER BY 3 DESC;

# PART_2 #
SELECT 
    Reg_Name, MAX(Total_Amt) AS Total_Amt
FROM
    (SELECT 
        sr.name AS Rep_Name,
            r.name AS Reg_Name,
            SUM(o.total_amt_usd) AS Total_Amt
    FROM
        sales_reps AS sr
    JOIN accounts AS a ON a.Sales_Rep_ID = sr.ID
    JOIN orders AS o ON o.Account_ID = a.ID
    JOIN region AS r ON r.ID = sr.Region_ID
    GROUP BY 1 , 2) AS T1
GROUP BY 1;

# PART_3 #
SELECT 
    T3.Rep_Name, T3.Reg_Name, T3.Total_Amt
FROM
    (SELECT 
        Reg_Name, MAX(Total_Amt) AS Total_Amt
    FROM
        (SELECT 
        sr.name AS Rep_Name,
            r.name AS Reg_Name,
            SUM(o.total_amt_usd) AS Total_Amt
    FROM
        sales_reps AS sr
    JOIN accounts AS a ON a.Sales_Rep_ID = sr.ID
    JOIN orders AS o ON o.Account_ID = a.ID
    JOIN region AS r ON r.ID = sr.Region_ID
    GROUP BY 1 , 2) AS T1
    GROUP BY 1) AS T2
        JOIN
    (SELECT 
        sr.name AS Rep_Name,
            r.name AS Reg_Name,
            SUM(o.total_amt_usd) AS Total_Amt
    FROM
        sales_reps AS sr
    JOIN accounts AS a ON a.Sales_Rep_ID = sr.ID
    JOIN orders AS o ON o.Account_ID = a.ID
    JOIN region AS r ON r.ID = sr.Region_ID
    GROUP BY 1, 2
    ORDER BY 3 DESC) AS T3 
    ON T3.Reg_Name = T2.Reg_Name
        AND T3.Total_Amt = T2.Total_Amt;
#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#

## Que_2. For the region with the largest sales total_amt_usd, how many total orders were placed? ##
# PART_1 #
SELECT 
    r.name AS Reg_Name, SUM(o.total_amt_usd) AS Total_Amt
FROM
    sales_reps AS sr
        JOIN
    accounts AS a ON sr.ID = a.Sales_Rep_ID
        JOIN
    orders AS o ON a.ID = o.Account_ID
        JOIN
    region AS r ON sr.Region_ID = r.ID
GROUP BY 1;

# PART_2 #
SELECT 
    MAX(Total_Amt)
FROM
    (SELECT 
        r.name AS Reg_Name, SUM(o.total_amt_usd) AS Total_Amt
    FROM
        sales_reps AS sr
    JOIN accounts AS a ON sr.ID = a.Sales_Rep_ID
    JOIN orders AS o ON a.ID = o.Account_ID
    JOIN region AS r ON sr.Region_ID = r.ID
    GROUP BY 1) AS SUB;
    
    # PART_3 #
SELECT 
    r.name AS Reg_Name, COUNT(o.total) AS Total_Orders
FROM
    sales_reps AS sr
        JOIN
    accounts AS a ON sr.ID = a.Sales_Rep_ID
        JOIN
    orders AS o ON a.ID = o.Account_ID
        JOIN
    region AS r ON sr.Region_ID = r.ID
GROUP BY 1
HAVING SUM(o.Total_Amt_USD) = (SELECT 
        MAX(Total_Amt)
    FROM
        (SELECT 
            r.name AS Reg_Name, SUM(o.total_amt_usd) AS Total_Amt
        FROM
            sales_reps AS sr
        JOIN accounts AS a ON sr.ID = a.Sales_Rep_ID
        JOIN orders AS o ON a.ID = o.Account_ID
        JOIN region AS r ON sr.Region_ID = r.ID
        GROUP BY 1) AS SUB);	
#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#
    
## Que_3: How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer? ##
# PART_1 #
SELECT 
    a.Name AS Acc_Name,
    SUM(o.Standard_Qty) AS Tot_Std,
    SUM(o.total) AS Tot_Qty
FROM
    accounts AS a
        JOIN
    orders AS o ON a.ID = o.Account_ID
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

# PART_2 #
SELECT 
    a.Name AS Acc_Name
FROM
    orders AS o
        JOIN
    accounts AS a ON o.Account_ID = a.ID
GROUP BY 1
HAVING SUM(o.Total) > (SELECT 
        Tot_Qty
    FROM
        (SELECT 
            a.Name AS Acc_Name,
                SUM(o.Standard_Qty) AS Tot_Std,
                SUM(o.total) AS Tot_Qty
        FROM
            accounts AS a
        JOIN orders AS o ON a.ID = o.Account_ID
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1) SUB);
        
## PART_3 ##
SELECT COUNT(*)
FROM (SELECT a.Name
       FROM orders o
       JOIN accounts a
       ON a.ID = o.Account_ID
       GROUP BY 1
       HAVING SUM(o.Total) > (SELECT Tot_Qty 
                   FROM (SELECT a.Name AS Acc_Name, SUM(o.standard_qty) AS Tot_Std, SUM(o.total) AS Tot_Qty
                         FROM accounts AS a
                         JOIN orders AS o
                         ON o.Account_ID = a.ID
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;
#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#

## Que_4: For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel? ##
# PART_1 #
SELECT 
    a.ID, a.Name, SUM(o.Total_Amt_USD) AS Tot_Spent
FROM
    orders AS o
        JOIN
    accounts AS a ON o.Account_ID = a.ID
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

# PART_2 #
SELECT 
    a.Name, we.Channel, COUNT(*)
FROM accounts AS a
JOIN web_events AS we 
ON a.ID = we.Account_ID
and a.ID = (select a.ID from (SELECT a.ID, a.Name, SUM(o.Total_Amt_USD) AS Tot_Spent
			FROM orders AS o
			JOIN accounts AS a ON o.Account_ID = a.ID
			GROUP BY a.ID, a.Name
			ORDER BY 3 DESC
			LIMIT 1) inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;
#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#

## Que_5: What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? ##
# PART_1 #
SELECT 
    a.ID, a.Name, SUM(o.Total_Amt_USD) AS Tot_Spent
FROM
    orders AS o
        JOIN
    accounts AS a ON o.Account_ID = a.ID
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 10;

# PART_2 #
SELECT 
    AVG(Tot_Spent)
FROM
    (SELECT 
        a.ID, a.Name, SUM(o.Total_Amt_USD) AS Tot_Spent
    FROM
        orders AS o
    JOIN accounts AS a ON o.Account_ID = a.ID
    GROUP BY 1 , 2
    ORDER BY 3 DESC
    LIMIT 10) temp;
#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#--#

## Que_6: What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders. ##
# PART_1 #
SELECT 
    AVG(o.Total_Amt_USD) AS Avg_All
FROM
    orders AS o;
    
# PART_2: #
SELECT 
    o.Account_ID, AVG(o.Total_Amt_USD)
FROM
    orders AS o
GROUP BY 1
HAVING AVG(o.Total_Amt_USD) > (SELECT 
        AVG(o.Total_Amt_USD) AS Avg_All
    FROM
        orders AS o);
        
# PART_3: #
SELECT 
    AVG(Avg_Amt)
FROM
    (SELECT 
        o.Account_ID, AVG(o.total_amt_usd) as Avg_Amt
    FROM
        orders AS o
    GROUP BY 1
    HAVING AVG(o.Total_Amt_USD) > (SELECT 
            AVG(o.Total_Amt_USD) AS Avg_All
        FROM
            orders AS o)) temp_table;