-- Cleaning the data by removing all the numbers in a string 
UPDATE patients
SET 
	first_name = REGEXP_REPLACE(first_name, '[0-9]', ''),
    middle_name = REGEXP_REPLACE(middle_name, '[0-9]', ''),
	last_name = REGEXP_REPLACE(last_name, '[0-9]', '');

UPDATE payer_transitions
SET 
	owner_name = REGEXP_REPLACE(owner_name, '[0-9]', '');

UPDATE providers 
SET name = REGEXP_REPLACE(name, '[0-9]', '');

-- COMMON KEY PERFORMANCE INDICATOR 
-- 1. Readmission Rate % of patients readmitted within 30 days of discharge

WITH cte1 AS(
SELECT 
	patient,
    start,
    stop,
    encounter_class,
    LAG(encounter_class) OVER (PARTITION BY patient ORDER BY stop) AS prev_class,
    LAG(stop) OVER (PARTITION BY patient ORDER BY stop) as lag_stop,
    TIMESTAMPDIFF(day, LAG(stop) OVER (PARTITION BY patient ORDER BY stop), start) AS lag_diff
FROM encounters
ORDER BY patient, start
)
SELECT 
	((SELECT COUNT(patient) 
		FROM cte1 
		WHERE lag_diff <= 30 AND
		prev_class IN ('inpatient', 'emergency', 'urgentcare')) 
	/ 
    (SELECT COUNT(patient)
		FROM cte1
        WHERE prev_class IN ('inpatient', 'emergency', 'urgentcare')) * 100) AS readmission_rate;
				
                
-- 2. Mortality Rate % of patients who die during treatment

SELECT
	(	SELECT COUNT(DISTINCT(p.id))
		FROM patients AS p
        JOIN encounters AS e ON p.id = e.patient
        WHERE p.deathdate BETWEEN e.start AND e.stop 
	) / 
    (	SELECT COUNT(DISTINCT(id))
		FROM patients
    ) * 100 AS mortality_rate_percent;


-- 3. Average Length of Stay (ALOS) / How long patients stay admitted on average

WITH average_stay AS(
SELECT  patient,
		encounter_class,
		stop,	
		start,
		DATEDIFF(stop, start) AS date_difference,
        TIMEDIFF(stop, start) AS time_difference,
        TIMESTAMPDIFF(hour, start, stop) AS hour_difference
FROM encounters)
SELECT 
	AVG(hour_difference) AS avg_hour_per_stay,
    AVG(date_difference) AS avg_day_per_stay,
    MAX(date_difference) AS longest_day_stay
FROM average_stay
WHERE encounter_class IN ('inpatient', 'emergency', 'observation');

-- Average Length of Stay Grouped by Gender 
WITH avg_stay AS(
SELECT 
	p.id,
    p.gender,
    e.encounter_class,
	e.stop,	
	e.start,
	DATEDIFF(e.stop, e.start) AS date_difference,
	TIMEDIFF(e.stop, e.start) AS time_difference,
	TIMESTAMPDIFF(hour, e.start, e.stop) AS hour_difference
FROM patients AS p
JOIN encounters AS e 
	ON p.id = e.patient
)
SELECT 
	gender,
	AVG(hour_difference) AS avg_hour_per_stay,
    AVG(date_difference) AS avg_day_per_stay,
    MAX(date_difference) AS longest_day_stay
FROM avg_stay
WHERE encounter_class IN ('inpatient', 'emergency', 'observation')
GROUP BY gender;


-- 4. Patient Turnaround Time / Time between patient admission and discharge

WITH turnaround_time AS(
SELECT 
	start,
    stop,
    TIMESTAMPDIFF(hour, start, stop) AS time_diff
FROM encounters
)
SELECT 
    ROUND(AVG(time_diff), 2) AS avg_time
FROM turnaround_time;

-- Grouped by Gender 
WITH gender_turnaround_time AS( 
SELECT 
	p.gender, 
	e.start,
    e.stop,
    TIMESTAMPDIFF(hour, e.start, e.stop) AS time_diff
FROM encounters AS e
JOIN patients AS p 
	ON e.patient = p.id
)
SELECT 
	gender,
    ROUND(AVG(time_diff),2) AS avg_turnaround
FROM gender_turnaround_time
GROUP BY gender; 

-- Grouped by year 
WITH year_turnaround AS(
SELECT 
	start,
    stop,
    TIMESTAMPDIFF(hour, start, stop) AS time_diff
FROM encounters
)
SELECT
	YEAR(start) AS year, 
	ROUND(AVG(time_diff),2) AS avg_turnaround
FROM year_turnaround
GROUP BY YEAR(start)
ORDER BY YEAR(start) DESC;

-- 5. Cost per Patient	Total care costs divided by number of patients

SELECT 
	ROUND(AVG(healthcare_expense), 2) AS avg_cost
FROM patients;

-- By Gender 
SELECT 
	gender,
    ROUND(AVG(healthcare_expense), 2) AS avg_cost
FROM patients
GROUP BY gender;



    
	

 
