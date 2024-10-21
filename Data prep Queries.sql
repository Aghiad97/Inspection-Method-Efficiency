USE Defects;
-- 1- Month-over-month repair costs by inspection method
WITH MonthlyDefects AS (
  SELECT
    DATE_FORMAT(STR_TO_DATE(TRIM(defect_date), '%m/%d/%Y'), '%Y-%m') AS month,
    inspection_method,
    COUNT(defect_id) AS total_defects
  FROM
    Defects.products_defects_data
  GROUP BY
    1, 2
)
SELECT
  month,
  inspection_method,
  total_defects,
  ROUND((total_defects / SUM(total_defects) OVER (PARTITION BY month)),3) AS percentage -- SUM(total_defects) OVER (PARTITION BY month)) it calculates the total number of defects for a given month, regardless of the inspection method.
FROM
  MonthlyDefects
ORDER BY
  1, 2;

-- 2
SELECT 
    inspection_method,             -- Group by defect location (Component, Internal, Surface)
    defect_location,           -- Group by inspection method (automated, manual, visual)
    COUNT(defect_id) AS total_defects 			 -- Sum the defect IDs for each inspection/location combination
FROM 
    Defects.products_defects_data
GROUP BY 
    1,             -- Group by location
    2                     -- Group by severity
ORDER BY 
    1, 2;    -- Order results for better readability
    
-- 3
-- inspection method efficiency of detecting repair cost and severity
SELECT 
    inspection_method,                -- Group by inspection method
    severity,                         -- Group by defect severity (Minor, Moderate, Critical)
    COUNT(defect_id) AS total_defect -- Number of defects found by each method and severity
FROM 
    Defects.products_defects_data
GROUP BY 
    1, 2       -- Group by both inspection method and severity
ORDER BY 
    1, 2;      -- Order for better readability
    
-- 4
-- defect to product ratio and high cost defect by product:
    WITH average_cost AS (
    -- Step 1: Calculate the overall average repair cost
    SELECT 
        AVG(repair_cost) AS avg_repair_cost
    FROM 
        Defects.Products_defects_data
),
high_cost_defects AS (
    -- Step 2: Identify defects with repair costs higher than the average
    SELECT 
        defect_id,
        product_id,
        defect_type,
        severity,
        inspection_method,
        repair_cost
    FROM 
        Defects.Products_defects_data
    WHERE 
        repair_cost > (SELECT avg_repair_cost FROM average_cost)
)
-- Step 3: Analyze high-cost defects by severity, defect type, and inspection method
SELECT 
    defect_type,
    severity,
    inspection_method,
    COUNT(*) AS defect_count,
    ROUND(AVG(repair_cost),3) AS avg_high_repair_cost,
    ROUND(SUM(repair_cost),3) AS total_high_repair_cost
FROM 
    high_cost_defects
GROUP BY 
    defect_type, severity, inspection_method
ORDER BY 
    total_high_repair_cost DESC;


