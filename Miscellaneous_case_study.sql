use campusx;

-- 1 You have got duplciate rows in table you have to delete them.
		create table employees(
				id int auto_increment primary key,
				first_name varchar(50) not null,
				last_name varchar(50) not null,
				email varchar(100) not null,
				hire_date DATE not null
		);

		-- insert some arbitrary values in the table

		INSERT INTO employees (first_name, last_name, email, hire_date)
		VALUES ('John', 'Doe', 'johndoe@example.com', '2022-01-15'),
			   ('Jane', 'Smith', 'janesmith@example.com', '2021-11-30'),
			   ('Alice', 'Johnson', 'alicejohnson@example.com', '2022-03-10'),
			   ('David', 'Brown', 'davidbrown@example.com', '2022-02-20'),
			   ('Emily', 'Davis', 'emilydavis@example.com', '2022-04-05'),
			   ('Michael', 'Wilson', 'michaelwilson@example.com', '2022-01-05'),
			   ('Sarah', 'Taylor', 'sarahtaylor@example.com', '2022-03-25'),
			   ('Kevin', 'Clark', 'kevinclark@example.com', '2022-02-15'),
			   ('Jessica', 'Anderson', 'jessicaanderson@example.com', '2022-04-01'),
			   ('Matthew', 'Martinez', 'matthewmartinez@example.com', '2022-01-10'),
			   ('Laura', 'Robinson', 'laurarobinson@example.com', '2022-03-15'),
			   ('Daniel', 'White', 'danielwhite@example.com', '2022-02-05'),
			   ('Amy', 'Harris', 'amyharris@example.com', '2022-04-20'),
			   ('Jason', 'Lee', 'jasonlee@example.com', '2022-01-20'),
			   ('Rachel', 'Moore', 'rachelmoore@example.com', '2022-03-05');

		-- inserting some random duplicate values

		insert into employees (first_name, last_name, email, hire_date)
		values ('Emily', 'Davis', 'emilydavis@example.com', '2022-04-05'),
		('Matthew', 'Martinez', 'matthewmartinez@example.com', '2022-01-10');

		delete from employees where id in
		(
			select id from 
			(
			select id, row_number() over(partition by first_name,last_name order by id)  as "rnk"
			from employees
			) m where rnk>1
		);

		select * from employees;

-- 2  You sales manager and you have 3 territories under you,   the manager decided that for each territory the salesperson who have  sold more than 30%  of the average 
-- of that territory  will  get  hike  and person who have done 80% less than the average salary will be issued PIP , now for all you have to  tell your manager 
-- if he/she will  get a hike or will be in a PIP

		create table sales
		(  
			sales_person varchar(100),
			territory varchar(2),
			sales int 
		);

		INSERT INTO sales (sales_person, territory, sales)
		VALUES ('John', 'A',40),
			   ('Alice', 'A', 150),
			   ('Michael', 'A', 200),
			   ('Sarah', 'A', 120),
			   ('Kevin', 'A', 180),
			   ('Jessica', 'A', 90),
			   ('David', 'A', 130),
			   ('Emily', 'A', 140),
			   ('Daniel', 'A', 270),
			   ('Laura', 'A', 300),
			   ('Jane', 'B', 180),
			   ('Robert', 'B', 220),
			   ('Mary', 'B', 190),
			   ('Peter', 'B', 210),
			   ('Emma', 'B', 130),
			   ('Matthew', 'B', 140),
			   ('Olivia', 'B', 170),
			   ('William', 'B', 240),
			   ('Sophia', 'B', 210),
			   ('Andrew', 'B', 300),
			   ('James', 'C', 300),
			   ('Linda', 'C', 270),
			   ('Richard', 'C', 320),
			   ('Jennifer', 'C', 280),
			   ('Charles', 'C', 250),
			   ('Amanda', 'C', 290),
			   ('Thomas', 'C', 260),
			   ('Susan', 'C', 310),
			   ('Paul', 'C', 280),
			   ('Karen', 'C', 300);
			   
		select * from sales;

		set @a= (select round(avg(sales),2) as average_a from sales where territory= 'A');
		set @b= (select round(avg(sales),2) as average_b from sales where territory= 'B');
		set @c= (select round(avg(sales),2) as average_c from sales where territory= 'C');

		select @a;


		select *,
			 case when sales>1.3*territory_mean  then  'HIKE'
				  WHEN SALES <0.8*TERRITORY_MEAN then 'PIP'
				  else 'Same parameter'
				end as 'Final decision'
			from
			(
					SELECT *,
						CASE WHEN territory = 'A' THEN @a
							 WHEN territory = 'B' THEN @b
							 WHEN territory = 'C' THEN @c
							 ELSE NULL
						END AS territory_mean
					FROM sales
			)k;


/* 3. You are database administrator for a university , University have declared result for a special exam , However children were not happy with the marks as marks were
not given appropriately and many students marksheet was blank , so they striked. 
Due to strike univerisity again checked the sheets and updates were made. Handle these updates*/

		Create table students
		( 
		roll int ,
		s_name varchar(100),
		Marks  float
		);

		INSERT INTO students (roll, s_name, Marks)
		VALUES 
			(1, 'John', 75),
			(2, 'Alice', 55),
			(3, 'Bob', 40),
			(4, 'Sarah', 85),
			(5, 'Mike', 65),
			(6, 'Emily', 50),
			(7, 'David', 70),
			(8, 'Sophia', 45),
			(9, 'Tom', 55),
			(10, 'Emma', 80),
			(11, 'James', 58),
			(12, 'Lily', 72),
			(13, 'Andrew', 55),
			(14, 'Olivia', 62),
			(15, 'Daniel', 78);

		select * from students;

		Create table std_updates
		(
		  roll int,
		  s_name varchar(100),
		  marks float 
		);

		INSERT INTO std_updates (roll, s_name, Marks)
		VALUES 
				(8, 'Sophia', 75),   -- existing
				(9, 'Tom', 85),
				(16, 'Grace', 55),     -- new
				(17, 'Henry', 72),
				(18, 'Sophie', 45),
				(19, 'Jack', 58),
				(20, 'Ella', 42);

		select * from std_updates;

		update students as s
		inner join std_updates t
		set s.marks=t.marks
		where s.roll=t.roll;

		select * from students; 

		-- insertion of new data
		INSERT INTO students (roll, s_name, marks)
		select roll,s_name,marks from 
		(
		select p.roll as r1,q.* from students as p
		right join std_updates as q
		on p.roll=q.roll
		)k where r1 is NULL;

		select * from students;


-- 4 You have  to make a procedure , where you will give 3 inputs string, deliminator  and before and after  command , based on the   information provided you have to 
-- find that part of string. in industry we have space constraints , thats why we try to make things as simple as possbile, and resuable things.

		-- creating table
		CREATE TABLE employees1 (
			emp_id INT PRIMARY KEY,
			emp_name VARCHAR(50),
			emp_salary DECIMAL(10, 2)
		);


		-- Inserting values.
		INSERT INTO employees1 (emp_id, emp_name, emp_salary) VALUES
			(1, 'Rahul Sharma', 50000.00),
			(2, 'Priya Patel', 48000.00),
			(3, 'Amit Singh', 55000.00),
			(4, 'Sneha Reddy', 51000.00),
			(5, 'Vivek Gupta', 49000.00),
			(6, 'Ananya Desai', 52000.00),
			(7, 'Rajesh Verma', 53000.00),
			(8, 'Neha Mishra', 48000.00),
			(9, 'Arun Kumar', 47000.00),
			(10, 'Pooja Mehta', 54000.00);

		select * from employees1;

		DELIMITER //
		create function string_split( s varchar(100), d varchar(5), c varchar (10))
		returns Varchar(100)
		DETERMINISTIC
		begin
			 set @l = length(d);  -- deliminator can be of any length.
			 set @p = locate(d, s);
			 set @o = 
				case  when c like '%before%'
					then left(s,@p)
				else 
					substring(s, @p+@l,length(s))
				end;
		  return @o;
		end //
		DELIMITER ;


		select * , string_split(emp_name , ' ', 'after') from employees1;

		drop function  string_split;

-- 5 You have a table that stores student information  roll number wise ,now some of the students have left the school due to which the  roll numbers became discontinuous
-- numbers became discontinuous Now your task is to make them continuous.

-- creating table
CREATE TABLE students1 (
    roll_number INT PRIMARY KEY,
    name VARCHAR(50),
    marks DECIMAL(5, 2),
    favourite_subject VARCHAR(50)
);

 truncate table students1;

-- inserting data
INSERT INTO students1 (roll_number, name, marks, favourite_subject) VALUES
    (1, 'Rahul Sharma', 75.5, 'Mathematics'),
    (2, 'Priya Patel', 82.0, 'Science'),
    (3, 'Amit Singh', 68.5, 'History'),
    (4, 'Sneha Reddy', 90.75, 'English'),
    (5, 'Vivek Gupta', 79.0, 'Physics'),
    (6, 'Ananya Desai', 85.25, 'Chemistry'),
    (7, 'Rajesh Verma', 72.0, 'Biology'),
    (8, 'Neha Mishra', 88.5, 'Computer Science'),
    (9, 'Arun Kumar', 76.75, 'Economics'),
    (10, 'Pooja Mehta', 94.0, 'Geography'),
	(11, 'Sanjay Gupta', 81.5, 'Mathematics'),
    (12, 'Divya Sharma', 77.0, 'Science'),
    (13, 'Rakesh Patel', 83.5, 'History'),
    (14, 'Kavita Reddy', 89.25, 'English'),
    (15, 'Ankit Verma', 72.0, 'Physics');

-- Deteting some random values 
delete from students1 where roll_number in(3,7,11,14);

select * from students1;


-- Let's try solving the same by using  stored procedure so as to achieve the result dynamically
DELIMITER //
create procedure roll_update()
BEGIN
	update students1 as s 
	inner join 
	(
	select *, row_number() over( order by roll_number) as rl from  students1
	)t on s.roll_number=t.roll_number
	set s.roll_number=t.rl;
END
//
DELIMITER ;

DELIMITER //
create event if not exists students_roll_update
on schedule every 30 second
do
begin
	call roll_update();
end //
DELIMITER ;

select * from students1;

-- 6 create a system where it will check the warehouse before making the sale and if sufficient quantity is avaibale make the sale and store the sales transaction 
 -- else show error for insufficient quantity.( like an ecommerce website, before making final transaction look for stock.)

create table products
   (
      product_code varchar(20),
      product_name varchar(20),
      price int,
      Quantity_remaining int,
      Quantity_sold int
	);
    
INSERT INTO products (product_code, product_name, price, Quantity_remaining, Quantity_sold)
VALUES
    ('RO001', 'Rolex Submariner', 7500, 20, 0),
    ('RO002', 'Rolex Datejust', 6000, 15, 0),
    ('RO003', 'Rolex Daytona', 8500, 25, 0),
    ('RO004', 'Rolex GMT-Master II', 7000, 18, 0),
    ('RO005', 'Rolex Explorer', 5500, 12, 0),
    ('RO006', 'Rolex Yacht-Master', 9000, 30, 0),
    ('RO007', 'Rolex Sky-Dweller', 9500, 22, 0);


select * from products;

  /* create table sales1
  ( 
     order_id int auto_increment primary key,
     order_date DATE,
     product_code varchar(10),
     Quantity_sold int,
     per_quantity_price int,
     total_sale_price int
  ); */
CREATE TABLE sales1 (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    product_code VARCHAR(20),
    Quantity_sold INT,
    per_quantity_price INT,
    total_sale_price INT
);

select * from sales1;


DELIMITER //
CREATE PROCEDURE MakeSale(IN pname VARCHAR(100),IN quantity INT)
BEGIN
    set @co = (select product_code from products where product_name= pname);
    set @qu = (select Quantity_remaining from products  where product_code= @co);
    set @pr = (select price from products where product_code= @co);
    IF quantity <=  @qu THEN
        INSERT INTO sales1 (order_date, product_code, Quantity_sold, per_quantity_price , total_sale_price)
        VALUES (CURRENT_DATE(), @co, quantity,@pr, quantity* @pr);
        SELECT 'Sale successful' AS message; -- Output success message
        
        update products
        set quantity_remaining = quantity_remaining - quantity,
            Quantity_sold= Quantity_sold+quantity
		where  product_name = pname;
	ELSE
        SELECT 'Insufficient quantity available' AS message;
    END IF;

END //
DELIMITER ;


call makesale ('Rolex GMT-Master II', 4);

select * from products;
select * from sales1;


-- 8 Given a Sales table containing SaleID, ProductID, SaleAmount, and SaleDate, write a SQL query to find the top  2 salespeople based on
  -- their total sales amount for the current month. If there's a tie in sales amount, prioritize the salesperson with the earlier registration date.

 CREATE TABLE Sales2(
    Sale_man_registration_date date ,
    ProductID INT,
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE,
    SalespersonID INT
);

-- Inserting Sample Data into the Sales Table
INSERT INTO Sales2 (Sale_man_registration_date, ProductID, SaleAmount, SaleDate, SalespersonID)
VALUES
    ('2023-07-15', 101, 150.00, '2023-07-05', 1),
    ('2023-07-15', 102, 200.00, '2023-07-10', 2),
    ('2023-07-15', 103, 180.00, '2023-07-15', 3),
    ('2023-07-15', 104, 220.00, '2023-07-20', 4),
    ('2023-07-15', 105, 190.00, '2023-07-25', 5),
    ('2023-07-15', 101, 210.00, '2023-08-05', 1),
    ('2023-07-15', 102, 180.00, '2023-08-10', 2),
    ('2023-07-15', 103, 200.00, '2023-08-15', 3),
    ('2023-07-15', 104, 190.00, '2023-08-20', 4),
    ('2023-07-15', 105, 220.00, '2023-08-25', 5),
    ('2024-01-10', 101, 230.00, '2024-01-05', 1),
    ('2024-01-10', 102, 190.00, '2024-01-10', 2),
    ('2024-01-10', 103, 220.00, '2024-01-15', 3),
    ('2024-01-10', 104, 190.00, '2024-01-20', 4),
    ('2024-01-10', 105, 230.00, '2024-01-25', 5),
    ('2024-01-10', 101, 240.00, '2024-02-05', 1),
    ('2024-01-10', 102, 180.00, '2024-02-10', 2),
    ('2024-01-10', 103, 220.00, '2024-02-15', 3),
    ('2024-01-10', 104, 200.00, '2024-02-20', 4),
    ('2024-01-10', 105, 210.00, '2024-02-25', 5),
    ('2024-04-15', 101, 250.00, '2024-04-05', 1),
    ('2024-04-15', 102, 200.00, '2024-04-10', 2),
    ('2024-04-15', 103, 180.00, '2024-04-15', 3),
    ('2024-04-15', 104, 220.00, '2024-04-20', 4),
    ('2024-04-15', 105, 220.00, '2024-04-25', 5),
    ('2024-04-15', 101, 210.00, '2024-05-05', 1),
    ('2024-04-15', 102, 180.00, '2024-05-10', 2),
    ('2024-04-15', 103, 200.00, '2024-05-15', 3),
    ('2024-04-15', 104, 190.00, '2024-05-20', 4),
    ('2024-04-15', 105, 220.00, '2024-05-25', 5);

select * from sales2;

select SalespersonID, sum(saleamount)as summ, min(Sale_man_registration_date) as mindate  from sales2 where year(saledate)=2024 and month(saledate) = 4 group by SalespersonID
order by summ desc , mindate
limit 3;

