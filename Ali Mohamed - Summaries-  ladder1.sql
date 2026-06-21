-- 
-- How many rows are in the `pets` table?
select count(*) from pets;
-- How many female pets are in the `pets` table?
select count(*) from pets where lower(sex) = 'f';
-- How many female cats are in the `pets` table?
select count(*) from pets where lower(sex) = 'f' and lower(species) = 'cat';

-- What's the mean age of pets in the `pets` table?
select round(avg(age),2) from pets;

-- What's the mean age of dogs in the `pets` table?
select round(avg(age),2) from pets where lower(species) = 'dog';
-- What's the mean age of male dogs in the `pets` table?
select round(avg(age),2) from pets where lower(species) = 'dog' and lower(sex) = 'm';

-- What's the count, mean, minimum, and maximum of pet ages in the `pets` table?
select count(age), round(avg(age),2), min(age), max(age) from pets ;

-- NOTE: SQLite doesn't have built-in formulas for standard deviation or median!
-- Repeat the previous problem with the following stipulations:
-- Round the average to one decimal place.
select round(avg(age),1) from pets where lower(species) = 'dog';

-- Give each column a human-readable column name (for example, "Average Age")
select count(age) as num_of_pets, round(avg(age),2) as average_age, min(age) as minimum_age, max(age) as maximum_age from pets ;

-- How many rows in `employees_null` have missing salaries?
select count(*) from "employees_null" where salary is null;
-- How many salespeople in `employees_null` having nonmissing salaries?
select count(*) from "employees_null" where lower(job) = 'sales' and salary is not null;

-- What's the mean salary of employees who joined the company after 2010? Go back to the usual `employees` table for this one.
select avg(salary),cast(startdate as date) as year from "employees" where year > 2010  ;
-- Hint: You may need to use the `CAST()` function for this. To cast a string as a float, you can do `CAST(x AS REAL)`
-- What's the mean salary of employees in Swiss Francs?
SELECT firstname, lastname,CAST(salary * 0.97 AS float) AS salary_sw FROM employees;
-- Hint: Swiss Francs are abbreviated "CHF" and 1 USD = 0.97 CHF.
-- Create a query that computes the mean salary in USD as well as CHF. Give the columns human-readable names (for example "Mean Salary in USD"). Also, format them with comma delimiters and currency symbols.
SELECT printf("$%,.2d", avg(salary)) as average_salary_us,printf("Fr.%,.2d",avg(CAST(salary * 0.97 AS float))) AS average_salary_fr FROM employees;
-- NOTE: Comma-delimiting numbers is only available for integers in SQLite, so rounding (down) to the nearest dollar or franc will be done for us.
-- NOTE2: The symbols for francs is simply `Fr.` or `fr.`. So an example output will look like `100,000 Fr.`.

-- Aggregating Statistics with GROUP BY
-- What is the average age of `pets` by species?
select avg(age) from pets;
-- Repeat the previous problem but make sure the species label is also displayed! Assume this behavior is always being asked of you any time you use `GROUP BY`.
select species, avg(age) from pets group by species;

-- What is the count, mean, minimum, and maximum age by species in `pets`?
select species, count(*),avg(age), min(age), max(age) from pets group by species;

-- Show the mean salaries of each job title in `employees`.
select job, avg(salary) from employees group by job;

-- Show the mean salaries in New Zealand dollars of each job title in `employees`.
-- NOTE: 1 USD = 1.65 NZD.
SELECT job,printf("NZD.%,.2d",avg(CAST(salary * 1.65 AS float))) AS average_salary_NZ FROM employees group by job;

-- Show the mean, min, and max salaries of each job title in `employees`, as well as the numbers of employees in each category.
select job,count(*) as num_of_employees, avg(salary) as average_salary, max(salary)as maximum_salary, min(salary) as lowest_salary from employees group by job;
-- Show the mean salaries of each job title in `employees` sorted descending by salary.
-- What are the top 5 most common first names among `employees`?
select firstname,count(*) as num_of_ocr from employees group by firstname order by num_of_ocr desc limit 5;

-- Show all first names which have exactly 2 occurrences in `employees`.
select firstname,count(*) as num_of_ocr from employees group by firstname having num_of_ocr = 2;

-- Take a look at the `transactions` table to get a idea of what it contains. Note that a transaction may span multiple rows if different items are purchased as part of the same order. The employee who made the order is also given by their ID.
-- Show the top 5 largest orders (and their respective customer) in terms of the numbers of items purchased in that order.
select order_id,customer,count(*) as num_of_items from transactions group by order_id, customer order by num_of_items desc limit 5;
-- Show the total cost of each transaction.
select order_id,customer,count(*) as num_of_items, sum(unit_price * quantity) as total_cost from transactions group by order_id, customer;

-- Hint: The `unit_price` column is the price of one item. The customer may have purchased multiple.
-- Hint2: Note that transactions here span multiple rows if different items are purchased.
-- Show the top 5 transactions in terms of total cost.
select order_id,customer,count(*) as num_of_items, sum(unit_price * quantity) as total_cost from transactions group by order_id, customer order by total_cost desc limit 5 ;

-- Show the top 5 customers in terms of total revenue (ie, which customers have we done the most business with in terms of money?)
select customer, sum(unit_price * quantity) as total_revenue from transactions group by customer order by total_revenue desc limit 5 ;

-- Show the top 5 employees in terms of revenue generated (ie, which employees made the most in sales?)
select employee_id, sum(unit_price * quantity) as total_sales_revenue from transactions group by employee_id order by total_sales_revenue desc limit 5 ;

-- Which customer worked with the largest number of employees?
select customer, count(distinct employee_id) as num_of_employees from transactions group by customer order by num_of_employees desc limit 1 ;

-- Hint: This is a tough one! Check out the `DISTINCT` keyword.
-- Show all customers who've done more than $80,000 worth of business with us.

select customer, sum(unit_price * quantity) as total_revenue from transactions group by customer having total_revenue > 80000 ;
