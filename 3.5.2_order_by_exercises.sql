use employees;

-- Modify your first query to order by first name. The first result should be Irena Reutenauer and the last result should be Vidya Simmen.
select * from employees
where first_name IN ('Irena', 'Vidya', 'Maya')
order by first_name;

-- Update the query to order by first name and then last name. The first result should now be Irena Acton and the last should be Vidya Zweizig.
select * from employees
where first_name IN ('Irena', 'Vidya', 'Maya')
order by first_name, last_name;

-- Change the order by clause so that you order by last name before first name. Your first result should still be Irena Acton but now the last result should be Maya Zyda.
select * from employees
where first_name IN ('Irena', 'Vidya', 'Maya')
order by last_name, first_name;

-- Update your queries for employees with 'E' in their last name to sort the results by their employee number. Your results should not change!
select * from employees
where last_name like 'E%'
order by emp_no;

-- Now reverse the sort order for both queries.

select * from employees
where first_name IN ('Irena', 'Vidya', 'Maya')
order by last_name, first_name desc;

select * from employees
where last_name like 'E%'
order by emp_no desc;

-- Change the query for employees hired in the 90s and born on Christmas such that the first result is the oldest employee who was hired last. It should be Khun Bernini.

select * from employees
where (hire_date between '1990-01-01' and '1999-12-31') and (birth_date like '%-12-25')
order by birth_date, hire_date DESC;