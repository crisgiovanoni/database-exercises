-- ##### Join_Example Database #####
use `join_example_db`;

-- Use the join_example_db. Select all the records from both the users and roles tables.
SELECT * FROM roles;
SELECT * FROM users;

-- Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson. Before you run each query, guess the expected number of results.

-- 4
SELECT u.name, r.name
FROM users as u
JOIN roles as r
ON u.id = r.id;

-- 6
SELECT u.name, r.name
FROM users as u
LEFT JOIN roles as r
ON u.id = r.id;

-- 4
SELECT u.name, r.name
FROM users as u
RIGHT JOIN roles as r
ON u.id = r.id;

-- Although not explicitly covered in the lesson, aggregate functions like count can be used with join queries. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query.

SELECT roles.name as roles, count(users.name) as users
FROM roles
LEFT JOIN users
ON roles.id = users.role_id
GROUP BY roles.name;

-- ##### Employees Database #####

use employees;

-- Using the example in the Associative Table Joins section as a guide, write a query that shows each department along with the name of the current manager for that department.

SELECT departments.dept_name, concat(employees.first_name, ' ', employees.last_name) as department_manager
FROM departments
JOIN dept_manager
	ON departments.dept_no = dept_manager.dept_no
JOIN employees
	ON dept_manager.emp_no = employees.emp_no
WHERE dept_manager.to_date = '9999-01-01'
ORDER BY departments.dept_name;

-- Find the name of all departments currently managed by women.

SELECT departments.dept_name, concat(employees.first_name, ' ', employees.last_name) as department_manager
FROM departments
JOIN dept_manager
	ON departments.dept_no = dept_manager.dept_no
JOIN employees
	ON dept_manager.emp_no = employees.emp_no
WHERE dept_manager.to_date = '9999-01-01' AND employees.gender = 'F'
ORDER BY departments.dept_name;

-- Find the current titles of employees currently working in the Customer Service department.

SELECT titles.title, count(*) as Count
FROM departments
JOIN dept_emp
	ON departments.dept_no = dept_emp.dept_no
JOIN titles
	ON dept_emp.emp_no = titles.emp_no
WHERE titles.to_date = '9999-01-01' AND departments.dept_name = "Customer Service"
GROUP BY titles.title;

-- Find the current salary of all current managers.

SELECT departments.dept_name as 'Department Name', concat(employees.first_name, ' ', employees.last_name) as 'Name', salaries.salary as 'Salary'
FROM departments
JOIN dept_manager
	ON departments.dept_no = dept_manager.dept_no
JOIN employees
	ON dept_manager.emp_no = employees.emp_no
JOIN salaries
	ON employees.emp_no = salaries.emp_no
WHERE dept_manager.to_date = '9999-01-01' and salaries.to_date = '9999-01-01'
ORDER BY departments.dept_name;

-- Find the number of employees in each department.

SELECT departments.dept_no, departments.dept_name, count(employees.emp_no)
FROM departments
JOIN dept_emp
	ON departments.dept_no = dept_emp.dept_no
JOIN employees
	ON dept_emp.emp_no = employees.emp_no
WHERE dept_emp.to_date = '9999-01-01'
GROUP BY departments.dept_name
ORDER BY dept_no;

-- Which department has the highest average salary?

SELECT departments.dept_name, avg(salaries.salary) as average_salary
FROM departments
JOIN dept_emp
	ON departments.dept_no = dept_emp.dept_no
JOIN salaries
	ON dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date = '9999-01-01' and salaries.to_date = '9999-01-01'
GROUP BY departments.dept_name
ORDER BY average_salary DESC
LIMIT 1;

-- Who is the highest paid employee in the Marketing department?

SELECT employees.first_name, employees.last_name
FROM departments
JOIN dept_emp
	ON departments.dept_no = dept_emp.dept_no
JOIN salaries
	ON dept_emp.emp_no = salaries.emp_no
JOIN employees
	ON salaries.emp_no = employees.emp_no
WHERE dept_name = 'Marketing'
ORDER BY salaries.salary DESC
LIMIT 1;

-- Which current department manager has the highest salary?

SELECT employees.first_name, employees.last_name, salaries.salary, departments.dept_name
FROM departments
JOIN dept_manager
	ON departments.dept_no = dept_manager.dept_no
JOIN employees
	ON dept_manager.emp_no = employees.emp_no
JOIN salaries
	ON dept_manager.emp_no = salaries.emp_no
WHERE dept_manager.to_date = '9999-01-01' and salaries.to_date = '9999-01-01' and departments.dept_name = 'Marketing'
ORDER BY salaries.salary DESC
LIMIT 1;

-- Bonus Find the names of all current employees, their department name, and their current manager's name.

SELECT concat(employees.first_name, ' ', employees.last_name) as employee_name, departments.dept_name,
	(
SELECT departments.dept_name as d, concat(employees.first_name, ' ', employees.last_name) as manager_name
FROM departments
JOIN dept_manager
	ON departments.dept_no = dept_manager.dept_no
JOIN employees
	ON dept_manager.emp_no = employees.emp_no
WHERE dept_manager.to_date = '9999-01-01'
ORDER BY departments.dept_name;
)
FROM employees
JOIN dept_emp
WHERE departments.dept_name = d;
