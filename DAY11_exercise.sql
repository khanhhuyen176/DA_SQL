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

--MID
--Q1
select distinct replacement_cost
from public.film
ORDER BY replacement_cost

--Q2
SELECT 
    SUM(CASE 
        WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 
    END) AS low,
	
    SUM(CASE 
        WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1 
    END) AS medium,
	
    SUM(CASE 
        WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1 
    END) AS high
	
FROM public.film;

--Q3
select 
	f.title, f.length, c.name
from public.film as f
inner join public.film_category as fc
on f.film_id = fc.film_id
inner join public.category as c
on c.category_id = fc.category_id
where name in ('Drama','Sports')
order by f.length desc

--Q4
select 
	COUNT(f.title) || ' titles' as count_titles , c.name
from public.film as f
inner join public.film_category as fc
on f.film_id = fc.film_id
inner join public.category as c
on c.category_id = fc.category_id
GROUP BY c.name
order by count_titles desc

--Q5
SELECT 
	a.first_name, a.last_name, count(f.film_id) || ' movies' as count_films
FROM public.film AS f
INNER JOIN public.film_actor AS fa
ON f.film_id = fa.film_id
INNER JOIN public.actor AS a
ON a.actor_id = fa.actor_id
group by a.first_name, a.last_name
order by count_films desc

--Q6
SELECT count(a.address)
FROM public.address AS a
LEFT JOIN public.customer AS c
ON c.address_id = a.address_id
WHERE c.customer_id is null

--Q7
select 
	ci.city, SUM(p.amount) as total_amount
from public.payment as p
inner join public.customer as c
	on p.customer_id = c.customer_id
inner join public.address as a
	on a.address_id = c.address_id
inner join public.city as ci
	on ci.city_id = a.city_id
GROUP BY ci.city 
ORDER BY total_amount DESC

--Q8
select 
	concat(ci.city,', ',co.country) as infor,
	sum(p.amount) as total_amount
from public.payment as p
inner join public.customer as c
	on p.customer_id = c.customer_id
inner join public.address as a
	on a.address_id = c.address_id
inner join public.city as ci
	on ci.city_id = a.city_id
inner join public.country as co
	on co.country_id = ci.country_id
GROUP BY concat(ci.city,', ',co.country)
order by total_amount
