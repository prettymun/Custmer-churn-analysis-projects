# Telco Customer Churn Analysis (SQL Project)

This project explores the Telco Customer Churn dataset using **MySQL** to uncover business insights and churn patterns. The analysis covers customer behavior, churn risk segmentation, revenue loss, and contract impact, while demonstrating both foundational and advanced SQL techniques.

---

## Project Objectives

- Identify drivers of customer churn
- Profile high-risk customers
- Estimate revenue loss due to churn
- Demonstrate end-to-end SQL capabilities
- Use real-world logic to answer data-driven business questions

---

## Dataset

**Source**: [Telco Customer Churn Dataset on Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)  
**File**: `WA_Fn-UseC_-Telco-Customer-Churn.csv`  
**Table Name**: `telco_customer_churn`  
**Imported To**: MySQL Workbench

---

## Tools Used

- **MySQL Workbench** for querying
- **Window functions**: `ROW_NUMBER()`, `RANK()`
- **CTEs**, `CASE`, **aggregations**, **subqueries**

---

## SQL Business Questions Answered

### General Overview
1. **Total number of customers**
2. **Churn vs non-churn customer counts**
3. **Overall churn rate (% of total)**
4. **Churn rate by contract type**
5. **Churn rate by internet service type**

### Revenue & Financials
6. **Average monthly charges (churned vs non-churned)**
7. **Payment method with most churned customers**
14. **Total revenue lost to churn**
19. **Top customers by total revenue using RANK()**

###  Customer Demographics & Risk
8. **Churn rate: senior vs non-senior citizens**
9. **Churn count by gender**
10. **Effect of partner and dependents on churn**
12. **Average tenure: churned vs non-churned**
13. **Churn rate by tenure group**
17. **Risk segmentation using CASE logic**
18. **Customers paying more than average (subquery)**

### Behavioral Segmentation
11. **Do high-paying customers churn more?**
15. **High-risk churn profile: month-to-month + no partner + no dependents + no security**
16. **Top 3 highest paying customers per contract (CTE + ROW_NUMBER())**

---

## Advanced SQL Concepts Demonstrated

| Concept | Used In |
|--------|---------|
| ✅ `CASE` statements | Q11, Q17 |
| ✅ Subqueries | Q18 |
| ✅ CTEs (`WITH`) | Q16 |
| ✅ Window Functions (`ROW_NUMBER()`, `RANK()`) | Q16, Q19 |
| ✅ Grouping & aggregation | Multiple queries |
| ✅ Derived metrics (`MonthlyCharges * tenure`) | Q14, Q19 |

---

## Advanced Queries

17. Categorize customers into risk levels based on tenure and churn behavior
18. Who are the customers whose monthly charges are higher than the overall average?
19. Which customers generate the most revenue overall, and how can we rank them using their total payments (Monthly Charges × Tenure)?
