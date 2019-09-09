use `bayes_819`;
/* Using the example from the lesson, re-create the employees_with_departments table.

Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
Update the table so that full name column contains the correct data
Remove the first_name and last_name columns from the table.
What is another way you could have ended up with this same table? */

CREATE TEMPORARY TABLE employees_with_departments AS
SELECT emp_no, first_name, last_name, dept_no, dept_name
FROM employees.employees
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING(dept_no)
LIMIT 100;

ALTER TABLE employees_with_departments ADD full_name VARCHAR(30);

UPDATE employees_with_departments
SET full_name = concat(first_name, " ", last_name);

SELECT * FROM employees_with_departments;

ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

-- When creating a temporary table, instead of selecting first_ and last_name, I would concat and alias them to "full_name"

/* Create a temporary table based on the payment table from the sakila database.

Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199. */
use bayes_819;

CREATE TEMPORARY TABLE sakila_copy AS
SELECT payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
FROM sakila.payment;

ALTER TABLE sakila_copy ADD amount_no_dec INT(3);

SELECT *
FROM sakila_copy;

UPDATE sakila_copy
SET amount_no_dec = amount*100;

/* Find out how the average pay in each department compares to the overall average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department to work for? The worst? */

use bayes_819;

CREATE TEMPORARY TABLE emp_tempt AS
SELECT de.emp_no, d.dept_no, s.salary, de.from_date, s.to_date, d.dept_name
FROM employees.salaries as s
JOIN employees.dept_emp as de USING(emp_no)
JOIN employees.departments as d USING(dept_no)
	WHERE s.to_date = '9999-01-01' and de.to_date = '9999-01-01';
	
select * from emp_tempt
limit 10;

alter table emp_tempt add mean float;
alter table emp_tempt add std float;
alter table emp_tempt add zscore float;

select avg(salary)
from emp_tempt;
-- 72007.2359

update emp_tempt
set mean = 72007.0;

select std(salary)
from emp_tempt;
-- 17309.95933

update emp_tempt
set std = 17309;

update emp_tempt
set zscore = (salary - mean) / std;

select *
from emp_tempt
limit 10;

-- Z-Score per Department
select dept_name, avg(zscore)
from emp_tempt
group by dept_name;

alter table emp_tempt add years_with_company int unsigned;


update emp_tempt
set years_with_company = datediff(from_date, min(to_date);
