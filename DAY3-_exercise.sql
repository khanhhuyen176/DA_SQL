--ex1
SELECT NAME FROM CITY
WHERE POPULATION > 120000 AND COUNTRYCODE = 'USA'
--ex2
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN'
--ex3
SELECT CITY, STATE FROM STATION;
--ex4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE "a%"
    or CITY LIKE "e%"
    or CITY LIKE "i%"
    or CITY LIKE "o%"
    or CITY LIKE "u%"
--ex5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%a' 
   OR CITY LIKE '%e' 
   OR CITY LIKE '%i' 
   OR CITY LIKE '%o' 
   OR CITY LIKE '%u';
--ex6
select distinct CITY from STATION
WHERE NOT 
    (CITY LIKE "u%"
    or CITY LIKE "e%"
    or CITY LIKE "o%"
    or CITY LIKE "a%"
    or CITY LIKE "i%")

--ex8
select name from Employee 
where salary > 2000 and months <10
order by employee_id
--ex7
select name from Employee
order by name 
--ex9
select product_id from Products
where low_fats = "Y" and recyclable = 'Y'
--ex10

