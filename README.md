# PL/SQL Window Functions Analysis: KFC Rwanda  
**Course:** Database Development with PL/SQL (INSY 8311)  
**Student:** Muhanguzi Boss
**Student ID:** 27810 

**Assignment:** Individual Assignment I - Window Functions Mastery Project  
**Submission Date:** September 29, 2025  
**Repository:** plsql-window-functions-muhanguzi-boss 

---

## Step 1: Problem Definition  

### Business Context  
KFC Rwanda is part of the international Kentucky Fried Chicken franchise, operating multiple outlets across Kigali, including KFC Kigali City Center, KFC Remera, and KFC Nyamirambo. The company is a fast-food leader in Rwanda’s growing urban food industry, serving thousands of customers daily with products such as fried chicken, burgers, fries, and beverages. With Rwanda’s young and urban population driving fast-food demand, KFC Rwanda plays a central role in the quick-service restaurant sector.  

### Data Challenge  
KFC Rwanda management struggles to track product performance across different outlets and time periods. Without clear insights into which menu items are most profitable in each location, how customer purchases vary by region, and whether sales are growing consistently, strategic decisions around promotions, inventory, and marketing remain weak.  

### Expected Outcome  
This analysis using PL/SQL window functions will reveal KFC Rwanda’s top-selling products per branch, monitor sales growth patterns, and segment customers by spending. The insights will help optimize inventory, target marketing campaigns, and improve profitability.  

---

## Step 2: Success Criteria (5 Measurable Goals)  

### Clear Query-to-Criteria Mapping  

| Success Criteria                | Window Function Used                                    | Analysis Type                  | Screenshot |
|---------------------------------|---------------------------------------------------------|--------------------------------|------------|
| 1. Top 5 products per outlet    | `RANK() OVER(PARTITION BY branch ORDER BY sales DESC)` | Outlet Product Rankings         | Screenshot 21 |
| 2. Running monthly sales totals | `SUM() OVER(ORDER BY month ROWS UNBOUNDED PRECEDING)`  | Running Totals Analysis         | Screenshot 6 |
| 3. Month-over-month growth      | `LAG()` and `LEAD()` for growth percentages             | Growth Percentage Calculations  | Screenshot 11 |
| 4. Customer quartiles           | `NTILE(4) OVER(ORDER BY total_spending DESC)`           | Customer Segmentation           | Screenshot 12 |
| 5. 3-month moving averages      | `AVG() OVER(ORDER BY month ROWS 2 PRECEDING)`           | Moving Averages Analysis        | Screenshot 8 |

### Detailed Success Criteria  
- **Top 5 products per outlet** → Identify best-performing menu items by outlet using `RANK()`  
- **Running monthly sales totals** → Track cumulative branch revenues with `SUM() OVER()`  
- **Month-over-month growth analysis** → Measure growth trends with `LAG()` / `LEAD()`  
- **Customer quartiles segmentation** → Divide customers into 4 spending groups with `NTILE(4)`  
- **3-month moving averages** → Smooth revenue trends with `AVG() OVER()`  

---

## Step 3: Database Schema Design  

### Entity Relationship Diagram  

```

┌─────────────────┐         ┌─────────────────┐
│    CUSTOMERS    │         │     OUTLETS     │
├─────────────────┤         ├─────────────────┤
│ customer_id (PK)│         │ branch_id (PK)  │
│ name            │         │ branch_name     │
│ region          │         │ location        │
│ phone           │         │ manager_name    │
└─────────┬───────┘         └─────────┬───────┘
          │                           │
          │ 1                         │ 1
          │                           │
          │ M                         │ M
          └──────┐           ┌────────┘
                 │           │
                 ▼           ▼
         ┌─────────────────────────┐
         │       TRANSACTIONS       │
         ├─────────────────────────┤
         │ transaction_id (PK)      │
         │ customer_id (FK)         │
         │ product_id (FK)          │
         │ branch_id (FK)           │
         │ sale_date                │
         │ quantity                 │
         │ amount                   │
         └─────────┬───────────────┘
                   │
                   │ M
                   │
                   │ 1
                   ▼
         ┌─────────────────┐
         │     PRODUCTS     │
         ├─────────────────┤
         │ product_id (PK) │
         │ name            │
         │ category        │
         │ unit_price      │
         └─────────────────┘

```

### Business Rules and Relationships  
- One customer can make many transactions (1:M)  
- One outlet can process many transactions (1:M)  
- One product can appear in many transactions (1:M)  
- Each transaction links exactly one customer, one outlet, and one product  

### Table Specifications  

| Table        | Purpose                          | Key Columns                              | Example Row |
|--------------|----------------------------------|------------------------------------------|-------------|
| customers    | Customer information             | `customer_id (PK), name, region, phone`  | 1001, Alice Uwase, Kigali, 078-123-4567 |
| products     | Menu catalog with pricing        | `product_id (PK), name, category, unit_price` | 2001, Zinger Burger, Burger, 5500 |
| outlets      | KFC outlet locations & managers  | `branch_id (PK), branch_name, location, manager_name` | 101, KFC Kigali City, City Center, John Ndayisaba |
| transactions | Sales records                    | `transaction_id (PK), customer_id (FK), product_id (FK), branch_id (FK), sale_date, amount` | 3001, 1001, 2001, 101, 2024-01-15, 11000 |


**Screenshot 1: Database Schema Creation**  

<img width="266" height="149" alt="image" src="https://github.com/user-attachments/assets/6ca361bd-1756-4341-8c08-08630dbfa19b" />


  

**Screenshot 2: Sample Data Insertion and Verification**  
<img width="303" height="146" alt="image" src="https://github.com/user-attachments/assets/020b39ca-a8f9-43b0-83fd-7f8ccb072605" />

<img width="708" height="140" alt="image" src="https://github.com/user-attachments/assets/175bbb4d-848b-4321-aed1-b106a5c481cc" />

<img width="530" height="176" alt="image" src="https://github.com/user-attachments/assets/a86960e6-55db-48ec-a255-dda066d8889f" />

<img width="739" height="183" alt="image" src="https://github.com/user-attachments/assets/5e1b1816-6534-43a0-a0bc-b099c3063e20" />

<img width="954" height="214" alt="image" src="https://github.com/user-attachments/assets/ea4caeb9-39e6-4d15-ad15-0b5ed8dc2616" />


---

## Step 4: Window Functions Implementation  

### 4.1 Ranking Functions – Product Performance Analysis  
Functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `PERCENT_RANK()`  

- Used to identify **top-selling menu items** in each branch  
- Helps management adjust **menu promotions and stock**  

 *Screenshot 3: ROW_NUMBER Results* 


 *Screenshot 4: RANK vs DENSE_RANK Comparison* 


 *Screenshot 5: PERCENT_RANK Analysis*  



---

### 4.2 Aggregate Functions – Revenue Trend Analysis  
Functions: `SUM()`, `AVG()`, `MIN()`, `MAX()` with **ROWS vs RANGE**  

- Analyze **running totals** of sales per outlet  
- Track **monthly averages** and **seasonal patterns**  

 *Screenshot 6: Running Totals*  


 *Screenshot 7: ROWS vs RANGE Frame Comparison*  



 *Screenshot 8: Moving Averages*  

---

### 4.3 Navigation Functions – Growth Pattern Analysis  
Functions: `LAG()`, `LEAD()`  

- Month-over-month **growth trends**  
- Forward-looking comparisons  

 *Screenshot 9: LAG() Previous Month*  



*Screenshot 10: LEAD() Future Analysis*  


*Screenshot 11: Growth Percentages*  




---

### 4.4 Distribution Functions – Customer Segmentation  
Functions: `NTILE(4)`, `CUME_DIST()`  

- Divide customers into **quartiles** by spending  
- Identify **VIP vs Price-Sensitive** groups  

*Screenshot 12: Customer Quartiles (NTILE)*  


*Screenshot 13: Customer Cumulative Distribution*  


*Screenshot 14: Segment Labels*  



---

## Step 5: Technical Implementation & GitHub Repository  

### Repository Structure  

```plain text
plsql-window-functions-muhanguzi-boss/
├── README.md                           # Main assignment report (KFC Rwanda)
├── sql_scripts/
│   ├── 01_schema_creation.sql          # Database schema setup (tables & constraints)
│   ├── 02_sample_data_insert.sql       # Sample data insertion (KFC data)
│   └── 03_window_functions_queries.sql # Window function queries (ranking, agg, nav, dist)
├── screenshots/                        # All screenshots (21+ as required)
│   ├── 01_schema_creation.png
│   ├── 02_data_insertion_verification.png
│   ├── 03_row_number_results.png
│   ├── 04_rank_comparison.png
│   ├── 05_percent_rank_analysis.png
│   ├── 06_running_totals.png
│   ├── 07_rows_vs_range_comparison.png
│   ├── 08_moving_averages.png
│   ├── 09_lag_previous_month.png
│   ├── 10_lead_future_analysis.png
│   ├── 11_growth_percentage.png
│   ├── 12_ntile_customer_quartiles.png
│   ├── 13_cume_dist_percentiles.png
│   ├── 14_customer_segment_labels.png
│   ├── 15_first_last_value_analysis.png
│   ├── 16_advanced_ranking_ties.png
│   ├── 17_window_frame_variations.png
│   ├── 18_advanced_customer_analytics.png
│   ├── 19_product_performance_matrix.png
│   ├── 20_business_intelligence_summary.png
│   └── 21_top_5_products_by_outlet.png
└── .git/                                # Git internal files


```
**Screenshot 15: FIRST_VALUE() and LAST_VALUE() Navigation Functions** 


*Shows the first and last sales values in each branch over the analysis period. Useful for identifying starting and ending trends for high-selling products.*

**Screenshot 16: Advanced Ranking with Ties Handling**  


*Illustrates how tied sales are ranked using RANK() and DENSE_RANK(), highlighting how KFC Rwanda outlets handle identical top-selling products.*

**Screenshot 17: Window Frame Variations**  


*Demonstrates different ROWS frame specifications (ROWS BETWEEN vs RANGE BETWEEN) in aggregate functions, showing how cumulative totals and averages can vary depending on the frame.*

**Screenshot 18: Advanced Customer Analytics**  


*Multi-level customer analysis including spending tiers, frequency, and loyalty patterns. Helps identify VIP, regular, and price-sensitive customer segments.*

**Screenshot 19: Product Performance Matrix** 


*Matrix showing product sales across all outlets, combining ranking and aggregate measures. Highlights products with the highest market share per location.*

**Screenshot 20: Business Intelligence Summary**  


*Executive-level summary dashboard compiling top products, sales trends, growth percentages, and customer segmentation. Provides actionable insights for KFC Rwanda management.*

**Screenshot 21: Top 5 Products per Outlet**  



*Final ranking of the top 5 menu items per outlet using `RANK() OVER(PARTITION BY branch ORDER BY sales DESC)`. Identifies key performers for inventory allocation and promotional focus.*



- **All 5 Success Criteria achieved**  
- **20+ Screenshots included**  
- **All 4 Window Function categories implemented**  

---


## Step 6: Results Analysis  

### Descriptive – What Happened?  
- **Chicken Buckets** dominate in Kigali City outlet  
- **Burgers** lead in Nyamirambo branch  
- Top 25% customers generate **over 60% of revenue**  

### Diagnostic – Why?  
- Urban outlets attract higher spenders  
- Student-heavy regions (Remera) buy lower-cost menu combos  
- High sales concentration in Kigali reflects **urban income distribution**  

### Prescriptive – What Next?  
- Create **VIP loyalty program** for high spenders  
- Offer **student combo discounts** in Remera  
- Reallocate inventory: more **chicken buckets** in Kigali, more **burgers** in Nyamirambo  

---

## Step 7: References  

1. Oracle Corporation. (2024). *Oracle Database SQL Language Reference - Analytic Functions*.  
2. Oracle Corporation. (2024). *PL/SQL Language Reference*.  
3. Course Lecture Notes (2025). *INSY 8311 – AUCA*.  
4. TechOnTheNet (2024). *Oracle / PLSQL: Analytic Functions*.  
5. W3Schools (2024). *SQL Window Functions*.  
6. SQLBolt (2024). *Lesson 18: Queries with Expressions*.  
7. Oracle Tutorial (2023). *Oracle Window Functions Tutorial (YouTube)*.  
8. Programming with Mosh (2022). *SQL Window Functions Explained (YouTube)*.  
9. KFC Rwanda (2024). *Company Website*.  
10. Oracle Documentation (2024). *Database Concepts Guide*.  

---

## Academic Integrity Statement  
All sources used in this project have been properly cited. The application of PL/SQL window functions to KFC Rwanda’s business scenario represents my own analytical work. The Rwanda fast-food context is based on my research and understanding.

---
Repository: plsql-window-functions-muhanguzi-boss
Submission Date: September 29, 2025
Course: Database Development with PL/SQL (INSY 8311)
Institution: Adventist University of Central Africa (AUCA)






