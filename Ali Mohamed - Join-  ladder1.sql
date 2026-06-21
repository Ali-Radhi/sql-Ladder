-- Joins
-- Which employee made which sale? Join the `employees` table onto the `transactions` table by `employee_id`. You only need to include the employee's first/last name from `employees`.
select transactions.*, employees.firstname, employees.lastname 
from transactions join employees
on transactions.employee_id = employees.id;
-- What is the name of the employee who made the most in sales? Find this answer by doing a join as in the previous problem. Your resulting query will be difficult for someone else to read.
select sum((transactions.unit_price * transactions.quantity)) as total_sales, employees.firstname, employees.lastname 
from transactions join employees
on transactions.employee_id = employees.id group by employee_id  order by total_sales desc limit 1;
-- Solve the previous problem by joining `employees` onto the `trans_by_employee` view.
select trans_by_employee.total_cost, employees.firstname, employees.lastname 
from trans_by_employee join employees
on trans_by_employee.employee_id = employees.id group by employee_id order by total_cost desc limit 1;
-- Next, the company will try to give bonuses based on performance. Show all employees who've made more in sales than 1.5 times their salary.
select sum((transactions.unit_price * transactions.quantity)) as total_sales, employees.firstname, employees.lastname 
from transactions join employees
on transactions.employee_id = employees.id group by employee_id  having total_sales > 1.5* salary;
-- Do we have potentially erroneous rows? Find all transactions which occurred before the employee was even hired! (Make sure each transaction only occupies one row).
select transactions.order_id,transactions.orderdate, employees.startdate
from transactions join employees
on transactions.employee_id = employees.id 
group by order_id having cast(employees.startdate as date) > cast(transactions.orderdate as date);
-- Among all transactions that occurred from 2015 to 2019, create a table that is the monthly revenue of our company versus the total trading volume of Yum! in that month. Format the columns nicely. (Hint: look at the views) That is, a sample row of your result might look like this:
-- ```
-- | year | month | company_revenue | yum_trade_volume |
-- |------|-------|-----------------|------------------|
-- | 2017 |    03 |        $100,000 |      125,000,000 |
-- ```
-- Hint: You don't need any `WHERE` statements here. You can get the right answer simply by changing what kind of join you do!
select yum_by_month.year, yum_by_month.month ,printf("$%,.2f", sum(transactions.quantity * transactions.unit_price)) as company_revenue ,printf("$%,.3d", yum_by_month.tot_volume) as yum_trade_volume
from yum_by_month left join transactions
on strftime('%Y', transactions.orderdate) = yum_by_month.year and  strftime('%m', transactions.orderdate) = yum_by_month.month
group by yum_by_month.year, yum_by_month.month 
