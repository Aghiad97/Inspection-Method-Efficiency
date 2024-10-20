use Defects;

UPDATE Defects.Products_defects_data
SET defect_date = STR_TO_DATE(your_date_column, '%Y-%m-%d');

SELECT * FROM Defects.Products_defects_data;

-- 1-Detect duplicates:
SELECT defect_id, COUNT(*)
FROM Defects.Products_defects_data
GROUP BY defect_id
HAVING COUNT(*) > 1; -- NO duplicates detected

-- Remove duplicates if founded:
DELETE t1
FROM defects_data t1
INNER JOIN (
    SELECT defect_id, MIN(rowid) AS min_rowid
    FROM defects_data
    GROUP BY defect_id
    HAVING COUNT(*) > 1
) t2
ON t1.defect_id = t2.defect_id AND t1.rowid > t2.min_rowid;

-- 2- detect missing values:
SELECT *
FROM Defects.Products_defects_data
WHERE defect_id IS NULL
   OR product_id IS NULL
   OR defect_type IS NULL
   OR defect_date IS NULL
   OR defect_location IS NULL
   OR severity IS NULL
   OR inspection_method IS NULL
   OR repair_cost IS NULL;
   
-- Handling Missing values if detected:
UPDATE Defects.Products_defects_data
SET defect_id = 'missed'
WHERE defect_id IS NULL;

UPDATE Defects.Products_defects_data
SET product_id = 'missed'
WHERE product_id IS NULL;

UPDATE Defects.Products_defects_data
SET defect_type = 'missed'
WHERE defect_type IS NULL;

UPDATE Defects.Products_defects_data
SET defect_date = 'missed'
WHERE defect_date IS NULL;

UPDATE Defects.Products_defects_data
SET defect_location = 'missed'
WHERE defect_location IS NULL;

UPDATE Defects.Products_defects_data
SET severity = 'missed'
WHERE severity IS NULL;

UPDATE Defects.Products_defects_data
SET inspection_method = 'missed'
WHERE inspection_method IS NULL;

UPDATE Defects.Products_defects_data
SET repair_cost = 0
WHERE repair_cost IS NULL;


-- 3- SPELL CHECK: SQL does not have built-in spell-checking functionality like Google Sheets,
-- but you can check for inconsistent values in categorical columns (defect_type, defect_location,
-- severity, inspection_method).
-- For example, to verify unique values in defect_type:
SELECT DISTINCT defect_type 
FROM Defects.products_defects_data
LIMIT 10;
-- However i checked misspelling for all columns and I found none
    
-- 4- Detect white spaces:
SELECT *
FROM Defects.products_defects_data
WHERE defect_type LIKE ' %'
   OR defect_type LIKE '% '
   OR defect_location LIKE ' %'
   OR defect_location LIKE '% '
   OR severity LIKE ' %'
   OR severity LIKE '% '
   OR inspection_method LIKE ' %'
   OR inspection_method LIKE '% '; -- No White spaces detected

-- remove white spaces if detected
UPDATE Defects.products_defects_data
SET defect_type = TRIM(defect_type),
    defect_location = TRIM(defect_location),
    severity = TRIM(severity),
    inspection_method = TRIM(inspection_method);
    
-- 5- change formatting to lower_case;
UPDATE defects_data
SET defect_type = LOWER(defect_type);

UPDATE defects_data
SET defect_location = LOWER(defect_location);

UPDATE defects_data
SET severity = LOWER(severity);

UPDATE defects_data
SET inspection_method = LOWER(inspection_method);

-- verify changes:
SELECT DISTINCT defect_type FROM defects_data;
SELECT DISTINCT defect_location FROM defects_data;
SELECT DISTINCT severity FROM defects_data;
SELECT DISTINCT inspection_method FROM defects_data;

-- defect_date: a white spaces detected and the dates are in string format:
UPDATE Defects.products_defects_data
SET defect_date = STR_TO_DATE(TRIM(defect_date) , '%m/%d/%Y')  -- trim() function remove the white spaces and STR_TO_DATE() cahnge its format to date
WHERE defect_date IS NOT NULL;


    

