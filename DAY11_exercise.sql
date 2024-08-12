--EX1
select  COUNTRY.Continent, floor(avg(CITY.Population)) AS AverageCityPopulation
from COUNTRY  
inner join  CITY 
on CITY.CountryCode = COUNTRY.Code
group by COUNTRY.Continent

--EX2
SELECT 
ROUND(CAST(
COUNT( DISTINCT case when t.signup_action = 'Confirmed' then e.user_id end) AS decimal) 
  / COUNT(DISTINCT e.user_id),2) AS confirm_rate
FROM emails AS e
LEFT JOIN texts AS t
ON e.email_id = t.email_id

--EX3
SELECT a.age_bucket,
ROUND(SUM(CASE 
WHEN ac.activity_type = 'send' THEN ac.time_spent 
END) / 
SUM(time_spent) * 100.0 ,2) AS send_perc,

ROUND(SUM(CASE 
WHEN ac.activity_type = 'open' THEN ac.time_spent 
END) / 
SUM(time_spent) * 100.0 ,2) AS open_perc

FROM activities as ac
INNER JOIN age_breakdown as a
ON ac.user_id = a.user_id
WHERE ac.activity_type IN ('send', 'open') 
GROUP BY a.age_bucket

--EX4
SELECT customer_id
FROM customer_contracts cc
JOIN products p ON cc.product_id = p.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT p.product_category) = (SELECT COUNT(DISTINCT product_category) FROM products);

--EX5
SELECT
    m.employee_id,
    m.name,
    COUNT(e.employee_id) AS reports_count,
    ROUND(AVG(e.age),0) AS average_age
FROM Employees m
INNER JOIN Employees e ON m.employee_id = e.reports_to
GROUP BY m.employee_id, m.name
ORDER BY m.employee_id;

--EX6
SELECT 
    p.product_name, 
    SUM(o.unit) as unit
FROM Products AS p
LEFT JOIN Orders AS o
    ON p.product_id = o.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100

--EX7
SELECT DISTINCT
p.page_id
FROM pages as p
LEFT JOIN page_likes as k
ON p.page_id = k.page_id
WHERE liked_date is null
ORDER BY p.page_id

--
