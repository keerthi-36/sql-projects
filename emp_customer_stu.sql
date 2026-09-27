create database employee_management;
use  employee_management;

create table employee (
    emp_id int primary key,
    emp_name varchar(50),
    department varchar(30),
    salary decimal(10,2),
    city varchar(30),
    joining_date date
);

insert into employee values
(101,'John','IT',60000,'Chennai','2022-01-15'),
(102,'David','HR',45000,'Bangalore','2021-03-10'),
(103,'Smith','IT',70000,'Chennai','2020-07-12'),
(104,'Mary','Finance',55000,'Mumbai','2023-01-20'),
(105,'James','HR',48000,'Delhi','2022-05-05'),
(106,'Linda','Finance',65000,'Mumbai','2021-08-18');

--  1. Find the total number of employees in each department.
select department, count(*) as total_employees from employee group by department;

-- 2. Find the average salary of employees in each department.
select department, avg(salary) as average_salary from employee group by department;

-- 3. Display departments having more than one employee.
select department, count(*) as total_employees from employee group by department having count(*) > 1;

--  4. Find the highest salary in each department.
select department, max(salary) as highest_salary from employee group by department;

--  5 .Find the lowest salary in each department.
select department, min(salary) as lowest_salary from employee group by department;

-- 6.Find departments whose average salary is greater than 50,000.
select department, avg(salary) as average_salary from employee group by department having avg(salary) > 50000;

-- 7. Calculate the total salary expenditure for each department.
select department, sum(salary) as total_salary from employee group by department;

--  8. Display all employees sorted by salary in descending order.
select * from employee order by salary desc;

-- 9.Display employees sorted first by department and then by salary in descending order.
select * from employee order by department, salary desc;

-- 10 Find cities that have more than one employee.
select city,count(*) as total_employees from employee group by city having count(*)>1;

-- 11.Find the total salary paid in each city.
select city,sum(salary) as total_salary from employee group by city;

-- 12.Display departments ordered by total salary expenditure from highest to lowest.
select department, sum(salary) as total_salary from employee group by department order by total_salary desc;

-- 13.Find the number of employees in each department whose salary is greater than 50,000.
select department, count(*) as total_employees from employee where salary > 50000 group by department;

-- 14.Find the difference between the highest and lowest salary in each department.
select department, max(salary) - min(salary) as salary_difference from employee group by department;

--  15.Display the top 3 highest-paid employees.
select * from employee order by salary desc limit 3;

create table customers (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(30)
);

insert into customers values
(1,'arun','chennai'),
(2,'priya','bangalore'),
(3,'karthik','mumbai'),
(4,'divya','delhi'),
(5,'rahul','coimbatore'),
(6,'meena','chennai');

create table orders (
    order_id int primary key,
    customer_id int,
    amount decimal(10,2),
    order_date date,
    foreign key(customer_id) references customers(customer_id)
);

insert into orders values
(101,1,2500,'2026-01-10'),
(102,1,3000,'2026-01-15'),
(103,1,1800,'2026-02-05'),
(104,1,3500,'2026-02-20'),
(105,2,4500,'2026-01-12'),
(106,2,2500,'2026-01-25'),
(107,2,3000,'2026-02-10'),
(108,3,1500,'2026-01-18'),
(109,3,2200,'2026-02-01'),
(110,4,5000,'2026-01-20'),
(111,4,1800,'2026-02-15'),
(112,5,3200,'2026-01-08'),
(113,5,2500,'2026-02-12'),
(114,6,2000,'2026-01-30'),
(115,6,2800,'2026-02-18');

-- customer & order table
--  16 Find the total order amount for each customer.
select customer_id,sum(amount) as total_amount from orders group by customer_id;

-- 17 Find customers who have placed more than 3 orders.
select customer_id, count(*) as total_orders from orders group by customer_id having count(*) > 3;

-- 18 Find the average order amount for each customer.
select customer_id,avg(amount) as average_amount from orders group by customer_id;

-- 19. Find the highest order amount placed by each customer.
select customer_id, max(amount) as highest_amount from orders group by customer_id;

-- 20 Display customers sorted by their total purchase amount.
select customer_id,sum(amount) as total_purchase from orders group by customer_id order by total_purchase desc;

-- 21  Find customers whose total purchase amount exceeds 10,000.
select customer_id,sum(amount) as total_purchase from orders group by customer_id having sum(amoumt) > 10000;

-- 22. Display customer names along with the total number of orders placed.
select c.customer_name, count(o.order_id) as total_orders
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;

-- 23. Find the customer who spent the highest amount.
select c.customer_name, sum(o.amount) as total_purchase
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by total_purchase desc limit 1;

-- 24. Find the customer who placed the maximum number of orders.
select c.customer_name, count(o.order_id) as total_orders
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name order by total_orders desc limit 1;

--  25 Find customers whose average order amount is greater than 2,000
select c.customer_name, avg(o.amount) as average_amount
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name having avg(o.amount)> 2000;

-- 26 Display the top 5 customers based on total purchase amount.
select c.customer_name, sum(o.amount) as total_purchase
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by total_purchase desc limit 5;

-- 27 Find the minimum order amount for each customer.
select c.customer_name, min(o.amount) as minimum_amount
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name ;

-- 28 Find customers who have placed orders worth more than 5,000 in total.
select c.customer_name, sum(o.amount) as total_purchase
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name having sum(o.amount) > 5000;

-- 29 Display customer-wise total orders and total purchase amount.
select c.customer_name, count(o.order_id) as total_orders ,sum(o.amount) as total_purchase
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name ;

-- 30 Find customers who placed more than 2 orders and spent more than 8,000.
select c.customer_name, count(o.order_id) as total_orders ,sum(o.amount) as total_purchase
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name having count(o.order_id) > 2 and sum(o.amount)>8000;

create table students (
    student_id int primary key,
    student_name varchar(50),
    department varchar(30),
    marks int);
    
    insert into students values
(1,'arun','it',85),
(2,'priya','it',78),
(3,'karthik','it',92),
(4,'divya','it',88),
(5,'rahul','it',76),
(6,'meena','it',95),
(7,'suresh','commerce',72),
(8,'kaviya','commerce',80),
(9,'anjali','commerce',68),
(10,'vijay','commerce',75),
(11,'deepa','commerce',82),
(12,'hari','commerce',77),
(13,'ram','science',91),
(14,'latha','science',84),
(15,'mohan','science',73),
(16,'nisha','science',89),
(17,'bala','science',65),
(18,'swetha','science',94),
(19,'gokul','arts',70),
(20,'keerthi','arts',81),
(21,'manoj','arts',74),
(22,'rekha','arts',88);

-- 31. Find the average marks scored by students in each department.
select department,avg(marks) as average_marks from students group by department;

-- 32 Find departments whose average marks are above 75.
select department,avg(marks) as average_marks from students group by department having avg(marks) > 75;

--  33 Find the highest mark scored in each department.
select department, max(marks) as highest_marks
from students group by department;

-- 34 Find the total number of students in each department.
select department ,count(*) as total_students from students group by department;

-- 35 Find departments having more than 5 students.
select department ,count(*) as total_students from students group by department having count(*) > 5;

-- 36 Display departments sorted by average marks in descending order.
select department,avg(marks) as average_marks from students group by department order by average_marks desc;

-- 37 Find the top 3 departments based on average marks.
select department,avg(marks) as average_marks from students group by department order by average_marks desc limit 3;

-- 38 Find departments whose average marks are between 70 and 90.
select department,avg(marks) as average_marks from students group by department having avg(marks) between 70 and 90;

-- 39 Find the total marks scored by students in each department.
select department, sum(marks) as total_marks
from students group by department;

-- 40. Display departments sorted by the total number of students.
select department ,count(*) as total_students from students group by department order by total_students desc;

-- 41. Find the lowest mark scored in each department.
select department, min(marks) as lowest_marks
from students group by department;

-- 42. Find departments where the highest mark is greater than 90.
select department, max(marks) as highest_marks
from students group by department having max(marks) > 90;

--  43 .Find the number of students scoring above 80 in each department.
select department ,count(*) as total_students from students  where marks > 80 group by department;

-- 44. Find departments where more than 3 students scored above 75.
select department ,count(*) as total_students from students  where marks > 75 group by department having  count(*) > 3 ;

--  45. Display departments ordered by highest mark in descending order.
select department, max(marks) as highest_marks
from students group by department order by highest_marks desc;








