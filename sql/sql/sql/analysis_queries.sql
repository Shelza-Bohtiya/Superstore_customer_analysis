select TOP 10 * from orders$ 

--Q1-How many total records
SELECT COUNT(*) AS Total_Records from Orders$

--Q2-What date range does data cover?
SELECT MIN([Order Date]) AS earliest_date,
       MAX([Order Date]) AS latest_date
FROM Orders$

--Q3-How many unique customers?
select count(distinct [Customer ID]) as Total_customer from orders$

--Q4-Top 20 customers by revenue?

 select top 20 [customer id], round(sum(sales), 2) as Total_revenue, count(distinct([order id])) as Total_orders
 from Orders$
 group by [Customer ID]
 order by Total_revenue desc
 
 --observation --Top customer 25K+ in sales — classic 80/20 pattern likely


--Q4-Customer segmentation?
SELECT
  CASE
    WHEN total_orders = 1 THEN '1. One-time Customer'
    WHEN total_orders BETWEEN 2 AND 5 THEN '2. Regular Customer'
    WHEN total_orders BETWEEN 6 AND 10 THEN '3. Loyal Customer'
    ELSE '4. VIP Customer'
  END AS customer_segment,
  COUNT(*) AS customer_count
FROM (
  SELECT [Customer ID],
         COUNT(DISTINCT [Order ID]) AS total_orders
  FROM Orders$
  GROUP BY [Customer ID]
) AS customer_summary
GROUP BY
  CASE
    WHEN total_orders = 1 THEN '1. One-time Customer'
    WHEN total_orders BETWEEN 2 AND 5 THEN '2. Regular Customer'
    WHEN total_orders BETWEEN 6 AND 10 THEN '3. Loyal Customer'
    ELSE '4. VIP Customer'
  END
ORDER BY customer_segment 



--observation -58% customers are loyal — strong retention profile

--Order frequency range?
SELECT COUNT(DISTINCT [Order ID]) AS total_orders,
       [Customer ID]
FROM Orders$
GROUP BY [Customer ID]
ORDER BY total_orders ASC

--observation -Some VIP customers placed 17 orders — add 4th tier

--Run Query 8 — VIP Customers (High Value)
SELECT TOP 15
       [Customer Name],
       [Segment],
       COUNT(DISTINCT [Order ID])  AS total_orders,
       ROUND(SUM(Sales), 2)  AS total_revenue,
       ROUND(SUM(Sales) / 
         COUNT(DISTINCT [Order ID]), 2)  AS avg_order_value
FROM Orders$
GROUP BY [Customer ID], [Customer Name], [Segment]
HAVING COUNT(DISTINCT [Order ID]) >= 3
ORDER BY avg_order_value DESC

--year wise revenue trend

SELECT YEAR([Order Date])     AS order_year,
       ROUND(SUM(Sales), 2)   AS annual_revenue,
       COUNT(DISTINCT [Order ID])  AS total_orders
FROM Orders$
GROUP BY YEAR([Order Date])
ORDER BY order_year

--Revenue by region and category

SELECT Region,
       Category,
       ROUND(SUM(Sales), 2)     AS total_sales,
       ROUND(SUM(Profit), 2)    AS total_profit,
       ROUND(AVG(Discount), 3)  AS avg_discount
FROM Orders$
GROUP BY Region, Category
ORDER BY Region, total_sales DESC
