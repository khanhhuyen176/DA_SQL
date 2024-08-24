--task1
select
    extract(year from created_at)|| '-' ||extract(month from created_at) AS month_year, 
    COUNT(DISTINCT user_id) AS total_user, 
    COUNT(order_id) AS total_order
from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete'
      and
      created_at BETWEEN '2019-01-01' AND '2022-04-30'
group by month_year
order by month_year
--INSIGHT: 
/*2019 đến đầu 2020: Số lượng người mua và đơn hàng tăng nhẹ, ổn định.
Giữa 2020 đến 2021: Số lượng người mua và đơn hàng tăng mạnh, đặc biệt vào cuối 2021.
Cuối 2021 đến 2022: Có dấu hiệu giảm nhẹ nhưng vẫn duy trì ở mức cao.*/
