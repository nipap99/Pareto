# Pet Shop Sales - Pareto (80/20) Analysis using PostgreSQL Views

A complete, modular PostgreSQL project that demonstrates how to perform a **classic Pareto (80/20) analysis** using only SQL views — no Python, no external BI tools required.

This project shows how just **9.4% of customers** can generate over **81% of total revenue** — a powerful insight for any retail or e-commerce business.

---

## 🎯 Project Goal

To answer one key business question:

> **"How many of our best customers are responsible for 80% (or more) of total revenue?"**

This analysis helps businesses focus their marketing, loyalty programs, and customer support on the right segment.

---

## 📁 Project Structure

The project is built using **layered views** for maximum clarity, reusability, and maintainability:

| View Name                    | Purpose |
|-----------------------------|--------|
| `v_sales_lines`             | Cleans raw data and calculates revenue per line item |
| `v_customer_revenue`        | Aggregates total revenue per customer |
| `v_pareto_ranked`           | Applies ranking and running (cumulative) totals using window functions |
| `pareto_final`              | Formats results with clean percentages for reporting |
| Final Query                 | Extracts the exact 80/20 insight |

---

## 🔍 What Each View Does (Simple Explanation)

1. **`v_sales_lines`**  
   Cleans the raw sales data by removing returns and invalid rows, then calculates revenue for each individual product sold (`Quantity × UnitPrice`).  
   *Think of it as your "cleaned shopping list".*

2. **`v_customer_revenue`**  
   Groups all purchases by `CustomerID` and calculates the **total amount spent** by each customer.  
   Sorted from highest to lowest spender.

3. **`v_pareto_ranked`**  
   The core of the analysis.  
   - Assigns a rank to each customer (1 = biggest spender)  
   - Calculates how many customers are included so far (`cum_customers`)  
   - Computes the **cumulative revenue** as you add more customers  
   - Keeps track of the grand total revenue

4. **`pareto_final`**  
   Converts the raw numbers into easy-to-read **percentages**:  
   - % of total revenue from the top X customers  
   - % of total customers included in the top X

5. **Final 80/20 Query**  
   Finds the smallest number of customers needed to reach at least **80% of total revenue**.

---

## 📊 Key Insight (Example Result)

- **Total Customers**: 4,372  
- **Total Revenue**: $8,978,950  
- **Customers needed for 80% revenue**: **412** (only **9.4%** of all customers)  
- **Revenue from these customers**: $7,281,450 (81.1% of total)

**Conclusion**: A small group of high-value customers drives the majority of revenue — classic Pareto principle in action.

---

## 🚀 How to Use

1. Create the `pet_shop_sales` table (provided in `setup.sql`)
2. Run the view creation scripts in order:
   - `01_v_sales_lines.sql`
   - `02_v_customer_revenue.sql`
   - `03_v_pareto_ranked.sql`
   - `04_pareto_final.sql`
3. Execute the final 80/20 analysis query

All scripts are included in the repository.

---

## 🛠️ Technologies Used

- **PostgreSQL 18**
- Pure SQL (Views + Window Functions)
- No Python, No ETL tools, No BI software

---

## 📈 Why This Approach is Powerful

- Fully **modular** and reusable
- Easy to maintain and modify
- Great performance (leverages PostgreSQL window functions)
- Perfect for learning advanced SQL concepts (Window Functions, Layered Views, Pareto Analysis)

---

## 📌 Use Cases

- Retail & E-commerce analytics
- Customer segmentation
- Marketing budget allocation
- Loyalty program design
- Executive dashboards
