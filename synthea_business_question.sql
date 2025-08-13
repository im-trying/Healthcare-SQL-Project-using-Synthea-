-- Business Questions 

-- 1. “Which top 5 providers had the highest number of unique patients over time, and how did their monthly patient count trend?”

-- Top 5 Providers 

WITH provider_ranking AS(
SELECT 
	p.id,
    p.name,
    COUNT(DISTINCT(e.patient)) AS unique_patient
FROM providers AS p
JOIN encounters AS e
	ON p.id = e.provider
GROUP BY p.id
)
SELECT 
	id,
    name,
	unique_patient,
    RANK() OVER(ORDER BY unique_patient DESC) AS provider_rank
FROM provider_ranking
LIMIT 5;

-- Top 5 providers' patient monthly trend 

WITH cte1 AS(
SELECT 
	p.name,
    p.id, 
    e.provider,
	e.patient,
    e.start,
    EXTRACT(year FROM e.start) AS  year,
    MONTHNAME(e.start) AS month_name
FROM encounters AS e
JOIN providers AS p 
	ON e.provider = p.id
),
cte2 AS(
SELECT 
	name,
    id,
	COUNT(DISTINCT(patient)) as unique_patient
FROM cte1 
GROUP BY id
ORDER BY COUNT(DISTINCT(patient)) DESC
),
provider_rank AS(
SELECT 
	name, 
    id,
    unique_patient,
    RANK() OVER (ORDER BY unique_patient DESC) AS provider_rank
FROM cte2
),
month_date AS(
SELECT 
	name,
    id, 
    provider,
	patient,
    EXTRACT(year FROM start) AS year,
    EXTRACT(month FROM start) AS month_num,
    MONTHNAME(start) AS month_name
FROM cte1
)
SELECT 
	md.name,
    md.year,
    md.month_num,
    md.month_name,
    COUNT(DISTINCT(md.patient)) AS patient_count
FROM month_date AS md
JOIN provider_rank AS pr 
	ON md.id = pr.id
WHERE pr.provider_rank <= 5
GROUP BY md.name, md.year, md.month_num, md.month_name
ORDER BY year, md.month_num;


-- 2. Average Claim Amount by Condition and Gender 
-- “What is the average claim amount per diagnosis code, segmented by gender?”

-- Average claim amount per diagnosis code, by gender 

SELECT 
	p.gender,
	c.diagnosis1,
    ROUND(AVG(e.total_claim_cost), 2) AS avg_total_claim_cost
FROM claims AS c
JOIN encounters AS E 
	ON c.patient_id = e.patient
JOIN patients AS p
	ON e.patient = p.id
WHERE c.diagnosis1 IS NOT NULL AND c.diagnosis1 <> ''
GROUP BY p.gender, c.diagnosis1;


-- 3. High-Risk Patients with Frequent Admissions
-- “Identify patients with more than 3 hospital encounters within the last year of data”
    
WITH cte1 AS(
SELECT 
	e.start,
    EXTRACT(year FROM e.start) AS year,
    e.patient,
    ROW_NUMBER() OVER (PARTITION BY e.patient ORDER BY e.patient) AS row_num,
    p.first_name,
    p.middle_name,
    p.last_name,
    CONCAT(coalesce(p.first_name, " "), " ", coalesce(p.middle_name, " "), " ", coalesce(p.last_name, " ")) AS full_name
FROM encounters AS e 
JOIN patients AS p 
	ON e.patient = p.id
WHERE EXTRACT(year FROM start) = 2025
)
SELECT 
	DISTINCT(patient),
    full_name
FROM cte1
WHERE row_num >=3;

-- 4. Monthly Claims Trends with Rolling Averages 
-- “How do monthly total claims change over time, and what is the 3-month rolling average?”

WITH cte1 AS(
SELECT 
    EXTRACT(month FROM start) AS month,
    MONTHNAME(start) AS month_name,
    EXTRACT(year FROM start) AS year,
    SUM(total_claim_cost) AS claim_cost_per_month
FROM encounters
GROUP BY EXTRACT(month FROM start), MONTHNAME(start), EXTRACT(year FROM start)
ORDER BY year, month
)
SELECT 
	year,
    month,
    month_name,
    claim_cost_per_month,
    AVG(claim_cost_per_month) OVER (ORDER BY year, month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM cte1;

-- 5. Most Common Diagnoses Leading to Expensive Claims
-- “Which diagnoses are most frequently associated with the top 10% most expensive claims?”

-- Finding diagnoses that are associated with the top 10% most expensive claims
SELECT 
	c.diagnosis1,
    e.total_claim_cost,
    PERCENT_RANK() OVER (ORDER BY e.total_claim_cost DESC) AS ranking
FROM encounters AS e
JOIN claims AS c
	ON e.patient = c.patient_id
GROUP BY c.diagnosis1, e.total_claim_cost;

-- Diagnoses and diagnoses count that is frequently associated with top 10% most expensive claims
WITH cte1 AS(
SELECT 
	c.diagnosis1,
    e.total_claim_cost,
    PERCENT_RANK() OVER (ORDER BY e.total_claim_cost DESC) AS ranking
FROM encounters AS e
JOIN claims AS c
	ON e.patient = c.patient_id
),
cte2 AS(
SELECT 
	diagnosis1,
    ranking
FROM cte1
WHERE ranking <= 0.1
)
SELECT 
	diagnosis1,
    COUNT(diagnosis1) AS total_number
FROM cte2 
GROUP BY diagnosis1
ORDER BY total_number DESC;