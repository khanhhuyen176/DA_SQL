--EX1
SELECT Name FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3) , ID ASC
  
--EX2
SELECT user_id, 
UPPER(LEFT(Name,1)) || LOWER(SUBSTRING(Name,2, LENGTH(Name)-1)) AS name
FROM Users
ORDER BY user_id
  
--EX3
SELECT manufacturer, 
'$'||ROUND(SUM(total_sales)/1000000)||' million' as sale 
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer
  
--EX4
SELECT 
DATE_PART('MONTH', submit_date) AS mth,
product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY DATE_PART('MONTH', submit_date), product_id
ORDER BY mth, product_id
  
--EX5
SELECT 
sender_id,
COUNT(*) AS count_messages
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-31'
  -- HOẶC EXTRACT(MONTH FROM sent_date) = '8' AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY count_messages DESC
LIMIT 2
  
--EX6
SELECT
tweet_id 
FROM Tweets
WHERE LENGTH(content) > 15

--EX7
SELECT 
activity_date as day,
count(distinct user_id) as active_users
FROM Activity
where activity_date between '2019-06-27' and '2019-07-27'
group by activity_date

--EX8
select 
count(id) as number_employees
from employees
where extract(month from joining_date) in (1,7) and extract(year from joining_date) = 2022

--EX9
select 
position('a' in first_name)
from worker
where first_name = 'Amitah'

--EX10
select 
substring(title, length(winery)+2,4)
from winemag_p2
