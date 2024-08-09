--EX1
SELECT 
sum(CASE
when device_type = 'laptop' then 1
end) as laptop_reviews,
sum(case
when device_type in ('tablet','phone') then 1
end) as mobile_views
FROM viewership

--EX2
SELECT x,y,z,
CASE 
WHEN x+y > z and x+z> y and y+z> x then 'Yes'
else 'No'
end as triangle
FROM Triangle

--EX3
SELECT 
round(
(SUM(CASE
WHEN call_category= 'n/a' OR call_category IS NULL then 1 
end) * 100.0) / count(*),1) as uncategorised_call_pct
FROM callers
        -- cách 2: 
SELECT 
    ROUND(
        (CAST(SUM(CASE
            WHEN call_category = 'n/a' OR call_category IS NULL OR call_category = '' THEN 1 
        END) AS DECIMAL) / COUNT(*)) * 100, 1) AS uncategorised_call_pct
FROM callers;

--EX4
SELECT
name
FROM Customer
where referee_id is null or referee_id <> 2

--EX5
select 
survived,
SUM(
CASE
WHEN pclass = 1 then 1
end) as class,

SUM(
CASE
WHEN pclass = 2 then 1
end) as second_class, 

SUM(
CASE
WHEN pclass = 3 then 1
end) as third_class

from titanic
group by survived
