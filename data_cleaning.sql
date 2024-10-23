-- Create database if it doesn't already exist
create database if not exists sql_dc;

-- Switch to the 'sql_dc' database
use sql_dc;

-- View all data in the 'laptopdata' table
select * from laptopdata;

-- Create a backup of the 'laptopdata' table structure
create table laptops_backup like laptopdata;

-- Insert all data from 'laptopdata' into 'laptops_backup'
insert into laptops_backup 
select * from laptopdata;

-- View data from the backup table
select * from laptops_backup;

-- Count the number of rows in the backup table
select count(*) from laptops_backup;

-- Check if the 'laptopdata' table exists in the 'sql_dc' schema
select * from information_schema.tables 
where table_schema = 'sql_dc' 
and table_name = 'laptopdata';

-- Rename the 'Unnamed: 0' column to 'index' and change its type to int
alter table laptopdata
change column `Unnamed: 0` `index` int;

-- View updated data in 'laptopdata'
select * from laptopdata;

-- Delete rows where all columns (Company, TypeName, etc.) have null values
delete from laptopdata 
where `index` in (select `index` from laptopdata 
where Company is null and TypeName is null and Inches is null and ScreenResolution is null 
and Cpu is null and Ram is null and Memory is null and Gpu is null and OpSys is null and 
Weight is null and Price is null);

-- Check for duplicate rows based on multiple columns
SELECT Company, TypeName, Inches, ScreenResolution, Cpu, Ram, Memory, Gpu, OpSys, Weight, Price, COUNT(*)
FROM laptopdata
GROUP BY Company, TypeName, Inches, ScreenResolution, Cpu, Ram, Memory, Gpu, OpSys, Weight, Price
HAVING COUNT(*) > 1;

-- Select distinct values of various columns for inspection
select distinct Company from laptopdata;
select distinct TypeName from laptopdata;
select distinct Inches from laptopdata;
select distinct ScreenResolution from laptopdata;
select distinct Cpu from laptopdata;
select distinct Ram from laptopdata;

-- Disable safe updates for the session (to allow updates without WHERE clause)
SET SQL_SAFE_UPDATES = 0;

-- Remove the 'GB' string from the 'Ram' column values
UPDATE laptopdata l1
JOIN laptopdata l2 ON l1.index = l2.index
SET l1.Ram = REPLACE(l2.Ram, 'GB', '');

-- Change 'Ram' column type to integer
alter table laptopdata modify column Ram integer;

-- Remove the 'kg' string from the 'Weight' column values
UPDATE laptopdata l1
JOIN laptopdata l2 ON l1.index = l2.index
SET l1.Weight = REPLACE(l2.Weight, 'kg', '');

-- Round the values in the 'Price' column
UPDATE laptopdata l1
JOIN laptopdata l2 ON l1.index = l2.index
SET l1.Price = ROUND(l2.Price);

-- Change 'Price' column type to integer
alter table laptopdata modify column Price integer;

-- Check distinct values of 'OpSys'
select distinct OpSys from laptopdata;

-- Categorize operating systems into broader groups (macOS, Windows, Linux, etc.)
select OpSys,
case 
	when OpSys like '%mac%' then 'macos'
    when OpSys like '%windows%' then 'windows'
    when OpSys like '%linux%' then 'linux'
    when OpSys = 'No OS' then 'N/A'
    else 'other'
end as os_brand
from laptopdata;

-- Update the 'OpSys' column with the categorized values
update laptopdata 
set OpSys  = case 
	when OpSys like '%mac%' then 'macos'
    when OpSys like '%windows%' then 'windows'
    when OpSys like '%linux%' then 'linux'
    when OpSys = 'No OS' then 'N/A'
    else 'other'
end;

-- View the updated 'OpSys' column
select OpSys from laptopdata;

-- View 'Gpu' column values
select Gpu from laptopdata;

-- Add new columns for GPU brand and GPU name
alter table laptopdata 
add column gpu_brand varchar(255) after Gpu,
add column gpu_name varchar(255) after gpu_brand;

-- View updated table structure
select * from laptopdata;

-- Extract GPU brand from 'Gpu' column and update 'gpu_brand'
UPDATE laptopdata l1
JOIN (SELECT `index`, substring_index(Gpu, ' ', 1) AS gpu_brand 
      FROM laptopdata) AS l2
ON l1.`index` = l2.`index`
SET l1.gpu_brand = l2.gpu_brand;

-- Extract GPU name by removing the brand from 'Gpu' and update 'gpu_name'
UPDATE laptopdata l1
JOIN (select replace(Gpu, gpu_brand, '') as gpu_name 
from laptopdata) AS l2
SET l1.gpu_name= l2.gpu_name;

-- Remove the original 'Gpu' column
alter table laptopdata drop column Gpu;

-- Add new columns for CPU brand, name, and speed
alter table laptopdata
add column cpu_brand varchar(255) after Cpu,
add column cpu_name varchar(255) after cpu_brand,
add column cpu_speed decimal(10,1) after cpu_name;

-- Extract CPU brand from 'Cpu' column and update 'cpu_brand'
UPDATE laptopdata l1
JOIN (SELECT `index`, substring_index(Cpu, ' ', 1) AS cpu_brand 
      FROM laptopdata) AS l2
ON l1.`index` = l2.`index`
SET l1.cpu_brand = l2.cpu_brand;

-- Extract CPU speed from 'Cpu' and update 'cpu_speed'
UPDATE laptopdata l1
JOIN (SELECT replace(substring_index(Cpu, ' ', -1),'GHz','') AS cpu_speed
      FROM laptopdata) AS l2
SET l1.cpu_speed = l2.cpu_speed;

-- Clear the 'cpu_name' column
update laptopdata  
set cpu_name = NULL;

-- Extract CPU name and update 'cpu_name'
UPDATE laptopdata l1
JOIN (
  SELECT `index`, 
         TRIM(REPLACE(REPLACE(Cpu, cpu_brand, ''), SUBSTRING_INDEX(REPLACE(Cpu, cpu_brand, ''), ' ', -1), '')) AS cpu_name
  FROM laptopdata
) l2 ON l1.`index` = l2.`index`
SET l1.cpu_name = l2.cpu_name;

-- Trim the CPU name to the first two words (e.g., 'Intel Core')
update laptopdata
set cpu_name = substring_index(trim(cpu_name),' ',2);

-- Remove the original 'Cpu' column
alter table laptopdata drop column Cpu;

-- Add new columns for screen resolution width and height
alter table laptopdata 
add column resolution_width integer after ScreenResolution,
add column resolution_height integer after resolution_width;

-- Extract and display screen resolution width and height
SELECT ScreenResolution,
       SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', 1) AS width,
       SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', -1) AS height
FROM laptopdata;

-- Update the new resolution columns with extracted width and height
UPDATE laptopdata
SET 
    resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', 1),
    resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', -1);

-- Add a new column for identifying touchscreen laptops
alter table laptopdata 
add column touch_screen integer after resolution_height;

-- Update the 'touch_screen' column based on whether the screen is labeled as 'Touch'
update laptopdata 
set touch_screen = ScreenResolution like '%Touch%';

-- Display the updated table with new columns
select * from laptopdata;

-- View 'memory' column values
select memory from laptopdata;

-- Add new columns for memory type, primary storage, and secondary storage
alter table laptopdata
add column type varchar(255) after memory,
add column primary_storage integer after type,
add column secondary_storage integer after primary_storage;

-- Display the updated table
select * from laptopdata;

-- Update the memory type (HDD, SSD, Hybrid, etc.) based on the 'memory' column
update laptopdata 
set type = 
case
	when memory like '%HDD%' and memory like '%SDD%' then 'Hybrid'
    when memory like '%HDD%' then 'HDD'
    when memory like '%SSD%' then 'SSD'
    when memory like '%Flash Storage%' then 'Flash Storage'
    when memory like '%Hybrid%' then 'Hybrid'
	when memory like '%HDD%' and memory like '%Flash Storage%' then 'Hybrid'
    else null
end;

-- Extract and update primary and secondary storage capacities
UPDATE laptopdata
SET 
    primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(memory, '+', 1), '[0-9]+'),
    secondary_storage = CASE 
        WHEN memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(memory, '+', -1), '[0-9]+') 
        ELSE 0 
    END;

-- Display primary and secondary storage, converting TB to GB if necessary
select primary_storage,
case when primary_storage <= 2 then primary_storage*1024 else primary_storage end,
secondary_storage,
case when secondary_storage <= 2 then secondary_storage*1024 else secondary_storage end
from laptopdata;

-- Update storage values to convert TB to GB where needed
update laptopdata
set primary_storage = case when primary_storage <= 2 then primary_storage*1024 else primary_storage end,
secondary_storage = case when secondary_storage <= 2 then secondary_storage*1024 else secondary_storage end;

-- Remove the original 'memory' column
alter table laptopdata drop column memory;

-- Display the final cleaned dataset
select * from laptopdata;
