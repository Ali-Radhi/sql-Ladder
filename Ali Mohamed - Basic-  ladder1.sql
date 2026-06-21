-- Query all the data in the `pets` table.  
select * from pets;

-- Query only the first 5 rows of the `pets` table.
select * from pets limit 5;

-- Query only the names and ages of the pets in the `pets` table.
select name, age from pets;
-- Query the pets in the `pets` table, sorted youngest to oldest.
select * from pets order by age;
-- Query the pets in the `pets` table alphabetically.
select * from pets order by name;
-- Query all the male pets in the `pets` table.
select * from pets where upper(sex) = 'M'
-- Query all the cats in the `pets` table.
select * from pets where lower(species) = 'cat';
-- Query all the pets in the `pets` table that are at least 5 years old.
select * from pets where age >= 5;
-- Query all the male dogs in the `pets` table. Do not include the sex or species column, since you already know them.
select * from pets where lower(sex)= 'm' and species = dog;
-- Get all the names of the dogs in the `pets` table that are younger than 5 years old.
select name from pets where age < 5;
-- Query all the pets in the `pets` table that are either male dogs or female cats.
select * from pets where (lower(sex)= 'm' and species = dog) or (lower(sex)= 'f' and species = 'cat';);
-- Query the five oldest pets in the `pets` table.
select * from pets order by age desc limit 5;
-- Get the names and ages of all the female cats in the `pets` table sorted by age, descending.
select * from pets where lower(sex)= 'f' and species = 'cat' order by age desc;
-- Get all pets from `pets` whose names start with P.
select * from pets where upper(name) like 'P%'
-- Select all employees from `employees_null` where the salary is missing.
select * from employees_null where salary is null;
-- Select all employees from `employees_null` where the salary is below $35,000 or missing.
select * from employees_null where salary > 35000 or salary is null;

-- Select all employees from `employees_null` where the job title is missing. What do you see?
select * from employees_null where job is null;

-- Who is the newest employee in `employees`? The most senior?
select * from employees order by startdate ;

-- Select all employees from `employees` named Thomas.
select * from employees where firstname = 'Thomas' ;

-- Select all employees from `employees` named Thomas or Shannon.
select * from employees where firstname = 'Thomas' or firstname = 'Shannon';

-- Select all employees from `employees` named Robert, Lisa, or any name that begins with a J. In addition, only show employees who are not in sales. This will be a little bit of a longer query.
select * from employees where (firstname = 'Robert' or firstname = 'Lisa' or upper(firstname) like 'J%' ) and job != 'Sales';

-- Hint: There will only be 6 rows in the result.

-- 
-- Column Operations

-- Query the top 5 rows of the `employees` table to get a glimpse of these new data.
select * from employees limit 5;
-- Query the `employees` table, but convert their salaries to Euros.
SELECT *,CAST(salary * 1.1 AS float) AS salary_eu FROM employees;
-- Hint: 1 Euro = 1.1 USD.
-- Hint2: If you think the output is ugly, try out the `ROUND()` function.
-- Repeat the previous problem, but rename the column `salary_eu`.
SELECT *,CAST(salary * 1.1 AS float) AS salary_eu FROM employees;

-- Query the `employees` table, but combine the `firstname` and `lastname` columns to be "Firstname, Lastname" format. Call this column `fullname`. For example, the first row should contain `Thompson, Christine` as `fullname`. Also, display the rounded `salary_eu` instead of `salary`.
SELECT firstname || ','|| lastname as 'Full Name',CAST(salary * 1.1 AS float) AS salary_eu FROM employees;
-- Hint: The string concatenation operator is `||`

-- Query the `employees` table, but replace `startdate` with `startyear` using the `SUBSTR()` function. Also include `fullname` and `salary_eu`.
SELECT firstname || ','|| lastname as 'Full Name',CAST(salary * 1.1 AS float) AS salary_eu, substr(startdate, 1,4) as 'startyear' FROM employees;

-- Repeat the above problem, but instead of using `SUBSTR()`, use `STRFTIME()`.
SELECT firstname || ',' || lastname AS 'Full Name',CAST(salary * 1.1 AS FLOAT) AS salary_eu, strftime('%Y', startdate) AS 'startyear' FROM employees;
-- Query the `employees` table, replacing `firstname`/`lastname` with `fullname` and `startdate` with `startyear`. Print out the salary in USD again, except format it with a dollar sign, comma separators, and no decimal. For example, the first row should read `$123,696`. This column should still be named `salary`.
SELECT firstname || ','|| lastname as 'Full Name', printf("$%,.2d", salary) salary, substr(startdate, 1,4) as 'startyear' FROM employees;

-- Hint: Check out SQLite's `printf` function.
-- Hint2: The format string you'll need is `$%,.2d`. You should read more about such formatting strings as they're useful in Python, too!
-- Note: For the next few problems, you'll probably want to use `CASE`/`WHEN` statements.
-- Last year, only salespeople were eligible for bonuses. Create a column `bonus` that is "Yes" if you're eligible for a bonus, otherwise "No".
select *, CASE when lower(job) = 'sales' then 'Yes' else 'No' End as bonus from employees;
-- This year, only sales people with a salary of $100,000 or higher are eligible for bonuses. Create a `bonus` column like in the last problem for salespeople with salaries at least $100,000.
select *, CASE when lower(job) = 'sales' and salary > 100000 then 'Yes' else 'No' End as bonus from employees;

-- Next year, the bonus structure will be a little more complicated. You'll create a `target_comp` column which represents an employee's target total compensation after their bonus. Here is the company's bonus structure:
select "ID"
,"firstname"
,"lastname"
,"job"
,"startdate"
,printf("$%,.2d", salary) as salary, CASE 
when lower(job) = 'sales' and salary > 100000 then salary * 0.1
when lower(job) = 'sales' and salary < 100000 then salary * 0.05
when lower(job) = 'administrator' then salary * 0.05
else salary End as target_comp from employees;

-- Salespeople who make more than $100,000 will be eligible for a 10% bonus.
-- Salespeople who make less than $100,000 will be eligible for a 5% bonus.
-- Administrators will also be eligible for a 5% bonus.
-- Anyone who does not meet any of the above descriptions is not eligible for a bonus.
-- Create this `target_comp` column, making sure to format both the `salary` and `target_comp` columns nicely (ie, with dollar signs and comma separators).
