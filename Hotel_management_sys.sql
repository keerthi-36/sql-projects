create database Hotel_Management_System;
use Hotel_Management_System;

create table Hotels(
	hotel_id int primary key auto_increment,
    hotel_name varchar(50),
    city varchar(40),
    star_rating int);
    
insert into hotels(hotel_name, city, star_rating)values
('Grand Palace', 'Chennai', 5),
('Royal Inn', 'Bangalore', 4),
('Blue Moon', 'Hyderabad', 3);

create table rooms(
    room_id int primary key auto_increment,
    hotel_id int,
    room_number varchar(10),
    room_type varchar(20),
    price decimal(10,2),
    status varchar(20),
    
    foreign key(hotel_id)
    references hotels(hotel_id)
);

insert into rooms(hotel_id, room_number, room_type, price, status)
values(1, '101', 'Standard', 2500, 'Available'),
(1, '102', 'Deluxe', 4000, 'Occupied'),
(1, '103', 'Suite', 7000, 'Occupied'),
(2, '201', 'Standard', 2200, 'Available'),
(2, '202', 'Deluxe', 3800, 'Occupied'),
(3, '301', 'Standard', 1800, 'Available'),
(3, '302', 'Suite', 6000, 'Occupied');

create table guests(
    guest_id int primary key auto_increment,
    guest_name varchar(50),
    phone varchar(15),
    city varchar(30)
);

insert into guests(guest_name, phone, city)
values('Rahul', '9876543210', 'Chennai'),
('Priya', '9876543211', 'Bangalore'),
('Arun', '9876543212', 'Hyderabad'),
('Sneha', '9876543213', 'Coimbatore'),
('Karthik', '9876543214', 'Mumbai');

create table bookings(
    booking_id int primary key auto_increment,
    guest_id int,
    room_id int,
    check_in date,
    check_out date,
    booking_status varchar(20),

    foreign key(guest_id)references guests(guest_id),

    foreign key(room_id)references rooms(room_id)
);

insert into bookings(guest_id, room_id, check_in, check_out, booking_status)
values(1, 2, '2026-07-25', '2026-07-30', 'Completed'),
(2, 3, '2026-07-28', '2026-08-02', 'Active'),
(3, 5, '2026-07-29', '2026-08-01', 'Active'),
(4, 7, '2026-07-20', '2026-07-22', 'Completed'),
(1, 1, '2026-08-05', '2026-08-08', 'Booked'),
(5, 4, '2026-07-31', '2026-08-03', 'Cancelled');

create table payments(
    payment_id int primary key auto_increment,
    booking_id int,
    amount decimal(10,2),
    payment_status varchar(20),

    foreign key(booking_id)
    references bookings(booking_id)
);

insert into payments(booking_id, amount, payment_status)
values(1, 20000, 'Paid'),
(2, 35000, 'Paid'),
(3, 12000, 'Pending'),
(4, 15000, 'Paid'),
(5, 7500, 'Pending'),
(6, 0, 'Refunded');

-- 1 display available rooms

select room_number,room_type,price,hotel_name from rooms
join hotels
on rooms.hotel_id = hotels.hotel_id
where status = 'Available';

-- 2) find guests staying today

select guest_name,hotel_name,room_number,check_in,check_out
from guests join bookings
on guests.guest_id = bookings.guest_id
join rooms
on bookings.room_id = rooms.room_id
join hotels
on rooms.hotel_id = hotels.hotel_id
where curdate()
between check_in and check_out
and booking_status = 'Active';

-- 3) calculate total revenue
select sum(amount) as total_revenue
from payments
where payment_status = 'Paid';

-- 4)display booking beween two dates

select booking_id,guest_name,hotel_name,check_in,check_out
from bookings join guests
on bookings.guest_id = guests.guest_id
join rooms
on bookings.room_id = rooms.room_id
join hotels
on rooms.hotel_id = hotels.hotel_id
where check_in
between '2026-07-25'
and '2026-07-31';

-- 5) most booked room type
select room_type,
    count(*) as total_bookings from rooms
join bookings
on rooms.room_id = bookings.room_id
group by room_type
order by total_bookings desc
limit 1;

-- 6)  occupied rooms 
select round(
        (count(case when status = 'Occupied' then 1 end)
            * 100.0
            / count(*)
        ), 2
    ) as occupancy_rate
from rooms;

-- 7) display cancelled booking

select booking_id,guest_name,hotel_name,room_number
from bookings join guests
on bookings.guest_id = guests.guest_id
join rooms
on bookings.room_id = rooms.room_id
join hotels
on rooms.hotel_id = hotels.hotel_id
where booking_status = 'Cancelled';

-- 8)customers with multiple booking

select guest_name,
    count(booking_id) as total_bookings
from guests
join bookings
on guests.guest_id = bookings.guest_id
group by guest_name
having count(*) > 1;

-- 9) average room price
select avg(price) as average_room_price from rooms;

-- 10)find hotel with more than 100 rooms
select hotel_name,
    count(room_id) as total_rooms
from hotels join rooms
on hotels.hotel_id = rooms.hotel_id
group by hotel_name
having count(room_id) > 100;



-- 11) find the highest paying guest

select g.guest_name,
    sum(p.amount) as total_spent
from guests g join bookings b
on g.guest_id = b.guest_id
join payments p
on b.booking_id = p.booking_id
group by g.guest_name
order by total_spent desc
limit 1;

-- 12) hotel-wise revenue

select h.hotel_name,sum(p.amount) as revenue
from hotels h
join rooms r
on h.hotel_id = r.hotel_id
join bookings b
on r.room_id = b.room_id
join payments p
on b.booking_id = p.booking_id
where p.payment_status = 'Paid' group by h.hotel_name;


-- 13) most expensive room
select room_number,room_type,price
from rooms
order by price desc
limit 1;

-- 14) guests who have never made a booking
select g.guest_name
from guests g
left join bookings b
on g.guest_id = b.guest_id
where b.booking_id is null;


-- 15) rank hotels by revenue 
select
    h.hotel_name,
    sum(p.amount) as revenue,
    rank() over(order by sum(p.amount) desc) as revenue_rank
from hotels h
join rooms r
on h.hotel_id = r.hotel_id
join bookings b
on r.room_id = b.room_id
join payments p
on b.booking_id = p.booking_id
where p.payment_status = 'Paid'
group by h.hotel_name;
