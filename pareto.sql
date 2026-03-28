-- 1. Base table (you already have this)
-- CREATE TABLE pet_shop_sales (...);   ← assuming it's already created

-- Optional: If the table is empty → add test data (uncomment if needed)
-- INSERT INTO pet_shop_sales VALUES ...;

-- 2. Clean line-level view (with calculated sales per row)
CREATE OR REPLACE VIEW v_sales_lines AS
SELECT
    CustomerID,
    Quantity * UnitPrice AS line_sales,
    Country
FROM pet_shop_sales
WHERE Quantity > 0
  AND UnitPrice >= 0;
Select * from v_sales_lines

-- 3. Revenue per customer
CREATE OR REPLACE VIEW v_customer_revenue AS
SELECT
    CustomerID,
    SUM(line_sales) AS customer_revenue
FROM v_sales_lines
GROUP BY CustomerID
HAVING SUM(line_sales) > 0
ORDER BY customer_revenue DESC;

-- 4. Pareto ranking + cumulative values
CREATE OR REPLACE VIEW v_pareto_ranked AS
SELECT
    CustomerID,
    customer_revenue,
    
    ROW_NUMBER() OVER (ORDER BY customer_revenue DESC)              AS cum_customers,
    COUNT(*)     OVER ()                                            AS total_customers,
    
    SUM(customer_revenue) OVER (
        ORDER BY customer_revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                               AS cum_revenue,
    
    SUM(customer_revenue) OVER ()                                   AS total_revenue
    
FROM v_customer_revenue;

-- 5. Final formatted Pareto view (percentages + clean names)
CREATE OR REPLACE VIEW pareto_final AS
SELECT
    CustomerID,
    customer_revenue,
    cum_customers,
    total_customers,
    
    ROUND(cum_revenue, 2)                                           AS cum_revenue,
    ROUND(total_revenue, 2)                                         AS total_revenue,
    
    ROUND(100.0 * cum_revenue / total_revenue, 2)                   AS cum_sales_share_pct,
    ROUND(100.0 * cum_customers::numeric / total_customers, 2)      AS cum_customers_pct
    
FROM v_pareto_ranked
ORDER BY cum_customers;

-- 6. The 80/20 question: How many customers generate at least 80% of revenue?
SELECT
    MIN(cum_customers)               AS customers_needed_for_80pct,
    MIN(total_customers)             AS total_customers,
    ROUND(MIN(cum_revenue), 2)       AS revenue_from_those_customers,
    ROUND(MIN(total_revenue), 2)     AS total_revenue,
    80.0                             AS target_sales_percent,
    ROUND(MIN(total_revenue) * 0.8, 2) AS target_80pct_amount,
    ROUND(MIN(cum_sales_share_pct), 2) AS actual_cum_pct_at_this_point,
    ROUND(MIN(cum_customers_pct), 2)   AS customer_pct_at_this_point
FROM pareto_final
WHERE cum_sales_share_pct >= 80
LIMIT 1;