--EX1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2=0
--EX2
SELECT 
    COUNT(CITY) -  COUNT(DISTINCT CITY) AS difference
FROM STATION;
--EX3

--EX4
SELECT ROUND(SUM(item_count * order_occurrences) ::DECIMAL / SUM(order_occurrences), 1) AS mean
FROM items_per_order;
--EX5
SELECT DISTINCT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING count(skill) > 2
ORDER BY candidate_id ASC
--EX6
SELECT user_id, date_part('day', max(post_date) - min(post_date)) as days_between FROM posts
WHERE date_part('year', post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) >=2
--EX7
SELECT card_name, max(issued_amount)-min(issued_amount) as difference FROM monthly_cards_issued
GROUP BY card_name
HAVING count(issue_month) >2
ORDER BY max(issued_amount)-min(issued_amount) DESC
--EX8
SELECT manufacturer, COUNT(drug) AS count_drug, sum(cogs-total_sales) AS total_loss FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC
--EX9
select * from Cinema
where id % 2 != 0 and description != 'boring'
order by rating DESC
--EX10
select teacher_id , count(distinct subject_id) as cnt from Teacher
group by teacher_id
--EX11
select user_id, count(follower_id ) as followers_count from Followers
group by user_id
order by user_id
--EX12
select class from Courses
group by class
having count(class) >=5
