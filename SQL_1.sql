#Get Customer Details whose creditlimit is between 50000 and 100000

select customernumber, customerName, state, creditlimit
   from customers
   where creditLimit between 50000 and 100000 and state is not null
   order by creditLimit desc;
   
   
#Get Productline ending with "Cars"
select productline from productlines where productline like "% CARS";


#Get shipped order details.
SELECT ordernumber, status, COALESCE(comments, '-') AS comments
FROM orders
WHERE status = 'shipped';


#Show Job Title with their short names.
select employeenumber, firstname,jobtitle,
case when jobtitle="President" then "P"
	 when jobtitle like "Sales Manager%" or jobtitle like "Sale Manager%" then "SM"
     when jobtitle="Sales Rep" then "SR"
     when jobtitle like "VP %" then "VP"
end as jobtitle_abbr
 from employees;
 
 
#Show minimum payment amount paid by customer of every year.
select *from payments;

select year(paymentdate) as year, min(amount) as min_amount
from payments
group by year
order by year asc;


#Get Total orders from customers by year and quarter.
select *from customers;
select *from orders;

select 
year(orderdate) as year, 
concat("Q",quarter(orderdate)) as Quarter,
count(distinct customerNumber) as unique_orders,
count(ordernumber) as total_orders from orders
group by year,quarter
order by year asc;


#Get Monthly Payment Amount by Customers.
select *from payments;

select monthname(paymentdate) as Month, concat(format(sum(amount)/1000,0),'K') as formatted_amount
from payments
group by month
having sum(amount) between 500000 and 1000000
order by formatted_amount desc;


#Assigning Constraints_1
create table journey(bus_id int not null,
bus_name varchar(30) not null,
source_station varchar(30) not null,
destination varchar(30) not null,
email varchar(50) unique);

desc journey;


#Assigning Constrants_2
create table vendor(vendor_id int primary key,
name varchar(30) not null,
email varchar(50) unique,
country varchar(20) default "N/A");

desc vendor;


#Assigning Contraints_3
create table Movies(movie_id int primary key, 
name varchar(20) not null,
release_year varchar(4) default "-",
cast varchar(20) not null,
gender enum('Female','Male'),
no_of_shows int check (no_of_shows >0));

desc movies;


#Creating multiple tables with Foreign key.
create table product(product_id int primary key,
product_name varchar(50) not null unique,
description varchar(500),
supplier_id int,
foreign key (supplier_id) references supplier(id));

create table supplier(id int primary key,
supplier_name varchar(50) not null unique,
location varchar(20));

create table stock(stock_id int primary key,
prod_id int,
foreign key (prod_id) references product(product_id),
balance_stock int);

desc product;
desc supplier;
desc stock;


#Get Unique Customers of each Employee.
select e.employeenumber,
concat(firstname," ",lastname) as sales_person, count(c.customernumber) as unique_customers from employees e
join customers c on  e.employeeNumber=c.salesRepEmployeeNumber
group by employeenumber
order by unique_customers desc;


#Get CUstomer and Product details and show remaining quantities in stock.
select *from customers;
select *from products;
select *from orders;
select *from orderdetails;


create view productss as
select c.customernumber, c.customername,p.productcode,p.productname,
sum(quantityordered) as quantity_ordered,
sum(quantityinstock) as total_inventory,
p.quantityInStock-coalesce(sum(od.quantityordered),0) as left_over_quantities
from customers c
join orders o on c.customernumber=o.customernumber
join orderdetails od on o.orderNumber=od.orderNumber
join products p on od.productCode=p.productCode
group by c.customerNumber,c.customerName,p.productCode,p.productName
order by customernumber asc;

select *from productss;

drop view productss;


#Perfoming Cross Join.
create table Laptop(laptop_name varchar(20));
create table Colours(colour_name varchar(20));

insert into Laptop values("Dell"),("HP");
insert into Colours values("White"),("Silver"),("Black");

select laptop_name,colour_name from Laptop
cross join Colours
order by laptop_name;


#Performing Self Join
create table project(employee_id int, full_name varchar(20), gender enum("Male","Female"),manager_id int);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select *from project;

select e1.full_name as manager_name, e2.full_name as employee_name
from project e1 
left join project e2 on e1.employee_id=e2.manager_id
having employee_name is not null;


#DML Commands
create table facility(facility_id int, name varchar(100),state varchar(100), country varchar(100));

alter table facility
modify column facility_id int primary key auto_increment;

desc facility;

alter table facility
add city varchar(100) not null after name;
select *from facility;


#String Manipulation
create table university(id int,name varchar(100));

drop table university;

INSERT INTO University
VALUES (1, "       Pune         University     "), 
               (2, "  Mumbai         University     "),
              (3, "     Delhi  University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
              
select *from university;

update university 
set name=ltrim(name);

update university 
set name=rtrim(name);

UPDATE university
SET name = replace(name,"    ", "");


#Calculate percenatge for total sales by each year.
select *from orders;
select *from orderdetails;

drop view product_status;
select * from product_status;


create view product_status as
SELECT 
    year(orderdate) as year,
    concat(count(quantityordered)," (",
    round((count(quantityordered)*100 / sum(count(quantityordered)) OVER ())),"%",")") as percentage_by_year
FROM 
    orders o
    left join orderdetails od on o.ordernumber=od.ordernumber
GROUP BY 
    year(orderdate);
    
select *from product_statuss;
drop view product_statuss;
    
    

/*
#type2
SELECT 
year(orderDate) as year_, 
count(productCode),
(SELECT count(*) from orderdetails),
count(productCode)/(SELECT count(*) from orderdetails),
count(productCode)/sum(count(*)) OVER () 
FROM orders o
LEFT JOIN orderdetails od on o.orderNumber = od.orderNumber
GROUP BY 1;
    */
    
    
#Creating Procedure_1
select *from customers;
drop procedure getcustomerlevel;

delimiter //
create procedure getCustomerLevel(in cust_no int)
begin
select customernumber,
case when creditlimit>100000 then "Platinum"
	 when creditlimit>= 25000 and creditlimit<= 100000 then "Gold"
     when creditlimit<25000 then "Silver" 
     end as customer_type
     from customers
     where customernumber=cust_no;
end //

call getcustomerlevel(112);


#Creating Procedure_2
select *from customers;
select *from payments;

drop procedure get_country_payments;

delimiter //
create procedure get_country_payments(in param_year int, in param_country varchar(20))
begin
select 
year(paymentdate) as year,
country,
concat(left(round(sum(amount)),3),"K") as total_amount
from customers c
join payments p on c.customernumber=p.customernumber
where year(paymentdate)=param_year and country=param_country
group by year,country;

end//

call get_country_payments(2003,"France");


#Calculate YOY% change
select *from orders;

select year(orderdate) as year,
monthname(orderdate) as month,
count(ordernumber) as total_orders,
 concat(round((count(ordernumber) - LAG(count(ordernumber), 1) OVER (ORDER BY year(orderdate))) / LAG(count(ordernumber), 1) OVER (ORDER BY year(orderdate)) * 100),"%") AS YOY_Change
from orders
group by year,month;


#Creating Funtion. Getting Age of employee in yeras and months. 
desc orders;
create table emp_udf(id int,name varchar(20),dob date);
INSERT INTO Emp_UDF(id,Name, DOB)
VALUES (1,"Piyush", "1990-03-30"), (2,"Aman", "1992-08-15"), 
(3,"Meena", "1998-07-28"), (4,"Ketan", "2000-11-21"), (5,"Sanjay", "1995-05-21");

drop function calculate_age;
drop table emp_udf;

delimiter //
create function calculate_age(xyz date)
returns varchar(50) deterministic
begin
return concat(timestampdiff(year,xyz,now())," Years ",timestampdiff(month,xyz,now())%12 ," Months");
end //

select *  ,calculate_age(dob) from emp_udf ;


#Get the customers who have not placed the order.
select c.customernumber,customername 
from customers c
left join orders o on c.customerNumber=o.customerNumber
where ordernumber is null;


#Performing UNION
select c.customernumber, customername,count(ordernumber) as total_orders
from customers c
left join orders o on c.customernumber=o.customernumber
group by c.customernumber,customername

union


select c.customernumber, customername,count(ordernumber) as total_orders
from customers c
right join orders o on c.customernumber=o.customernumber
group by c.customernumber,customername;


#Show the second highest quantity ordered value for each order number.
select ordernumber, quantityordered from
(select ordernumber, quantityordered,
rank() over(partition by ordernumber order by quantityordered desc) as rank_
from orderdetails) a
where rank_=2;


#Get Maximum and Minimum number of items
select max(items) as max_total,min(items) as min_total from
(select ordernumber,count(productcode) as items
from orderdetails
group by ordernumber) a;



#5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. 
select *from products;

select productline,count(msrp) as total
from products
where msrp>(select avg(msrp) from products)
group by productline
order by 2 desc;


#Exception Handling
create table emp_ehh(emp_id int primary key,name varchar(30) not null,emailaddress varchar(100) not null);
drop table emp_ehh;
delimiter //
create procedure accept_errors(in p_id int,in p_name varchar(30),in e_a varchar(100))
begin
declare exit handler for 1048 select "Don't enter null values" message;
declare exit handler for 1062 select "Don't enter duplicate values" message;
declare exit handler for sqlexception select "error occured" message;

insert into emp_ehh(emp_id,name,emailaddress) values(p_id,pname,e_a);
select *from emp_ehh;
end//
drop procedure accept_errors;

call accept_errors(1,"Manu","manu24@gmail.com");
call accept_errors(1,"Tanu","tanu23@gmail.com");
call accept_errors(null,"Tanu","tanu23@gmail.com");
call accept_errors(2,"Tanu","tanu23@gmail.com");
call accept_errors(3,"Tanu","tanu23@gmail.com");
call accept_errors(4,"Tanu","tanu23@gmail.com");  #sqlexception "error occured message"


#Trigger
create table Emp_BIT(Name varchar(20),Occupation varchar(20),Working_date date,Working_hours int);
drop table emp_bit;

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  ('Warner', 'Engineer', '2020-10-04',10),  ('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

drop trigger before_insert_new;

delimiter //
create trigger before_insert_new
before insert on emp_bit for each row
begin
if new.working_hours<0 then set new.working_hours=0;
end if;
end //

select *from emp_bit;
insert into emp_bit values("Deven","Manager","2021-08-12",-5);
insert into emp_bit values("Deven","Manager","2021-08-12",-8);

