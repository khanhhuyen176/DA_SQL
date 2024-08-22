/* Năm 2020, các ngày 28, 29, 30/4 là những ngày có doanh thu rất cao. 
Đó là lý do sếp muốn muốn xem dữ liệu vào những ngày đó.
Hãy tìm số tiền thanh toán trung bình được nhóm theo 
khách hàng và ngày thanh toán – chỉ xem xét những ngày mà 
khách hàng có nhiều hơn 1 khoản thanh toán. 
Sắp xếp theo số tiền trung bình theo thứ tự giảm dần.*/
select customer_id, DATE(payment_date),
avg(amount) as avg_mount, count(payment_id) as so_lan_khoan_tt
-- hoặc: count(*) đều được
	from payment
-- hoặc: where DATE(payment_date) in ('2020-04-28', '2020-04-29', '2020-04-30')
 where date(payment_date) between '2020-04-28' and  '2020-04-30'
group by customer_id, DATE(payment_date)
having count(payment_id) >1
order by avg(amount) desc