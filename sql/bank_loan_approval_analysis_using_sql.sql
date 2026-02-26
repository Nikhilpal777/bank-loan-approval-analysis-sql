/* =====================================================
   PROJECT: Bank Loan Approval Analysis
   OBJECTIVE:
   Analyze loan applications to identify key factors
   influencing approval and rejection decisions.

   DATASET SIZE: 4269 records
   TOOLS USED: MySQL (GROUP BY, CASE, WINDOW FUNCTIONS)
===================================================== */


/* ================================
   STEP 1: DATABASE SETUP
================================ */
CREATE DATABASE bank_loan_project;
USE bank_loan_project;
CREATE DATABASE bank_loan_project;
USE bank_loan_project;

CREATE TABLE loan_data(
	loan_id INT,
    no_of_dependents INT,
	education VARCHAR(50),
	self_employed VARCHAR(10),
    income_annum BIGINT,
    loan_amount BIGINT,
    loan_term INT,
    cibil_score INT,
    residential_assets_value BIGINT,
     commercial_assets_value BIGINT,
      luxury_assets_value BIGINT,
       bank_asset_value BIGINT,
       loan_status VARCHAR(20)
);
SELECT *
FROM loan_data
LIMIT 20;

SELECT COUNT(*) FROM loan_data;

SELECT loan_status, COUNT(*)
FROM loan_data
GROUP BY loan_status;

/* ================================
   STEP 2: DATA QUALITY CHECKS
   Purpose: Verify data integrity
================================ */
-- Check null values

SELECT
	SUM(loan_id IS NULL) AS loan_id_nulls,
    SUM(no_of_dependents IS NULL) AS dependents_nulls,
    SUM(education IS NULL) AS education_nulls,
    SUM(self_employed IS NULL) AS self_emp_nulls,
    SUM(income_annum IS NULL) AS income_nulls,
    SUM(loan_amount IS NULL) AS loan_amount_nulls,
    SUM(loan_term IS NULL) AS loan_term_nulls,
    SUM(cibil_score IS NULL) AS cibil_score_nulls,
    SUM(residential_assets_value IS NULL) AS residential_nulls,
    SUM(commercial_assets_value IS NULL) AS commercial_assets_nulls,
    SUM(luxury_assets_value IS NULL) AS luxury_assets_nulls,
	SUM(bank_asset_value IS NULL) AS bank_asset_nulls,
    SUM(loan_status IS NULL) AS loan_status_nulls
FROM loan_data;

-- Duplicates
SELECT loan_id ,COUNT(*)
FROM loan_data
GROUP BY loan_id
HAVING COUNT(*) > 1;

-- Distinct values in loan_status

SELECT DISTINCT loan_status
FROM loan_data;

SELECT *
FROM loan_data
WHERE income_annum < 0;

SELECT *
FROM loan_data
WHERE cibil_score NOT BETWEEN 300 AND 900;

/* ================================
   STEP 3: BASIC LOAN METRICS
   Purpose: Understand overall approval trends
================================ */
-- basic analysis

SELECT COUNT(*) AS total_loan
FROM loan_data;

SELECT loan_status,COUNT(*) 
FROM loan_data
GROUP BY loan_status;

SELECT
ROUND( SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END 
    ) * 100 / COUNT(*),2 ) AS approved_ratio
FROM loan_data;

SELECT
ROUND( 
SUM(CASE WHEN loan_status = 'Rejected' THEN 1 ELSE 0 END 
    ) * 100 / COUNT(*),2 ) AS reject_ratio
FROM loan_data;

SELECT ROUND(AVG(loan_amount),2) AS average_loan_amount
FROM loan_data;

SELECT ROUND(AVG(income_annum),2) AS average_income
FROM loan_data;

SELECT ROUND(AVG(cibil_score),2) AS avg_cibil
FROM loan_data;

/* ================================
   STEP 4: CUSTOMER SEGMENTATION
   Purpose: Segment applicants by income,
            credit score, and loan size
================================ */

SELECT 
CASE 
	WHEN income_annum < 500000 THEN 'Low Income'
    WHEN income_annum BETWEEN 500000 AND 1000000 THEN 'Medium Income'
    ELSE 'High Income' END AS income_segment,COUNT(*)
FROM loan_data
GROUP BY income_segment ;

SELECT 
CASE 
	WHEN income_annum < 500000 THEN 'Low Income'
    WHEN income_annum BETWEEN 500000 AND 1000000 THEN 'Medium Income'
    ELSE 'High Income' END AS income_segment,
    loan_status,COUNT(*) AS total
FROM loan_data
GROUP BY income_segment,loan_status
ORDER BY income_segment;

SELECT
CASE 
	WHEN cibil_score < 600 THEN 'Poor' 
	WHEN cibil_score BETWEEN 600 AND 749 THEN 'Average'
	WHEN cibil_score >= 750 THEN 'Good' END AS cibil_segment,
	loan_status,COUNT(*) AS total
FROM loan_data
GROUP BY cibil_segment,loan_status
ORDER BY cibil_segment;

SELECT 
CASE 
	WHEN loan_amount < 500000 THEN 'Small Loan'
	WHEN loan_amount BETWEEN 500000 AND 1500000 THEN 'Medium Loan'
    ELSE 'Large Loan' END AS loan_segment,
    loan_status,COUNT(*) AS total
FROM loan_data
GROUP BY loan_segment,loan_status
ORDER BY loan_segment;
	
/* ================================
   STEP 5: INTERMEDIATE RISK ANALYSIS
   Purpose: Evaluate approval/rejection
            behavior across segments
================================ */

SELECT
	income_segment,
    ROUND(
		SUM(CASE
		WHEN loan_status = 'Approved' THEN 1 ELSE 0 END ) * 100/
		COUNT(*),2) AS approval_rate
FROM(
SELECT *,
CASE 
	WHEN income_annum < 500000 THEN 'Low Income'
    WHEN income_annum BETWEEN 500000 AND 1000000 THEN 'Medium Income'
    ELSE 'High Income' END AS income_segment 
FROM loan_data) t
GROUP BY income_segment
ORDER BY approval_rate DESC;

SELECT
    cibil_segment,
    ROUND(
        SUM(CASE WHEN loan_status = 'Rejected' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2) AS rejected_rate
FROM (
    SELECT *,
        CASE
            WHEN cibil_score < 600 THEN 'Poor'
            WHEN cibil_score BETWEEN 600 AND 749 THEN 'Average'
            ELSE 'Good'
        END AS cibil_segment
    FROM loan_data
) t
GROUP BY cibil_segment
ORDER BY rejected_rate DESC;

SELECT *
FROM loan_data;

SELECT
	loan_amount_segment,
    ROUND(
    SUM(CASE WHEN loan_status = 'Rejected' THEN 1 ELSE 0 END ) *100 /
    COUNT(*),2) AS rejected_rate
FROM(SELECT *,
CASE
	WHEN loan_amount < 500000 THEN 'Small Loan'
    WHEN loan_amount BETWEEN 500000 AND 1500000 THEN 'Medium Loan'
    ELSE 'Large Loan' 
    END AS loan_amount_segment
FROM loan_data) t
GROUP BY loan_amount_segment
ORDER BY rejected_rate DESC;

SELECT
    income_segment,
    COUNT(*) AS total_apps,
    ROUND(
        SUM(CASE WHEN loan_status = 'APPROVED' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS approval_rate_pct
FROM (
    SELECT *,
        CASE
            WHEN income_annum < 500000 THEN 'Low Income'
            WHEN income_annum BETWEEN 500000 AND 1000000 THEN 'Medium Income'
            ELSE 'High Income'
        END AS income_segment
    FROM loan_data
) t
GROUP BY income_segment
ORDER BY approval_rate_pct DESC;

/* ================================
   STEP 6: HIGH VALUE LOAN RANKING
   Purpose: Identify largest loan exposures
================================ */

SELECT
	loan_id,
    income_annum,
    loan_amount,
    RANK() OVER(ORDER BY loan_amount DESC) AS loan_rank
FROM loan_data;

SELECT
	loan_id,
    income_annum,
    loan_amount,
    cibil_score,
    loan_status,
    RANK() OVER(ORDER BY loan_amount DESC ) AS loan_rank
FROM loan_data
ORDER BY loan_amount DESC
LIMIT 10;

/* =====================================================
   END OF ANALYSIS
   Key drivers identified:
   - Credit score is primary approval factor
   - Income impact is secondary
   - Medium loans show moderate risk
===================================================== */

/* =====================================================
   STEP 7: BUSINESS INSIGHTS
   Purpose: Summarize key analytical findings
=====================================================

INSIGHT 1 — Approval Overview
The overall loan approval rate is 62.22%, indicating a moderately selective lending process with approximately 38% of applications rejected.

INSIGHT 2 — Credit Score Impact
Applicants with Poor CIBIL (<600) show the highest rejection rates (~75%), confirming credit score is the primary risk driver in loan approval decisions.

INSIGHT 3 — Income Observation
Although low-income applicants show a slightly higher approval rate (67.19%), this segment has a very small sample size (128 applications). Therefore, income alone does not appear to be the dominant approval factor.

INSIGHT 4 — Loan Size Risk
Medium loan amounts (₹5L–₹15L) show around 40% rejection, indicating moderate risk concentration in mid-range lending.

INSIGHT 5 — High-Value Risk Exposure
The maximum loan issued is ₹39.5M, representing significant exposure. High-value lending should be tightly aligned with strong credit profiles.

===================================================== */

/* =====================================================
   STEP 8: BUSINESS RECOMMENDATIONS
=====================================================

1. Prioritize credit score as the primary approval filter.
2. Apply stricter review for medium-sized loans where rejection risk is higher.
3. Monitor high-value loans closely to manage risk exposure.
4. Do not rely solely on income for approval decisions.
5. Consider automated risk flags for applicants with CIBIL < 600.

===================================================== */