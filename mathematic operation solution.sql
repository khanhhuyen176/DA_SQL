/* Quản lý của bạn đang nghĩ đến việc tăng giá cho những bộ
phim có chi phí thay thế cao. Vì vậy, bạn nên tạo một danh
sách các bộ phim có giá thuê ít hơn 4% chi phí thay thế.
Tạo danh sách film_id đó cùng với tỷ lệ phần trăm (giá
thuê/chi phí thay thế) được làm tròn đến 2 chữ số thập
phân. */
select film_id, rental_rate, replacement_cost,
	round(rental_rate / replacement_cost*100,2) as "tỷ lệ phần trăm"
	from film
where round(rental_rate / replacement_cost*100,2)< 4