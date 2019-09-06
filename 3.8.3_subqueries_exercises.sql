-- ##### employees database #####
use employees;

-- Find all the employees with the same hire date as employee 101010 using a sub-query. 69 Rows

SELECT *
FROM employees
WHERE hire_date =
	(SELECT hire_date
	FROM employees
	WHERE emp_no = 101010);
	
-- Find all the titles held by all employees with the first name Aamod. 314 total titles, 6 unique titles

SELECT t.title, concat(e.first_name, ' ', e.last_name)
FROM employees as e
JOIN titles as t
ON e.emp_no = t.emp_no
WHERE e.first_name IN
	(SELECT first_name
	FROM employees
	WHERE first_name = 'Aamod');

-- How many people in the employees table are no longer working for the company?

SELECT count(*)
FROM (
	SELECT emp_no
	FROM employees
	WHERE hire_date != '9999-01-01') as e;


-- Find all the current department managers that are female.

SELECT e.first_name, e.last_name
FROM employees as e
WHERE e.gender = 'F'
AND emp_no IN
	(SELECT emp_no
	FROM dept_manager
	WHERE to_date = '9999-01-01');
	
-- Find all the employees that currently have a higher than average salary. 154543 rows in total. Here is what the first 5 rows will look like:
SELECT employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries
	ON employees.emp_no = salaries.emp_no
WHERE salaries.to_date = '9999-01-01' AND salaries.salary >
	(SELECT avg(salary)
	FROM salaries
	);
	
-- How many current salaries are within 1 standard deviation of the highest salary? (Hint: you can use a built in function to calculate the standard deviation.) 78 salaries

SELECT salaries.salary
FROM salaries
WHERE salaries.to_date = '9999-01-01' AND salaries.salary >=
	(
	SELECT (max(salary) - std(salary))
	FROM salaries
	);
	
-- What percentage of all salaries is this?

SELECT concat(count(salaries.salary)/
	(
	SELECT count(sl.salary)
	FROM salaries as sl
	WHERE sl.to_date = '9999-01-01'
	) * 100,"%")
FROM salaries
WHERE salaries.to_date = '9999-01-01' AND salaries.salary >=
	(
	SELECT (max(salary) - std(salary))
	FROM salaries
	);
	
-- Find all the department names that currently have female managers.

SELECT DISTINCT departments.dept_name
FROM departments
WHERE departments.dept_no IN
	(
	SELECT dept_no
	FROM employees
	JOIN dept_manager
		ON employees.emp_no = dept_manager.emp_no
		AND dept_manager.to_date = '9999-01-01'
		AND employees.gender = 'F'
	)
	;
	
-- Find the first and last name of the employee with the highest salary.

SELECT first_name, last_name
FROM employees
JOIN salaries
	ON employees.emp_no = salaries.emp_no
WHERE salary =
	(
	SELECT max(salary)
	FROM salaries
	);

-- Find the department name that the employee with the highest salary works in.

SELECT dept_name
FROM departments as d
JOIN dept_emp as de
	ON d.dept_no = de.dept_no
	AND de.emp_no =
		(SELECT e.emp_no
		FROM employees as e
		JOIN salaries as s
			ON e.emp_no = s.emp_no
		WHERE salary =
			(
			SELECT max(salary)
			FROM salaries
			));
