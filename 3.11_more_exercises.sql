use employees;

-- How much do the current managers of each department get paid, relative to the average salary for the department? Is there any department where the department manager gets paid less than the average salary?

use bayes_819;

CREATE TEMPORARY TABLE comp_sal as
SELECT de.emp_no, s.salary, m.dept_no, m.to_date 
FROM employees.dept_emp as de
JOIN employees.salaries as s
	ON de.emp_no = s.emp_no
JOIN employees.dept_manager as m
	ON de.dept_no = m.dept_no
WHERE de.to_date = '9999-01-01';

select * from comp_sal
limit 10;

select dept_no,avg(salary)
from comp_sal
group by dept_no
limit 5;

use world;

-- What languages are spoken in Santa Monica?
select language, percentage
from city as c
join countrylanguage as cl
on c.countrycode = cl.countrycode
where c.name = 'Santa Monica';

-- How many different countries are in each region?

select region, count(name)
from country
group by region
order by count(name);

-- What is the population for each region?

select region, sum(population)
from country
group by region
order by sum(population) desc;

-- What is the population for each continent?

select continent, sum(population)
from country
group by continent
order by sum(population) desc;

-- What is the average life expectancy globally?

select avg(lifeexpectancy)
from country;

-- What is the average life expectancy for each region, each continent? Sort the results from shortest to longest

select region, avg(lifeexpectancy)
from country
group by region
order by avg(lifeexpectancy);

select continent, avg(lifeexpectancy)
from country
group by continent
order by avg(lifeexpectancy);

/*
BONUS
Find all the countries whose local name is different from the official name
How many countries have a life expectancy less than x?
What state is city x located in?
What region of the world is city x located in?
What country (use the human readable name) city x located in?
What is the life expectancy in city x? */

select name, localname
from country
where name != localname;

select name, lifeexpectancy
from country
where lifeexpectancy < 70;

select ct.name as City, cn.name as Country, region as Region
from city as ct
join country as cn
on ct.countrycode = cn.code
where ct.name = "Escobar";

select ct.name as City, cn.name as Country
from city as ct
join country as cn
on ct.countrycode = cn.code
where ct.name = "Baku";

select ct.name as City, cn.lifeexpectancy as Life_Expectancy, cn.name as Country
from city as ct
join country as cn
on ct.countrycode = cn.code
where ct.name = "Itu";

-- #### SAKILA ####

use sakila;
/* Display the first and last names in all lowercase of all the actors. */

select
concat(
upper(substring(first_name,1,1)),
lower(substring(first_name,2))
) as First_Name,
concat(
upper(substring(last_name,1,1)),
lower(substring(last_name,2))
) as Last_Name
from actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you could use to obtain this information?

select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- Find all actors whose last name contain the letters "gen":

select concat(first_name, ' ', last_name) as Actor_Name
from actor
where last_name like '%gen%';

-- Find all actors whose last names contain the letters "li". This time, order the rows by last name and first name, in that order.

select concat(first_name, ' ', last_name) as Actor_Name
from actor
where last_name like '%li%'
order by last_name, first_name;

-- Using IN, display the country_id and country columns for the following countries: Afghanistan, Bangladesh, and China:

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- List the last names of all the actors, as well as how many actors have that last name.

select last_name, count(*) as no_of_actors
from actor
group by last_name;

-- 7. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(*) as no_of_actors
from actor
group by last_name
having count(last_name) > 1;

-- 8. You cannot locate the schema of the address table. Which query would you use to re-create it?

describe address;

-- 9. Use JOIN to display the first and last names, as well as the address, of each staff member.

select s.first_name, s.last_name, a.address
from staff as s
join address as a
on s.address_id = a.address_id;

-- 10. Use JOIN to display the total amount rung up by each staff member in August of 2005.

select r.staff_id, sum(p.amount)
from rental as r
join payment as p
	on r.rental_id = p.rental_id
where r.rental_date between '2005-08-01' and '2005-08-31'
group by r.staff_id;

-- 11. List each film and the number of actors who are listed for that film.

select f.title, count(a.actor_id) as no_of_actors
from film as f
join film_actor as a
	on f.film_id = a.film_id
group by f.title;

-- 12. How many copies of the film Hunchback Impossible exist in the inventory system?

select f.title, count(*)
from inventory as i
join film as f
	on i.film_id = f.film_id
	and f.title = 'Hunchback Impossible';

-- 13. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select f.title
from film as f
where substring(f.title,1,1) in ('K','Q')
	and language_id = 
	(select l.language_id
	from language as l
	where l.name = 'English');
	
-- 14. Use subqueries to display all actors who appear in the film Alone Trip.

select concat(a.first_name, ' ', a.last_name) as Actors_in_Alone_Trip
from actor as a
join film_actor as fa
	on a.actor_id = fa.actor_id
where film_id = 
	(select f.film_id
	from film as f
	where f.title = 'Alone Trip');

-- 15. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.

select concat(cu.first_name, ' ', cu.last_name) as name, cu.email, mp.city, mp.country
from customer as cu
join address as ad
	on cu.address_id = ad.address_id
join (
	select ci.city, cn.country
	from city as ci
	join country as cn
		on ci.country_id = cn.country_id
	where cn.country = 'Canada') as mp;

-- 16. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

select distinct f.title
from film as f
join film_category as fc
where fc.category_id =
	(select c.category_id
	from category as c
	where c.name = 'Family');
	
-- 17. Write a query to display how much business, in dollars, each store brought in.

select s.store_id, sum(p.amount)
from store as s
join customer as c
	on s.store_id = c.store_id
join payment as p
	on c.customer_id = p.customer_id
group by s.store_id;

-- 18. Write a query to display for each store its store ID, city, and country.

select s.store_id, ci.city, cn.country
from store as s
join address as a
	on s.address_id = a.address_id
join city as ci
	on a.city_id = ci.city_id
join country as cn
	on ci.country_id = cn.country_id;

-- 19. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select ge.name as Genre, sum(p.amount) as Gross_Revenue
from payment as p
join rental as r
	on p.rental_id = r.rental_id
join inventory as i
	on i.inventory_id = r.inventory_id
join
	(select fc.film_id, c.name
	from category as c
	join film_category as fc
		on c.category_id = fc.category_id) as ge
group by ge.name
order by sum(p.amount) desc
limit 5;


