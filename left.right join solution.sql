select * from bookings.seats
-- ghế nào được booking nhiều nhất
select t1.seat_no, count(t1.seat_no) as so_luong_seat
	from bookings.seats as t1
left join bookings.boarding_passes as t2
on t1.seat_no = t2.seat_no
group by t1.seat_no
order by so_luong_seat desc 
	
-- có ghế nào bị null hay hay không
	-- seat: ghế đã đặt
	-- boarding_passes: ghế ban đầu khi chưa đặt trong mỗi chuyến bay
select t1.seat_no
	from bookings.seats as t1
left join bookings.boarding_passes as t2
on t1.seat_no = t2.seat_no
where t2.seat_no is null
	
-- line nào được booking nhiều nhất
select 
	right(t1.seat_no,1) as line , count(t1.seat_no) as so_luong_line
	from bookings.seats as t1
left join bookings.boarding_passes as t2
on t1.seat_no = t2.seat_no
group by right(t1.seat_no,1)
order by so_luong_line desc
	

