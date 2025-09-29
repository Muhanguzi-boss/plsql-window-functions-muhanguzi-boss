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
<img width="689" height="213" alt="image" src="https://github.com/user-attachments/assets/f7e79bea-c645-4f28-bde7-30121104aad0" />


 *Screenshot 4: RANK vs DENSE_RANK Comparison* 
<img width="808" height="213" alt="image" src="https://github.com/user-attachments/assets/8311cd2f-afd6-4b2a-b764-23d8b7c59c18" />


 *Screenshot 5: PERCENT_RANK Analysis*  
<img width="730" height="194" alt="image" src="https://github.com/user-attachments/assets/78b273c6-4823-4f99-adc6-52ff3edfa49f" />



---

### 4.2 Aggregate Functions – Revenue Trend Analysis  
Functions: `SUM()`, `AVG()`, `MIN()`, `MAX()` with **ROWS vs RANGE**  

- Analyze **running totals** of sales per outlet  
- Track **monthly averages** and **seasonal patterns**  

 *Screenshot 6: Running Totals*  
<img width="393" height="200" alt="image" src="https://github.com/user-attachments/assets/ae1d2b62-6f93-4fb6-a2cf-83807053375d" />


 *Screenshot 7: ROWS vs RANGE Frame Comparison*  

<img width="714" height="193" alt="image" src="https://github.com/user-attachments/assets/7b10dbb8-ed11-4888-9cb3-f7644927021b" />


 *Screenshot 8: Moving Averages*  
 <img width="694" height="195" alt="image" src="https://github.com/user-attachments/assets/bf69ca37-9294-4480-b7a0-cd8308f844c2" />


---

### 4.3 Navigation Functions – Growth Pattern Analysis  
Functions: `LAG()`, `LEAD()`  

- Month-over-month **growth trends**  
- Forward-looking comparisons  

 *Screenshot 9: LAG() Previous Month*  
<img width="672" height="198" alt="image" src="https://github.com/user-attachments/assets/acbe4d1b-f11d-41b5-9e39-1cf0541412b2" />



*Screenshot 10: LEAD() Future Analysis*  
<img width="652" height="189" alt="image" src="https://github.com/user-attachments/assets/3f08e708-f9f5-4e71-930e-9e2e9f9db0d7" />


*Screenshot 11: Growth Percentages*  

<img width="569" height="189" alt="image" src="https://github.com/user-attachments/assets/1d6b815d-677b-425e-8e0c-27cf890dc56d" />



---

### 4.4 Distribution Functions – Customer Segmentation  
Functions: `NTILE(4)`, `CUME_DIST()`  

- Divide customers into **quartiles** by spending  
- Identify **VIP vs Price-Sensitive** groups  

*Screenshot 12: Customer Quartiles (NTILE)*  
<img width="767" height="211" alt="image" src="https://github.com/user-attachments/assets/e6427550-9cdd-4492-8c03-02a1360f1c5b" />


*Screenshot 13: Customer Cumulative Distribution*  
<img width="827" height="217" alt="image" src="https://github.com/user-attachments/assets/5eda48fc-9aa6-4d1c-8e9a-4a3335c4020c" />


*Screenshot 14: Segment Labels*  
<img width="864" height="213" alt="image" src="https://github.com/user-attachments/assets/e67f5686-e33e-4b8e-b0a3-e87a80d08318" />



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
                      # Git internal files
```
**Screenshot 15: FIRST_VALUE() and LAST_VALUE() Navigation Functions** 
<img width="762" height="214" alt="image" src="https://github.com/user-attachments/assets/1d5df843-1455-44b5-abaa-85d158d7c98e" />


*Shows the first and last sales values in each branch over the analysis period. Useful for identifying starting and ending trends for high-selling products.*

**Screenshot 16: Advanced Ranking with Ties Handling**  
<img width="931" height="216" alt="image" src="https://github.com/user-attachments/assets/4a31bbf9-6935-464f-b909-6733629147d9" />


*Illustrates how tied sales are ranked using RANK() and DENSE_RANK(), highlighting how KFC Rwanda outlets handle identical top-selling products.*

**Screenshot 17: Window Frame Variations**  
<img width="823" height="190" alt="image" src="https://github.com/user-attachments/assets/228b3f58-fafa-4a67-85c1-decf9d529cac" />


*Demonstrates different ROWS frame specifications (ROWS BETWEEN vs RANGE BETWEEN) in aggregate functions, showing how cumulative totals and averages can vary depending on the frame.*

**Screenshot 18: Advanced Customer Analytics**  

<img width="957" height="190" alt="image" src="https://github.com/user-attachments/assets/d43f1a81-0083-479d-92e6-8d97ad7bd1ca" />

*Multi-level customer analysis including spending tiers, frequency, and loyalty patterns. Helps identify VIP, regular, and price-sensitive customer segments.*

**Screenshot 19: Product Performance Matrix** 
<img width="987" height="184" alt="image" src="https://github.com/user-attachments/assets/a05dbfa6-dc26-4e20-91ac-821b7271dd1d" />


*Matrix showing product sales across all outlets, combining ranking and aggregate measures. Highlights products with the highest market share per location.*

**Screenshot 20: Business Intelligence Summary**  
<img width="985" height="61" alt="image" src="https://github.com/user-attachments/assets/65692b22-a28a-42e5-ac60-8bc596f854a7" />


*Executive-level summary dashboard compiling top products, sales trends, growth percentages, and customer segmentation. Provides actionable insights for KFC Rwanda management.*

**Screenshot 21: Top 5 Products per Outlet**  

<img width="707" height="211" alt="image" src="https://github.com/user-attachments/assets/bea831ab-ba05-43fd-b8ea-49de337094df" />


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

1. Oracle Corporation. (2024). *Oracle Database SQL Language Reference - Analytic Functions*.  https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/Conditions.html
2. Oracle Corporation. (2024). *PL/SQL Language Reference*.   https://en.wikipedia.org/wiki/Oracle_Corporation#:~:text=Oracle%20Corporation%20is%20an%20American,Global%202000%20as%20of%202025.
3. Course Lecture Notes (2025). *INSY 8311 – AUCA*.  
4. TechOnTheNet (2024). *Oracle / PLSQL: Analytic Functions*.  https://www.techonthenet.com/oracle/functions/index.php
5. W3Schools (2024). *SQL Window Functions*.  https://www.w3schools.com/sql/sql_aggregate_functions.asp
6. SQLBolt (2024). *Lesson 18: Queries with Expressions*.  https://www.techonthenet.com/oracle/index.php
7. Oracle Tutorial (2023). *Oracle Window Functions Tutorial (YouTube)*.  https://youtu.be/Ww71knvhQ-s?si=kXez-xuKgS3Tyjc6
8. Programming with Mosh (2022). *SQL Window Functions Explained (YouTube)*.  https://youtu.be/7S_tz1z_5bA?si=6idUw8s0ivmU1rW1
9. KFC Rwanda (2024). *Company Website*.  https://kfc.rw/
10. Oracle Documentation (2024). *Database Concepts Guide*.  https://www.oracle.com/

---

## Academic Integrity Statement  
All sources used in this project have been properly cited. The application of PL/SQL window functions to KFC Rwanda’s business scenario represents my own analytical work. The Rwanda fast-food context is based on my research and understanding.

---







