
-- WHICH SUBMISSION CHANNEL GETS THE FASTEST COMPANY RESPONSES, AND DOES IT VARY BY STATE?
-- CHANNEL EFFECTIVENESS AND TIMELINESS BY STATE


SELECT 
	state, submitted_via, COUNT(*) AS total_complaints,
	ROUND(AVG(response_time), 1) AS avg_response_days,
	ROUND(100.0 * SUM(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_timely
FROM Customer_complaints
GROUP BY state, submitted_via
HAVING COUNT(*) >= 50
ORDER BY state, pct_timely ASC
;


-- WHAT ARE THE FASTEST GROWING COMPLAINT ISSUES FOR EACH PRODUCT THIS YEAR
-- TOP ISSUES BY PRODUCT OVER TIME


WITH monthly_issue AS (
	SELECT
		DATENAME(Month,date_submitted) AS month, 
		product, issues,
		COUNT(*) AS complaint_count
	FROM Customer_complaints
	WHERE date_submitted >= DATEADD(MONTH, -18, GETDATE())
	GROUP BY DATENAME(Month, date_submitted), product, issues
),
with_lag AS (
	SELECT *,
		LAG(complaint_count, 12) OVER (PARTITION BY product, issues ORDER BY month) AS same_month_last_year
	FROM monthly_issue
)
SELECT 
	month, product, issues, complaint_count, same_month_last_year,
	ROUND(100.0 *(complaint_count - same_month_last_year) / 
	NULLIF(CAST(same_month_last_year AS FLOAT),0), 1) AS yoy_growth_pct

FROM with_lag
WHERE same_month_last_year IS NOT NULL
	AND complaint_count >= 20
ORDER BY yoy_growth_pct DESC
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY

;


-- DO CERTAIN RESPONSES ACTUALLY RESOLVE COMPLAINTS OR JUST CLOSE THEM?
-- COMPANY RESPONSE QUALITY ANALYSIS


SELECT 
	product, issues, company_response_to_consumer, COUNT(*) AS count,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY product, issues), 2) AS pct_of_issue
FROM Customer_complaints
GROUP BY product, issues, company_response_to_consumer
HAVING COUNT(*) >=30
ORDER BY product, issues, count DESC
;


-- WHICH SUB ISSUES DOMINATE EACH PARENT'S ISSUES?
-- REPEAT SUB ISSUE IDENTIFICATION VIA SUB_ISSUES


SELECT 
	product, issues, sub_issues, COUNT(*) AS complaints,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY product, issues), 2) AS pct_within_issue
FROM Customer_complaints
WHERE sub_issues IS NOT NULL
GROUP BY product, issues, sub_issues
HAVING COUNT(*) >= 25
ORDER BY product, issues, complaints DESC
;


-- WHEN AND WHERE ARE WE MISSING OUR TIMELY RESPONSE?
-- SLA BREACH HEATMAP BY PRODUCT AND MONTH


SELECT 
	DATEPART(Year, date_received) AS Year,
	DATENAME(Month, date_received) AS month,
	product, COUNT(*) AS total_complaints, 
	SUM(CASE 
			WHEN timely_response = 'No'
			THEN 1
			ELSE 0
		END
		) AS sla_breaches,
	ROUND(100.0 * 
	SUM( 
		CASE 
			WHEN timely_response = 'No'
			THEN 1
			ELSE 0
		END
		) / COUNT(*), 2) AS breach_rate_pct

FROM Customer_complaints
WHERE date_received IS NOT NULL
GROUP BY DATEPART(Year, date_received), DATENAME(Month, date_received), product
HAVING COUNT(*) >= 40
ORDER BY breach_rate_pct DESC
;


-- DOES POSTING A PUBLIC RESPONSE CORRELATE WITH FASTER INTERNAL RESOLUTION?
-- PUBLIC RESPONSE STRATEGY EFFECTIVENESS


WITH company_stats AS (
	SELECT 
		product, sub_product, company_public_response,
		COUNT(*) AS complaints,
		AVG(CAST(response_time AS FLOAT)) AS avg_days_to_respond
	FROM Customer_complaints
	GROUP BY product, sub_product, company_public_response
)
SELECT
	*, 
	ROUND(100.0 * complaints / SUM(complaints) 
	OVER (PARTITION BY product, sub_product), 2) AS pct_of_subproduct
FROM company_stats
WHERE company_public_response IS NOT NULL
ORDER BY product,sub_product, complaints DESC
;


-- WHICH STATES ARE OVER INDEXED FOR COMPLAINTS RELATIVE TO POPULATION?
-- GEOGRAPHIC COMPLAINTS DENSITY VS POPULATION


WITH state_counts AS (
	SELECT state, COUNT(*) AS complaint_count
	FROM Customer_complaints
	GROUP BY state
),
state_pop AS (
	SELECT 'CA' AS state, 3.95 AS pop_millions UNION ALL
	SELECT 'FL', 21.8 UNION ALL
	SELECT 'TX', 29.5 UNION ALL
	SELECT 'NY', 19.8 UNION ALL
	SELECT 'DE', 1.0
) 
SELECT 
	sc.state, sc.complaint_count, sp.pop_millions,
	ROUND(sc.complaint_count / sp.pop_millions, 1) AS complaints_per_million
FROM state_counts sc
JOIN state_pop sp
ON sc.state = sp.state
ORDER BY complaints_per_million DESC
;


-- WHICH ISSUE TYPES TAKE LONGEST TO RESOLVE AND ARE WE IMPROVING
-- ISSUE RESOLUTION VELOCITY


SELECT 
	DATEPART(QUARTER, date_received) AS qrt_start,
	issues, COUNT(*) AS volume,
	ROUND(AVG(CAST(response_time AS FLOAT)), 1) AS avg_days,
	 ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY response_time) 
	 OVER (PARTITION BY DATEPART(QUARTER, date_received), issues), 1) AS p90_days
FROM Customer_complaints
WHERE response_time IS NOT NULL
	AND date_received >= DATEADD(Year, -2, GETDATE())
GROUP BY DATEPART(QUARTER, date_received), issues
HAVING COUNT(*) >= 100
ORDER BY qrt_start, avg_days DESC
;


-- ARE WE SEEING REPEATED COMPLAINTS ON THE SAME PRODUCT/ISSUES IN A STATE?
-- REPEAT COMPLAINT SIGNALS


WITH base AS (
	SELECT 
		*, ROW_NUMBER () OVER  (
			PARTITION BY state, product, sub_product, issues
			ORDER BY date_submitted
			) AS rn
	FROM Customer_complaints
)
SELECT 
	product, issues, state,
	COUNT(*) AS repeat_complaint_signal, 
	MIN(date_submitted) AS first_seen,
	MAX(date_submitted) AS last_seen
FROM base
GROUP BY product, issues, state
HAVING COUNT(*) >= 5
ORDER BY repeat_complaint_signal DESC
;



