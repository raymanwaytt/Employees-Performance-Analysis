select *
from employees_data ed


-- 1.  Which departments have the highest and lowest average tenure?
select department, round(avg(years), 1) `Average tenure`
from employees_data ed 
group by department 
order by `Average tenure` desc;


-- 2. What percentage of employees have been with the company for more than five years?
select `Total Employee`,
`Emoployee > 5`,
round((`Emoployee > 5`/`Total Employee`)*100) `% Employeee > 5`
from 
	(select 
	count(*) `Total Employee`, 
	(select count(*)
	from employees_data ed 
	where years > 5) `Emoployee > 5`
	from employees_data ed) query;

-- Can this be broken down by department?
select department, 
	`Emoployee > 5`,
	round((`Emoployee > 5`/
	(select count(*) from employees_data where years > 5) * 100), 1) `% Employeee > 5`
from 
	(select department, count(*) as `Emoployee > 5`
	from employees_data ed
	where years > 5
	group by department) `Emoployee > 5`
order by `% Employeee > 5` desc;


-- 3. What is the average monthly salary by department and country?
select country, department,
round(avg(`Monthly Salary`)) `Avg Monthly Salary`, 
round(avg(`Annual Salary`)) `Avg Annual Salary`
from employees_data ed 
group by country, department
order by country, `Avg Annual Salary` desc;


-- 4. How does the salary differ by gender across different departments or countries?
select country, department, gender, round(avg(`Monthly Salary`)) 'Avg monthly salary'
from employees_data ed
group by country, department, gender
order by country, department, 'avg monthly salary';


-- 5. Are there any employees whose monthly salary doesn’t align with their annual salary (suggesting potential data errors)?
select *
from employees_data ed 
where `Monthly Salary` * 12 <> `Annual Salary` 


-- 6. What is the average number of sick and unpaid leaves taken by employees in each department?
select department, round(avg(`Sick Leaves`)) 'avg Sick Leaves', round(avg(`Unpaid Leaves`)) 'avg Unpaid Leaves'
from employees_data ed
group by department;


-- 7. How does the number of leaves taken correlate with the job rate ? Is there a threshold where leaves seem to impact job performance significantly?
select `Total Leaves`, round(avg(`Job Rate`), 1) as `Avg Tenure`
from
	(select `Sick Leaves` + `Unpaid Leaves` as `Total Leaves`, `Job Rate`
	from employees_data ed) query
group by `Total Leaves`
order by `Total Leaves`;


-- 8. Which employees have the highest number of overtime hours, and how does it relate to their monthly salary?
select concat(`First Name`,' ',`Last Name`) `full name`, `department`, `Overtime Hours`, `Monthly Salary`
from employees_data ed
order by `Overtime Hours` desc
limit 10;


-- 9. Is there a pattern between employees' overtime hours and their department?
select department, round(avg(`Overtime Hours`)) `Overtime Hours`
from employees_data ed 
group by department
order by `Overtime Hours` desc;


-- 10. Which departments or countries show a high count of employees with below-average job ratings and low tenure?
select avg(`Job Rate`), min(`years`)
from employees_data ed 

-- departments with high count of employees with below-average job ratings and low tenure?
select country, department, count(*) count
from employees_data ed 
where `Job Rate` < (select avg(`Job Rate`) from employees_data) and
		years = (select min(`years`) from employees_data)
group by country, department
order by country, count desc;

-- countries with high count of employees with below-average job ratings and low tenure?
select country , count(*) count
from employees_data ed 
where `Job Rate` < (select avg(`Job Rate`) from employees_data) and
		years = (select min(`years`) from employees_data)
group by country
order by count desc;


-- 11. How many employees work in each country and center, and what is the average salary by location?
select country, center, round(avg(`Monthly Salary`)) 'Average Monthly Salary', count(*) count
from employees_data ed 
group by country, center
order by country;


-- 12. What is the distribution of genders across departments, countries, and centers?

-- distribution of genders across departments
select department, gender, count(*) count
from employees_data ed
group by department, gender
order by department;

-- distribution of genders across countries
select country, gender, count(*) count
from employees_data ed
group by country, gender
order by country;

-- distribution of genders across centers
select center, gender, count(*) count
from employees_data ed
group by center, gender
order by center;


-- 13.What is the average job rate in each department, and does it vary significantly by location ?
-- job ratings by department
select department, country, round(avg(`Job Rate`), 1) 'average rate'
from employees_data ed 
group by department, country
order by `average rate` desc;

-- job ratings by center
select center, round(avg(`Job Rate`), 1) 'average rate'
from employees_data ed 
group by center
order by `average rate` desc;