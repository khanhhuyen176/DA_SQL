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

--ex11
select name, population, area from World
where area >= 3000000 or population >= 25000000
--ex12
select name from Customer
where referee_id != 2 or referee_id is null
--ex13
SELECT part, assembly_step FROM parts_assembly
where finish_date is null
--ex14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >=70000
--ex15
select advertising_channel from uber_advertising
where money_spent > 100000 and year = 2019
