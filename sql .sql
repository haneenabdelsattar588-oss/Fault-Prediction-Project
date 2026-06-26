CREATE DATABASE IF NOT EXISTS Final_project;
USE Final_project;
SELECT * FROM maintenance_downtime_dirty;

DROP TABLE IF EXISTS dim_machine;
CREATE TABLE IF NOT EXISTS fact_maintenance AS
SELECT 
UDI,
Product_ID,
Machine_Type,
Air_Temperature_K,
Process_Temperature_K,
Rotational_Speed_rpm,
Torque_Nm,
Tool_Wear_min,
Machine_Failure,
TWF,
HDF,
PWF,
OSF,
RNF
FROM maintenance_downtime_dirty;

ALTER TABLE fact_maintenance
ADD PRIMARY KEY (UDI);

ALTER TABLE fact_maintenance
ADD COLUMN maintenance_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

SET SQL_SAFE_UPDATES = 0;

UPDATE Fact_maintenance
SET Machine_Type = 'L'
WHERE Machine_Type = 'LOW';

UPDATE Fact_maintenance
SET Machine_Type = 'M'
WHERE Machine_Type = 'Med';

UPDATE Fact_maintenance
SET Machine_Type = 'H'
WHERE Machine_Type = 'HIGH';

SELECT maintenance_id,COUNT(*) AS duplicate_count
FROM fact_maintenance
GROUP BY maintenance_id
HAVING COUNT(*) > 1;

SELECT * FROM fact_maintenance;

SELECT COUNT(*) AS total_records
FROM fact_maintenance;

SELECT COUNT(*) AS total_failures
FROM fact_maintenance
WHERE Machine_Failure = 1;

SELECT COUNT(*) AS no_failures
FROM fact_maintenance
WHERE Machine_Failure = 0;

SELECT AVG(Air_Temperature_K) AS avg_air_temp
FROM fact_maintenance;

SELECT AVG(Process_Temperature_K) AS avg_process_temp
FROM fact_maintenance;

SELECT AVG(Rotational_Speed_rpm) AS avg_speed
FROM fact_maintenance;

SELECT MAX(Torque_Nm) AS max_torque
FROM fact_maintenance;

SELECT MIN(Torque_Nm) AS min_torque
FROM fact_maintenance;

SELECT Machine_Type, COUNT(*) AS total
FROM fact_maintenance
GROUP BY Machine_Type;

SELECT Machine_Type, COUNT(*) AS failure_count
FROM fact_maintenance
WHERE Machine_Failure = 1
GROUP BY Machine_Type;

SELECT Machine_Type,AVG(Torque_Nm) AS avg_torque
FROM fact_maintenance
GROUP BY Machine_Type;

SELECT COUNT(*) AS tool_wear_failures
FROM fact_maintenance
WHERE TWF = 1;

SELECT COUNT(*) AS heat_failures
FROM fact_maintenance
WHERE HDF = 1;

SELECT COUNT(*) AS power_failures
FROM fact_maintenance
WHERE PWF = 1;

SELECT COUNT(*) AS overstrain_failures
FROM fact_maintenance
WHERE OSF = 1;

SELECT COUNT(*) AS random_failures
FROM fact_maintenance
WHERE RNF = 1;

SELECT Machine_Type,COUNT(*) AS total_machines,
SUM(Machine_Failure) AS total_failures,
ROUND((SUM(Machine_Failure)/COUNT(*))*100,2) AS failure_rate
FROM Fact_maintenance
GROUP BY Machine_Type;

SELECT *
FROM fact_maintenance
WHERE Torque_Nm > 50;

SELECT *
FROM fact_maintenance
WHERE Tool_Wear_min > 200;

SELECT UDI,Machine_Type,Air_Temperature_K,Process_Temperature_K
FROM fact_maintenance
WHERE Machine_Failure = 1
AND Process_Temperature_K > 310;

SELECT * FROM fact_maintenance
ORDER BY Rotational_Speed_rpm DESC
LIMIT 10;

SELECT ROUND((SUM(Machine_Failure) / COUNT(*)) * 100,2) AS failure_percentage
FROM fact_maintenance;

SELECT AVG(Tool_Wear_min) AS avg_tool_wear_failed
FROM fact_maintenance
WHERE Machine_Failure = 1;

SELECT AVG(Torque_Nm) AS avg_failed_torque
FROM fact_maintenance
WHERE Machine_Failure = 1;

SELECT Machine_Type,
       COUNT(*) AS failures
FROM fact_maintenance
WHERE Machine_Failure = 1
GROUP BY Machine_Type
ORDER BY failures DESC;
