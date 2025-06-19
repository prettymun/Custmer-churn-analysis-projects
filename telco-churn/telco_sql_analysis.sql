#Telco-customer churn data analysis sql portfolio project

-- Viewing the table
SELECT * FROM telco_db.`telco-customer-churn`;

-- Renaming the table for easier interpretation by sql
RENAME TABLE `telco-customer-churn` TO telco_customer_churn;



-- Question 1: How many total customers are there?
SELECT COUNT(*) AS total_customers
FROM telco_customer_churn;



-- Question 2: How many customers have churned vs stayed?

SELECT Churn, COUNT(*) AS count
FROM telco_customer_churn
GROUP BY Churn;



-- Question 3: What is the overall churn rate(percentage)

SELECT
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100,2) AS churn_percentage
FROM telco_customer_churn;



-- Question 4: What is the Churn rate by contract type
SELECT
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN Churn ='Yes' THEN 1 ELSE 0 END) / COUNT(*)*100,2) AS churn_rate
FROM telco_customer_churn
GROUP BY Contract;



-- Question 5: Which internet service type has the highest churn
SELECT InternetService,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
ROUND(SUM(CASE WHEN Churn ='Yes' THEN 1 ELSE 0 END) / COUNT(*)*100,2) AS churn_rate
FROM telco_customer_churn
GROUP BY InternetService
ORDER BY churn_rate DESC;



-- Question  : Average monthly charges churned vs non-churned customers
SELECT Churn,
ROUND(AVG(MonthlyCharges),2) AS avg_monthly_charge
FROM telco_db.telco_customer_churn
GROUP BY Churn;



-- Quetion 7: Which payment method has the highest number of churned customers
SELECT 
PaymentMethod,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM telco_db.telco_customer_churn
GROUP BY PaymentMethod
ORDER BY churned_customers DESC;



-- Question 8: Churn rate between senior and non-senior citizens
SELECT
	SeniorCitizen, 
	COUNT(*) AS total_customers,
	SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) *100,2) AS churn_rate
FROM telco_db.telco_customer_churn
GROUP BY SeniorCitizen;



-- Question 9: Churn count grouped by gender
SELECT
	gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM telco_db.telco_customer_churn
GROUP BY gender;



-- Question 10: Effect of partner and dependents on churn

SELECT
	Partner,
    Dependents,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM telco_db.telco_customer_churn
GROUP BY Partner, Dependents;


-- Question 11: Do higher paying customers churn more?
SELECT
	CASE
		WHEN MonthlyCharges < 30 THEN 'Low(<30)'
        WHEN MonthlyCharges BETWEEN 30 AND 70 THEN 'Medium(30-70)'
        ELSE 'High(>70)'
	END AS payment_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100,2) AS churn_rate
FROM telco_db.telco_customer_churn
GROUP BY payment_group;


-- Question 12: Average tenure of churned vs loyal customers
SELECT 
	Churn,
    ROUND(AVG(tenure),2) AS avg_tenure
FROM telco_db.telco_customer_churn
GROUP BY Churn;



-- Question 13: Churn rate by tenure groups
SELECT
	CASE
		WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        ELSE '49+ months'
	END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churred_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) *100,2) churn_rate
FROM telco_db.telco_customer_churn
GROUP BY tenure_group
ORDER BY tenure_group;



-- Question 14: Total revenue from churned customers
SELECT 
	ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges * tenure ELSE 0 END),2) AS revenue_churned_customers
FROM telco_db.telco_customer_churn;



-- Question 15 : High risk profile, no partner, no dependants, months to month contract, no onlne security
-- USING WHERE
SELECT 
	COUNT(*) AS high_risk_customers
FROM telco_db.telco_customer_churn
WHERE
	Partner = 'No'
    AND Dependents = 'No'
    AND Contract - 'Month-to-month'
    AND OnlineSecurity = 'No';



-- COMPLEX ANSWERED QUESTIONS USING CTE,PARTITION BY, RANK OVER/////
-- Question 16: Which customers have the highest monthly charges in each contract type (top 3 per contract)?
-- Top 3 highest paying customers per contract type

WITH ranked_customers AS(
	SELECT
		customerID,
        Contract,
        MonthlyCharges,
        ROW_NUMBER() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC) AS rank_contract
	FROM telco_db.telco_customer_churn
    )
SELECT
	customerID,
    Contract,
    MonthlyCharges
FROM ranked_customers
WHERE rank_contract <= 3
ORDER BY Contract, MonthlyCharges DESC;



-- Question 17: Categorize customers into risk levels based on tenure and churn behavior (using CASE)
-- Risk segmentation based on tenure and churn behaviour

SELECT
	customerID,
    tenure,
    Churn,
    CASE
		WHEN Churn = 'Yes' AND tenure < 6 THEN 'High Risk'
        WHEN Churn = 'Yes' AND tenure BETWEEN 6 AND 12 THEN 'Medium Risk'
        WHEN Churn = 'No' AND tenure > 24 THEN 'Loyal Customer'
        ELSE 'Low Risk'
	END AS risk_segment
FROM telco_db.telco_customer_churn;



-- Question 18: Identify customers whose charges are above the average (using a subquery)
-- Customers with MonthlyCharges above the overall average
SELECT
	customerID,
    MonthlyCharges
FROM telco_db.telco_customer_churn
WHERE MonthlyCharges > (
	SELECT AVG (MonthlyCharges) FROM telco_db.telco_customer_churn
    )
ORDER BY MonthlyCharges DESC;



-- Question 19: Rank all customers based on total revenue ( MonthlyCharges * tenure)
-- Rank customers by total revenue contribution

SELECT
	customerID,
    MonthlyCharges,
    tenure,
    (MonthlyCharges * tenure ) AS total_revenue,
    RANK() OVER (ORDER BY (MonthlyCharges * tenure) DESC) AS revenue_rank
FROM telco_db.telco_customer_churn
LIMIT 20;

