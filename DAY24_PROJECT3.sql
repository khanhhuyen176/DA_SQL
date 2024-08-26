select * from public.sales_dataset_rfm_prj_clean

-- 1) Doanh thu theo từng ProductLine, Year  và DealSize?
-- Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE
	SELECT 
    ProductLine,
    Year_id,
    DealSize,
    SUM(sales) AS revenue
FROM 
    public.sales_dataset_rfm_prj_clean
GROUP BY 1,2,3
ORDER BY 
    ProductLine,
    Year_id,
    DealSize;

-- 2) Đâu là tháng có 'revenue' bán tốt nhất mỗi năm?
-- Output: MONTH_ID, REVENUE, ORDER_NUMBER
with revenue_data as(
	SELECT 
			SUM(sales) as revenue,
			month_id,
			year_id
	from public.sales_dataset_rfm_prj_clean
	group by 2,3

), rank_revenue as(
	select *,
			rank() over(partition by year_id order by revenue desc) as ORDER_NUMBER
	FROM revenue_data 
)
select 
		month_id,
		revenue,
		ORDER_NUMBER
from rank_revenue
where ORDER_NUMBER = 1

-- 3) Product line nào được bán nhiều ở tháng 11?
-- Output: MONTH_ID, REVENUE, ORDER_NUMBER
with revenue_data as(
	SELECT 
			SUM(sales) as revenue,
			month_id,
			year_id,
			productline
	from public.sales_dataset_rfm_prj_clean
	where month_id = 11
	group by 2,3,4
), rank_revenue as(
	select *,
			rank() over(partition by year_id order by revenue desc) as ORDER_NUMBER
	FROM revenue_data 
)
select 
		month_id,
		revenue,
		ORDER_NUMBER
from rank_revenue
where ORDER_NUMBER = 1

-- 4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
-- Xếp hạng các các doanh thu đó theo từng năm.
-- Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK
with revenue_data as(
	SELECT 
		country,
		productline,
	    year_id,
        sum(sales) AS revenue
	from public.sales_dataset_rfm_prj_clean
	where country = 'UK'
	GROUP BY 1,2,3
), rank_revenue as(
	select *,
			rank() over(partition by year_id order by revenue desc) as rank
	FROM revenue_data 
)
select 
		year_id,
		productline,
		revenue,
		rank
from rank_revenue
where rank = 1

-- 5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
--(sử dụng lại bảng customer_segment ở buổi học 23)










