create database vechine_service_center;

   use vechine_service_center;

create table Customers(
		customer_id int primary key auto_increment,
        customer_name varchar(50),
        phone varchar(15),
        city varchar(30));
        

insert into Customers(customer_name,phone,city)
values ('Rahul','9876543210','Chennai'),
('Priya','9876543211','Bangalore'),
('Arun','9876543212','Hyderabad'),
('Sneha','9876543213','Coimbatore'),
('Karthik','9876543214','Mumbai');


create table Vehicles (
vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
vehicle_number VARCHAR(15),
vehicle_model VARCHAR(50),
vehicle_type VARCHAR(30),
FOREIGN KEY(customer_id)
REFERENCES Customers(customer_id)
);

insert into  Vehicles(customer_id,vehicle_number,vehicle_model,vehicle_type) values
(1,'TN10AB1234','Hyundai i20','Car'),
(2,'KA05XY5678','Honda City','Car'),
(3,'TS08PQ4321','Royal Enfield','Bike'),
(4,'TN22KL9090','Maruti Swift','Car'),
(5,'MH12AA1111','TVS Apache','Bike');


create table Mechanics(
	mechanic_id int primary key auto_increment,
   machanic_name varchar(50),
    specialization varchar(50),
    experience int);

   
   alter table Mechanics rename column machanic_name to mechanic_name;

    
insert into  Mechanics(mechanic_name,specialization,experience) values
('Ramesh','Engine',10),
('Suresh','Electrical',8),
('Mahesh','General Service',6),
('Ganesh','Painting',12);

create table Service_Record(
service_id int primary key auto_increment,
vehicle_id int,
mechanic_id int,
service_type varchar(50),
service_date date,
cost decimal(10,2),

foreign key (vehicle_id) references Vehicles(vehicle_id),
foreign key (mechanic_id) references Mechanics(mechanic_id));


insert into Service_Record(vehicle_id,mechanic_id,service_type,service_date,cost)values
(1,1,'Engine Repair','2026-07-10',8000),
(1,2,'Electrical Repair','2026-07-20',3000),
(2,3,'General Service','2026-07-21',2500),
(3,1,'Engine Repair','2026-07-15',5000),
(4,3,'General Service','2026-07-18',2200),
(5,2,'Electrical Repair','2026-06-30',1800),
(2,4,'Painting','2026-07-25',7000),
(3,3,'General Service','2026-09-25',2000);

use vechine_service_center;
show tables;

create database vehicle_service_center;
use vehicle_service_center;


create table Bills(
	bill_id int primary key auto_increment,
    service_id int,
    total_amount decimal(10,2),
    payment_status varchar(20),
    
    foreign key(service_id) references Service_Record(service_id));
    
  insert into Bills(service_id,total_amount,payment_status) values
(1,8000,'Paid'),
(2,3000,'Paid'),
(3,2500,'Pending'),
(4,5000,'Paid'),
(5,2200,'Paid'),
(6,1800,'Pending'),
(7,7000,'Paid'),
(8,2000,'Pending');

select* from Bills;

-- 1 display vehicles serviced today

select vehicle_number,vehicle_model,service_type,service_date
from Vehicles join Service_Record
 on  Vehicles.vehicle_id=Service_Record.vehicle_id
where  service_date=CURDATE();

-- I inserted new data to get the result for today’s date.
insert into Service_Record(vehicle_id,mechanic_id,service_type,service_date,cost)values
	(1,1,'Engine repair' ,'2026-09-25',6000);


-- 2 find the mechanic  handling most services
select mechanic_name,COUNT(service_id) as Total_Services
from  Mechanics
join Service_Record
on  Mechanics.mechanic_id = Service_Record.mechanic_id
group by  mechanic_name
order by Total_Services DESC
limit  1;
-- output name Ramesh total services = 3


-- 3) customer wise bill amt

select customer_name,SUM(total_amount) AS Total_Bill
from  Customers
join Vehicles
on  Customers.customer_id = Vehicles.customer_id
join  Service_Record
on  Vehicles.vehicle_id = Service_Record.vehicle_id
join  Bills
on  Service_Record.service_id = Bills.service_id
group by customer_name;


-- 4) vehicle not serviced in last year 
select vehicle_number, vehicle_model
from Vehicles where  vehicle_id  not in 
(
    select vehicle_id
    from  Service_Record
    where service_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);


-- 5) service history of vehicle

select vehicle_number,service_type,service_date,cost
from vehicles
join service_record
on vehicles.vehicle_id = service_record.vehicle_id
where vehicle_number = 'TN10AB1234'
order by service_date;

-- 6) count service by type
select service_type,
    count(*) as total
from service_record group by service_type;


-- 7)  customers with more than three visits

select customer_name,
    count(service_id) as visit from customers
join vehicles
on customers.customer_id = vehicles.customer_id
join service_record
on vehicles.vehicle_id = service_record.vehicle_id
group by customer_name
having count(service_id) > 3;

-- 8) display pending bills

select customer_name,vehicle_number,total_amount
from customers
join vehicles
on customers.customer_id = vehicles.customer_id
join service_record
on vehicles.vehicle_id = service_record.vehicle_id
join bills
on service_record.service_id = bills.service_id
where payment_status = 'Pending';


-- 9 most common service

select service_type,
    count(*) as frequency
from service_record
group by service_type
order by frequency desc limit 1;

-- output Engine repair = 3


-- 10) monthly service revenue 

select month(service_date) as month,
    sum(total_amount) as revenue from service_record
join bills
on service_record.service_id = bills.service_id
group by month(service_date);



-- 11) highest bill
select * from Bills order by total_amount desc limit 1;

-- 12  find the mechanic with highest revenue

select mechanic_name,
    sum(total_amount) as revenue from mechanics
join service_records
on mechanics.mechanic_id = service_records.mechanic_id
join bills
on service_records.service_id = bills.service_id
group by mechanic_name
order by revenue desc;

-- 13 customer who own more than one vechicle

select customer_name,
    count(vehicle_id) as vehicles from customers
join vehicles
on customers.customer_id = vehicles.customer_id
group by customer_name
having count(vehicle_id) > 1;

-- 14) find avg service cost 
select avg(cost) as average_cost from service_record;

-- 15)most experienced mechanic
select * from mechanics order by experience desc limit 1;

-- 16)  display all engine repairs
select * from service_record where service_type = 'Engine Repair';

-- 17) customerr from chennai
select* from customers where  city = 'chennai';

-- 18) display  all services done by particular mechanic

select mechanic_name,service_type,service_date
from mechanics
join service_record
on mechanics.mechanic_id = service_record.mechanic_id
where mechanic_name = 'Ramesh';

-- 19)  unpaid details with service info
select
    bill_id,
    customer_name,
    vehicle_number,
    service_type,
    service_date,
    total_amount
from bills
join service_record
on bills.service_id = service_record.service_id
join vehicles
on service_record.vehicle_id = vehicles.vehicle_id
join customers
on vehicles.customer_id = customers.customer_id
where payment_status = 'Pending';


-- 20)rank mechanic based on numbers of service

select mechanic_name,
    count(service_id) as total_services,
    rank() over(order by count(service_id) desc) as service_rank
from mechanics
left join service_record
on mechanics.mechanic_id = service_record.mechanic_id
group by mechanic_name;
