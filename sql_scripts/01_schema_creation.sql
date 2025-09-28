
-- =====================================================
-- PL/SQL Window Functions Project - Schema Creation
-- Student: Muhanguzi Boss
-- Student ID: 27810
-- Business: KFC Rwanda
-- Course: Database Development with PL/SQL (INSY 8311)
-- =====================================================

-- SCREENSHOT 1: Database Schema Creation
-- Run these CREATE TABLE statements one by one

-- Create Customers table first (no dependencies)
CREATE TABLE customers (
    customer_id NUMBER(6) PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    region VARCHAR2(30) NOT NULL,
    phone VARCHAR2(15),
    registration_date DATE DEFAULT SYSDATE
);

-- Create Products table  
CREATE TABLE products (
    product_id NUMBER(6) PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    category VARCHAR2(30) NOT NULL,
    unit_price NUMBER(8,2) NOT NULL
);

-- Create Outlets table (KFC branches)
CREATE TABLE outlets (
    branch_id NUMBER(3) PRIMARY KEY,
    branch_name VARCHAR2(50) NOT NULL,
    location VARCHAR2(50) NOT NULL,
    manager_name VARCHAR2(50)
);

-- Create Transactions table
-- This has foreign keys so create it last
CREATE TABLE transactions (
    transaction_id NUMBER(8) PRIMARY KEY,
    customer_id NUMBER(6) NOT NULL,
    product_id NUMBER(6) NOT NULL,
    branch_id NUMBER(3) NOT NULL,
    sale_date DATE NOT NULL,
    quantity NUMBER(4) DEFAULT 1,
    amount NUMBER(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (branch_id) REFERENCES outlets(branch_id)
);

-- Create indexes for better performance
CREATE INDEX idx_transactions_date ON transactions(sale_date);
CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_product ON transactions(product_id);
CREATE INDEX idx_transactions_branch ON transactions(branch_id);
CREATE INDEX idx_customers_region ON customers(region);
CREATE INDEX idx_products_category ON products(category);

-- Display table structure for verification
DESCRIBE outlets;
DESCRIBE products;
DESCRIBE customers;
DESCRIBE transactions;

-- Verify constraints
SELECT constraint_name, constraint_type, table_name 
FROM user_constraints 
WHERE table_name IN ('OUTLETS', 'PRODUCTS', 'CUSTOMERS', 'TRANSACTIONS')
ORDER BY table_name, constraint_type;

COMMIT;
