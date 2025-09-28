
-- =====================================================
-- PL/SQL Window Functions Project - Sample Data Insertion
-- Student: Muhanguzi Boss
-- Student ID: 27810
-- Business: KFC Rwanda
-- Course: Database Development with PL/SQL (INSY 8311)
-- =====================================================

-- SCREENSHOT 2: Sample Data Insertion and Verification

-- Insert KFC Rwanda outlets
INSERT INTO outlets (branch_id, branch_name, location, manager_name) VALUES
(101, 'KFC Kigali City Center', 'City Center, Kigali', 'John Ndayisaba');

INSERT INTO outlets (branch_id, branch_name, location, manager_name) VALUES
(102, 'KFC Remera', 'Remera, Gasabo', 'Marie Uwimana');

INSERT INTO outlets (branch_id, branch_name, location, manager_name) VALUES
(103, 'KFC Nyamirambo', 'Nyamirambo, Nyarugenge', 'Paul Mugisha');

-- Insert KFC menu products
INSERT INTO products (product_id, name, category, unit_price) VALUES
(2001, 'Zinger Burger', 'Burger', 5500);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2002, 'Original Recipe Chicken', 'Chicken', 3200);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2003, 'Hot & Crispy Chicken', 'Chicken', 3500);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2004, 'Family Feast Bucket', 'Chicken', 18000);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2005, 'Colonel Burger', 'Burger', 4800);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2006, 'Large Fries', 'Sides', 2200);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2007, 'Pepsi 500ml', 'Beverages', 1500);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2008, 'Coleslaw', 'Sides', 1800);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2009, 'Krushems Milkshake', 'Beverages', 3200);

INSERT INTO products (product_id, name, category, unit_price) VALUES
(2010, '6pc Hot Wings', 'Chicken', 4200);

-- Insert customers across different Kigali regions
INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1001, 'Alice Uwase', 'Kigali', '078-123-4567', DATE '2024-01-15');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1002, 'Jean Baptiste Nkurunziza', 'Gasabo', '078-234-5678', DATE '2024-01-20');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1003, 'Grace Mukamana', 'Nyarugenge', '078-345-6789', DATE '2024-02-10');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1004, 'David Habimana', 'Kicukiro', '078-456-7890', DATE '2024-02-15');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1005, 'Sarah Ingabire', 'Kigali', '078-567-8901', DATE '2024-03-01');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1006, 'Emmanuel Bizimana', 'Gasabo', '078-678-9012', DATE '2024-03-10');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1007, 'Immaculée Nyiramana', 'Nyarugenge', '078-789-0123', DATE '2024-03-20');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1008, 'Patrick Uwizeyimana', 'Kicukiro', '078-890-1234', DATE '2024-04-05');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1009, 'Claudine Uwimana', 'Kigali', '078-901-2345', DATE '2024-04-15');

INSERT INTO customers (customer_id, name, region, phone, registration_date) VALUES
(1010, 'Robert Nzeyimana', 'Gasabo', '078-012-3456', DATE '2024-05-01');

-- Insert sample transactions (January to September 2024)
-- High volume transactions for analysis

-- January 2024 transactions
INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3001, 1001, 2001, 101, DATE '2024-01-15', 2, 11000);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3002, 1002, 2004, 102, DATE '2024-01-20', 1, 18000);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3003, 1003, 2002, 103, DATE '2024-01-25', 3, 9600);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3004, 1004, 2005, 101, DATE '2024-01-30', 1, 4800);

-- February 2024 transactions
INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3005, 1005, 2003, 102, DATE '2024-02-10', 2, 7000);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3006, 1006, 2010, 103, DATE '2024-02-15', 1, 4200);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3007, 1007, 2001, 101, DATE '2024-02-20', 3, 16500);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3008, 1008, 2004, 102, DATE '2024-02-25', 1, 18000);

-- March 2024 transactions
INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3009, 1009, 2002, 103, DATE '2024-03-01', 4, 12800);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3010, 1010, 2005, 101, DATE '2024-03-05', 2, 9600);

-- Continue with more months for comprehensive analysis
-- April transactions
INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3011, 1001, 2004, 101, DATE '2024-04-10', 1, 18000);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3012, 1002, 2001, 102, DATE '2024-04-15', 2, 11000);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3013, 1003, 2003, 103, DATE '2024-04-20', 3, 10500);

-- May transactions
INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3014, 1004, 2010, 101, DATE '2024-05-01', 2, 8400);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3015, 1005, 2002, 102, DATE '2024-05-15', 3, 9600);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3016, 1006, 2005, 103, DATE '2024-05-20', 1, 4800);

-- Additional high-value transactions for better analytics
INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3017, 1007, 2004, 101, DATE '2024-06-01', 2, 36000);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3018, 1008, 2001, 102, DATE '2024-06-10', 4, 22000);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3019, 1009, 2003, 103, DATE '2024-06-15', 5, 17500);

INSERT INTO transactions (transaction_id, customer_id, product_id, branch_id, sale_date, quantity, amount) VALUES
(3020, 1010, 2002, 101, DATE '2024-06-20', 6, 19200);

-- Commit all data
COMMIT;

-- Verify data insertion
SELECT 'OUTLETS' as table_name, COUNT(*) as record_count FROM outlets
UNION ALL
SELECT 'PRODUCTS', COUNT(*) FROM products  
UNION ALL
SELECT 'CUSTOMERS', COUNT(*) FROM customers
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*) FROM transactions;

-- Display sample data from each table
SELECT 'Sample Outlets:' as info FROM dual;
SELECT * FROM outlets;

SELECT 'Sample Products:' as info FROM dual;
SELECT * FROM products WHERE ROWNUM <= 5;

SELECT 'Sample Customers:' as info FROM dual;
SELECT * FROM customers WHERE ROWNUM <= 5;

SELECT 'Sample Transactions:' as info FROM dual;
SELECT t.transaction_id, c.name, p.name as product, o.branch_name, t.sale_date, t.amount
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN products p ON t.product_id = p.product_id  
JOIN outlets o ON t.branch_id = o.branch_id
WHERE ROWNUM <= 10;
