
-- =====================================================
-- PL/SQL Window Functions Project - Complete Analytics
-- Student: Muhanguzi Boss
-- Student ID: 27810
-- Business: KFC Rwanda
-- Course: Database Development with PL/SQL (INSY 8311)
-- =====================================================

-- =====================================================
-- SECTION 1: RANKING FUNCTIONS
-- Success Criteria 1: Top 5 products per outlet using RANK()
-- =====================================================

-- SCREENSHOT 3: ROW_NUMBER() Results
-- Product ranking within each outlet using ROW_NUMBER()
SELECT 
    o.branch_name,
    p.name as product_name,
    p.category,
    SUM(t.amount) as total_sales,
    ROW_NUMBER() OVER (PARTITION BY o.branch_name ORDER BY SUM(t.amount) DESC) as row_num
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN outlets o ON t.branch_id = o.branch_id
GROUP BY o.branch_name, p.name, p.category
ORDER BY o.branch_name, row_num;

-- SCREENSHOT 4: RANK vs DENSE_RANK Comparison
-- Compare RANK() and DENSE_RANK() for tied sales values
SELECT 
    o.branch_name,
    p.name as product_name,
    SUM(t.amount) as total_sales,
    RANK() OVER (PARTITION BY o.branch_name ORDER BY SUM(t.amount) DESC) as rank_with_gaps,
    DENSE_RANK() OVER (PARTITION BY o.branch_name ORDER BY SUM(t.amount) DESC) as dense_rank_no_gaps
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN outlets o ON t.branch_id = o.branch_id
GROUP BY o.branch_name, p.name
ORDER BY o.branch_name, total_sales DESC;

-- SCREENSHOT 5: PERCENT_RANK Analysis
-- Percentile ranking of products by sales performance
SELECT 
    p.name as product_name,
    p.category,
    SUM(t.amount) as total_sales,
    PERCENT_RANK() OVER (ORDER BY SUM(t.amount) DESC) as percentile_rank,
    ROUND(PERCENT_RANK() OVER (ORDER BY SUM(t.amount) DESC) * 100, 2) as percentile_percentage
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.name, p.category
ORDER BY total_sales DESC;

-- =====================================================
-- SECTION 2: AGGREGATE FUNCTIONS  
-- Success Criteria 2: Running monthly sales totals using SUM() OVER()
-- =====================================================

-- SCREENSHOT 6: Running Totals
-- Running total of sales by month across all outlets
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
    SUM(amount) as monthly_sales,
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS UNBOUNDED PRECEDING) as running_total
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sales_month;

-- SCREENSHOT 7: ROWS vs RANGE Frame Comparison
-- Compare ROWS and RANGE frame specifications
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
    SUM(amount) as monthly_sales,
    -- Using ROWS frame
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS 2 PRECEDING) as sum_rows_frame,
    -- Using RANGE frame  
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') RANGE UNBOUNDED PRECEDING) as sum_range_frame,
    AVG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS 2 PRECEDING) as avg_3month_rows
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sales_month;

-- SCREENSHOT 8: Moving Averages (Success Criteria 5)
-- 3-month moving average of sales
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
    SUM(amount) as monthly_sales,
    AVG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS 2 PRECEDING) as moving_avg_3months,
    MIN(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS 2 PRECEDING) as min_3months,
    MAX(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS 2 PRECEDING) as max_3months
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sales_month;

-- =====================================================
-- SECTION 3: NAVIGATION FUNCTIONS
-- Success Criteria 3: Month-over-month growth using LAG()/LEAD()
-- =====================================================

-- SCREENSHOT 9: LAG() Previous Month
-- Compare current month with previous month
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
    SUM(amount) as current_month_sales,
    LAG(SUM(amount), 1) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as previous_month_sales,
    LAG(SUM(amount), 2) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as two_months_ago
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sales_month;

-- SCREENSHOT 10: LEAD() Future Analysis
-- Look ahead to next month's sales
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
    SUM(amount) as current_month_sales,
    LEAD(SUM(amount), 1) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as next_month_sales,
    LEAD(SUM(amount), 2) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as two_months_ahead
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sales_month;

-- SCREENSHOT 11: Growth Percentages
-- Calculate month-over-month growth percentages
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
    SUM(amount) as current_sales,
    LAG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as previous_sales,
    ROUND(
        (SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM'))) / 
        LAG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) * 100, 2
    ) as growth_percentage
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sales_month;

-- =====================================================
-- SECTION 4: DISTRIBUTION FUNCTIONS
-- Success Criteria 4: Customer quartiles using NTILE(4)
-- =====================================================

-- SCREENSHOT 12: Customer Quartiles (NTILE)
-- Segment customers into 4 spending quartiles
SELECT 
    c.customer_id,
    c.name,
    c.region,
    SUM(t.amount) as total_spending,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) as spending_quartile
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_spending DESC;

-- SCREENSHOT 13: Customer Cumulative Distribution
-- Show cumulative distribution of customer spending
SELECT 
    c.customer_id,
    c.name,
    SUM(t.amount) as total_spending,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) as quartile,
    CUME_DIST() OVER (ORDER BY SUM(t.amount) DESC) as cumulative_dist,
    ROUND(CUME_DIST() OVER (ORDER BY SUM(t.amount) DESC) * 100, 2) as percentile
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spending DESC;

-- SCREENSHOT 14: Customer Segment Labels
-- Add meaningful labels to customer segments
SELECT 
    customer_id,
    name,
    region,
    total_spending,
    quartile,
    CASE quartile
        WHEN 1 THEN 'VIP Customer'
        WHEN 2 THEN 'High Value Customer'
        WHEN 3 THEN 'Regular Customer'
        WHEN 4 THEN 'Price-Sensitive Customer'
    END as segment_label
FROM (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) as total_spending,
        NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) as quartile
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
ORDER BY total_spending DESC;

-- =====================================================
-- SECTION 5: ADVANCED WINDOW FUNCTIONS
-- Additional screenshots for comprehensive analysis
-- =====================================================

-- SCREENSHOT 15: FIRST_VALUE() and LAST_VALUE() Navigation Functions
-- Show first and last sales values in each branch
SELECT 
    o.branch_name,
    TO_CHAR(t.sale_date, 'YYYY-MM') as sales_month,
    SUM(t.amount) as monthly_sales,
    FIRST_VALUE(SUM(t.amount)) OVER (
        PARTITION BY o.branch_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS UNBOUNDED PRECEDING
    ) as first_month_sales,
    LAST_VALUE(SUM(t.amount)) OVER (
        PARTITION BY o.branch_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_month_sales
FROM transactions t
JOIN outlets o ON t.branch_id = o.branch_id
GROUP BY o.branch_name, TO_CHAR(t.sale_date, 'YYYY-MM')
ORDER BY o.branch_name, sales_month;

-- SCREENSHOT 16: Advanced Ranking with Ties Handling
-- Show how tied sales are handled differently by RANK functions
SELECT 
    p.name as product_name,
    o.branch_name,
    SUM(t.amount) as total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(t.amount) DESC) as row_number,
    RANK() OVER (ORDER BY SUM(t.amount) DESC) as rank_ties,
    DENSE_RANK() OVER (ORDER BY SUM(t.amount) DESC) as dense_rank_ties,
    CASE 
        WHEN RANK() OVER (ORDER BY SUM(t.amount) DESC) != DENSE_RANK() OVER (ORDER BY SUM(t.amount) DESC)
        THEN 'Has Ties'
        ELSE 'No Ties'
    END as tie_indicator
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN outlets o ON t.branch_id = o.branch_id
GROUP BY p.name, o.branch_name
ORDER BY total_sales DESC;

-- SCREENSHOT 17: Window Frame Variations
-- Demonstrate different frame specifications
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as month,
    SUM(amount) as monthly_total,
    -- Different frame specifications
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS UNBOUNDED PRECEDING) as cumulative_sum,
    AVG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS 1 PRECEDING) as two_month_avg,
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as three_month_sum,
    AVG(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as avg_to_date
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;

-- SCREENSHOT 18: Advanced Customer Analytics
-- Multi-level customer analysis
SELECT 
    c.name,
    c.region,
    COUNT(t.transaction_id) as transaction_count,
    SUM(t.amount) as total_spending,
    AVG(t.amount) as avg_transaction,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) as spending_quartile,
    NTILE(4) OVER (ORDER BY COUNT(t.transaction_id) DESC) as frequency_quartile,
    RANK() OVER (ORDER BY SUM(t.amount) DESC) as spending_rank,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) = 1 THEN 'VIP'
        WHEN NTILE(4) OVER (ORDER BY COUNT(t.transaction_id) DESC) <= 2 THEN 'Frequent'
        ELSE 'Regular'
    END as customer_type
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_spending DESC;

-- SCREENSHOT 19: Product Performance Matrix
-- Products across all outlets with ranking
SELECT 
    p.name as product_name,
    p.category,
    COUNT(t.transaction_id) as total_transactions,
    SUM(t.quantity) as total_quantity_sold,
    SUM(t.amount) as total_revenue,
    RANK() OVER (ORDER BY SUM(t.amount) DESC) as revenue_rank,
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(t.amount) DESC) as category_rank,
    ROUND(SUM(t.amount) / SUM(SUM(t.amount)) OVER () * 100, 2) as revenue_percentage
FROM products p
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.product_id, p.name, p.category
ORDER BY total_revenue DESC;

-- SCREENSHOT 20: Business Intelligence Summary
-- Executive dashboard combining multiple metrics
SELECT 
    'KFC Rwanda Performance Summary' as report_title,
    COUNT(DISTINCT o.branch_id) as total_outlets,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT p.product_id) as total_products,
    COUNT(t.transaction_id) as total_transactions,
    SUM(t.amount) as total_revenue,
    AVG(t.amount) as avg_transaction_value,
    MAX(t.amount) as highest_transaction,
    MIN(t.sale_date) as first_sale_date,
    MAX(t.sale_date) as latest_sale_date
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN products p ON t.product_id = p.product_id
JOIN outlets o ON t.branch_id = o.branch_id;

-- SCREENSHOT 21: Top 5 Products per Outlet (Final Success Criteria)
-- The key query that fulfills Success Criteria 1
SELECT 
    branch_name,
    product_name,
    category,
    total_sales,
    outlet_rank
FROM (
    SELECT 
        o.branch_name,
        p.name as product_name,
        p.category,
        SUM(t.amount) as total_sales,
        RANK() OVER (PARTITION BY o.branch_name ORDER BY SUM(t.amount) DESC) as outlet_rank
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    JOIN outlets o ON t.branch_id = o.branch_id
    GROUP BY o.branch_name
