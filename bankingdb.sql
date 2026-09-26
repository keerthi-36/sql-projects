create database banking_db;
use banking_db;

create table customers (
    customer_id int primary key auto_increment,
    name varchar(50),
    city varchar(50)
);

insert into customers (name, city) values
('Janani','Chennai'),
('Arun','Coimbatore'),
('Priya','Madurai'),
('Karthik','Salem');

create table accounts (
    account_id int primary key auto_increment,
    customer_id int,
    account_type varchar(20),
    balance decimal(10,2),
    foreign key (customer_id) references customers(customer_id)
);

insert into accounts (customer_id, account_type, balance) values
(1,'Savings',50000),
(1,'Current',20000),
(2,'Savings',30000),
(3,'Savings',15000),
(4,'Current',40000);

-- 1) retrieve all accounts with balance greater than 20000
select * from accounts where balance > 20000;

-- 2 find customer who in chennai
select * from customers where city = 'chennai';

-- 3display account with balance between 20k and 50k
 select* from accounts where balance between 20000 and 50000;
 
 -- 4 customer whose name start with j
 select * from customers where name like 'j%';
 
 --  5.	Retrieve accounts of type 'Savings' or 'Current'.
 select * from accounts where account_type in ('Savings' ,'Current');
 
 -- 6.	Display accounts that are not 'Savings'. 
  select * from accounts where account_type not  in ('Savings' );
  
  -- 7.	Find customers whose names contain the letter 'a'.
   select * from customers where name like '%a%';
 
-- 8.	Retrieve accounts with balance less than or equal to 30,000.
select * from accounts where balance <= 30000;

--  9.	Find customers who are not from Madurai. 
select * from customers where city <> 'madurai';

-- 10.	Display accounts where balance is not between 10,000 and 40,000. 
select * from accounts where balance not between 10000 and 40000;

-- 11.	Retrieve customers whose names end with 'i'.
  select * from customers where name like '%i';
  
  -- 12.	Find accounts with balance equal to 50,000. 
  select * from accounts where balance = 50000;
  
  -- 13.	Display customers whose city is either Chennai or Salem. 
  select * from customers where city in ('chennai','salem');
  
  -- 14.	Find accounts with balance greater than 10,000 and less than 40,000. 
  select *  from accounts where balance > 10000 and balance < 40000;
  
  -- 15.	Retrieve accounts where account type is not in ('Current'). 
    select * from accounts where account_type not  in ('Current' );
    
    -- order by
    -- 16.	Display all accounts sorted by balance in descending order. 
    select * from accounts order by balance desc;
    
-- 17.	List customers sorted alphabetically by name. 
select * from customers order by name asc;

-- 18.	Display accounts sorted by account type and then by balance (descending). 
 select * from accounts order by account_type asc,balance desc;
 
 -- aggregrate  fun 
 -- 19 	Find the total balance of all accounts. 
 select sum(balance) from accounts;
 
 -- 20.	Calculate the average balance of accounts.
  select avg(balance) from accounts;
  
  --  21.	Find the maximum account balance. 
   select max(balance) from accounts;
   
   -- 22 Find the minimum account balance.
    select max(balance) from accounts;
    
    -- 23.	Count the total number of customers. 
     select count(*) from customers;
    
    -- 24.	Find total balance grouped by account type. 
    select account_type, sum(balance) from accounts group by account_type;
    
    -- 25.	Find average balance for each account type. 
     select account_type, avg(balance) from accounts group by account_type;

-- 26.	Display account types having average balance greater than 20,000. 
     select account_type, avg(balance) from accounts group by account_type having avg(balance) > 20000;
     
-- 27.	Count number of accounts for each customer. 
select customer_id,count(*) from accounts group by customer_id;

-- 28.	Display customers having more than one account.
    select customer_id,count(*) from accounts group by customer_id having count(*)> 1;
    
    -- joins
    -- 29.	Retrieve customer names along with their account balances. 
select customers.name, accounts.balance from customers
join accounts
on customers.customer_id = accounts.customer_id;

-- 30.	Display all customers and their accounts (including customers without accounts). 
select customers.name,accounts.account_type, accounts.balance from customers
 left join accounts
on customers.customer_id = accounts.customer_id;
    
    -- 31.	Display all accounts and corresponding customer details. 
select accounts.account_type, accounts.balance , customers.name,customers.city from accounts
 left join customers
on accounts.customer_id= customers.customer_id ;
    
  -- 32.	Retrieve customer names and account types where balance is greater than 20,000  
    select customers.name,accounts.account_type from customers
  join accounts
on customers.customer_id = accounts.customer_id where accounts.balance > 20000;
 
 -- 33.	List customers with their total balance using JOIN. 
 select customers.name, sum(accounts.balance) as total_balance
from customers
join accounts
on customers.customer_id = accounts.customer_id
group by customers.customer_id, customers.name;
    
 -- 34.	Display customer names and balances sorted by balance   
 select customers.name, accounts.balance from customers
join accounts
on customers.customer_id = accounts.customer_id order by accounts.balance;
    
  -- 35.	Count number of accounts for each city using JOIN. 
select customers.city, count(accounts.account_id) as account_count
from customers
join accounts
on customers.customer_id = accounts.customer_id
group by customers.city;  
    
    -- sub query
    -- 36.	Find accounts with balance greater than average balance. 
    select *from accounts
where balance > (select avg(balance)from accounts);
   
   -- 37.	Retrieve customers who have accounts. 
   select * from customers
where customer_id in (select customer_id from accounts);

-- 38.	Find customers who do not have any accounts.
   select * from customers
where customer_id  not in (select customer_id from accounts);

-- 39.	Display accounts  with the maximum balance. 
    select *from accounts
where balance = (select max(balance)from accounts);

-- 40.	Find customers whose total balance is greater than 40,000.
select customer_id, name from customers
where customer_id in (select customer_id from accounts
    group by customer_id
    having sum(balance) > 40000
);