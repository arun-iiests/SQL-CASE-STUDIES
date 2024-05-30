use campusx;

/* 
1.	You're a Compensation analyst employed by a multinational corporation. 
Your Assignment is to Pinpoint Countries who give work fully remotely, 
for the title 'managers’ Paying salaries Exceeding $90,000 USD
*/

select distinct company_location from salaries where job_title like '%Manager%' and salary_in_usd > 90000 and remote_ratio =100;

/*2.AS a remote work advocate Working for a progressive HR tech startup who place their freshers’ clients IN large tech firms. you're tasked WITH 
Identifying top 5 Country Having  greatest count of large(company size) number of companies.*/

select company_location, count(*) as cnt from 
(
select * from salaries where experience_level ='EN' and company_size='L'
)t group by company_location 
order by cnt desc 
limit 5 ;

/*3. Picture yourself AS a data scientist Working for a workforce management platform. Your objective is to calculate the percentage of employees. 
Who enjoy fully remote roles WITH salaries Exceeding $100,000 USD, Shedding light ON the attractiveness of high-paying remote positions IN today's job market.*/

set @total= (select count(*) from salaries where salary_in_usd >100000 );
set @count= (select count(*) from salaries where salary_in_usd >100000 and remote_ratio=100 );
SELECT ROUND((@count / @total) * 100, 2);

/*4.	Imagine you're a data analyst Working for a global recruitment agency. Your Task is to identify the Locations where entry-level average salaries exceed the 
average salary for that job title in market for entry level, helping your agency guide candidates towards lucrative countries.*/

select company_locatiON, t.job_title, average_per_country, average from 
(
select job_title,company_location, avg(salary_in_usd) as average_per_country from salaries WHERE experience_level = 'EN' group by job_title, company_location
) t
inner join 
(
select job_title, avg(salary_in_usd) as average from salaries WHERE experience_level = 'EN' group by job_title
) p
on t.job_title=p.job_title where average_per_country > average;

/*5. You've been hired by a big HR Consultancy to look at how much people get paid IN different Countries. Your job is to Find out for each job title which
Country pays the maximum average salary. This helps you to place your candidates IN those countries.*/

select * from
(
select *, dense_rank() over(partition by job_title order by average ) as "rank_list" from
(
select company_location,job_title,avg(salary_in_usd) as average from  salaries  group by company_location,job_title
)t 
)k where rank_list = 1;


/*6.  AS a data-driven Business consultant, you've been hired by a multinational corporation to analyze salary trends across different company Locations.
 Your goal is to Pinpoint Locations WHERE the average salary Has consistently Increased over the Past few years (Countries WHERE data is available for 3 years Only
 (this and pst two years) 
 providing Insights into Locations experiencing Sustained salary growth.*/
 
SELECT 
    m.experience_level, 
    m.remote_2021, 
    n.remote_2024
FROM
(
    SELECT 
        a.experience_level, 
        ROUND((b.cnt / a.total) * 100, 2) AS remote_2021 
    FROM 
    (
        SELECT experience_level, COUNT(*) AS total 
        FROM salaries 
        WHERE work_year = 2021 
        GROUP BY experience_level
    ) a 
    INNER JOIN
    (
        SELECT experience_level, COUNT(*) AS cnt 
        FROM salaries 
        WHERE work_year = 2021 AND remote_ratio = 100 
        GROUP BY experience_level
    ) b 
    ON a.experience_level = b.experience_level
) m 
INNER JOIN 
(
    SELECT 
        a.experience_level, 
        ROUND((b.cnt / a.total) * 100, 2) AS remote_2024 
    FROM 
    (
        SELECT experience_level, COUNT(*) AS total 
        FROM salaries 
        WHERE work_year = 2024 
        GROUP BY experience_level
    ) a 
    INNER JOIN
    (
        SELECT experience_level, COUNT(*) AS cnt 
        FROM salaries 
        WHERE work_year = 2024 AND remote_ratio = 100 
        GROUP BY experience_level
    ) b 
    ON a.experience_level = b.experience_level
) n 
ON m.experience_level = n.experience_level;

 /* 8. AS a compensatiON specialist at a Fortune 500 company, you're tASked WITH analyzINg salary trends over time. Your objective is to calculate the
 average salary INcreASe percentage for each experience level and job title between the years 2023 and 2024, helpINg the company stay competitive IN 
 the talent market.*/
 
 WITH t AS
(
SELECT experience_level, job_title ,work_year, round(AVG(salary_in_usd),2) AS 'average'  FROM salaries WHERE work_year IN (2023,2024) 
GROUP BY experience_level, job_title, work_year
)  -- step 1



SELECT *,round((((AVG_salary_2024-AVG_salary_2023)/AVG_salary_2023)*100),2)  AS changes
FROM
(
	SELECT 
		experience_level, job_title,
		MAX(CASE WHEN work_year = 2023 THEN average END) AS AVG_salary_2023,
		MAX(CASE WHEN work_year = 2024 THEN average END) AS AVG_salary_2024
	FROM  t GROUP BY experience_level , job_title -- step 2
)a WHERE (((AVG_salary_2024-AVG_salary_2023)/AVG_salary_2023)*100)  IS NOT NULL ;

/* 9. You're a database administrator tasked with role-based access control for a company's employee database. Your goal is to implement a security 
measure where employees in different experience level (e.g.Entry Level, Senior level etc.) can only access details relevant to their respective 
experience_level, ensuring data confidentiality and minimizing the risk of unauthorized access.*/

select distinct experience_level from salaries;

CREATE USER  'Entry_lebel'@'%' identified by 'EN';

CREATE VIEW Entry_lebel AS 
select * from salaries where experience_level='EN';

GRANT SELECT ON campusx.entry_lebel to 'Entry_lebel'@'%';

/* 10.	You are working with an consultancy firm, your client comes to you with certain data and preferences such as 
( their year of experience , their employment type, company location and company size )  and want to make an transaction into different domain in data industry
(like  a person is working as a data analyst and want to move to some other domain such as data science or data engineering etc.)
your work is to  guide them to which domain they should switch to base on  the input they provided, so that they can now update thier knowledge as  per the suggestion/.. 
The Suggestion should be based on average salary.*/

DELIMITER //
create PROCEDURE GetAverageSalary(IN exp_lev VARCHAR(2), IN emp_type VARCHAR(3), IN comp_loc VARCHAR(2), IN comp_size VARCHAR(2))
BEGIN
    SELECT job_title, experience_level, company_location, company_size, employment_type, ROUND(AVG(salary), 2) AS avg_salary 
    FROM salaries 
    WHERE experience_level = exp_lev AND company_location = comp_loc AND company_size = comp_size AND employment_type = emp_type 
    GROUP BY experience_level, employment_type, company_location, company_size, job_title order by avg_salary desc ;
END//
DELIMITER ;
-- Deliminator  By doing this, you're telling MySQL that statements within the block should be parsed as a single unit until the custom delimiter is encountered.

call GetAverageSalary('EN','FT','AU','M');


drop procedure Getaveragesalary;


/*11.As a market researcher, your job is to Investigate the job market for a company that analyzes workforce data. Your Task is to know how many people were
 employed IN different types of companies AS per their size IN 2021.*/
-- Select company size and count of employees for each size.
SELECT company_size, COUNT(company_size) AS 'COUNT of employees' 
FROM salaries 
WHERE work_year = 2021 
GROUP BY company_size;


/*12.Imagine you are a talent Acquisition specialist Working for an International recruitment agency. Your Task is to identify the top 3 job titles that 
command the highest average salary Among part-time Positions IN the year 2023.*/
SELECT job_title, AVG(salary_in_usd) AS 'average' 
FROM salaries  
WHERE employment_type = 'PT'  
GROUP BY job_title 
ORDER BY AVG(salary_IN_usd) DESC 
LIMIT 3;

/*13.As a database analyst you have been assigned the task to Select Countries where average mid-level salary is higher than overall mid-level salary for the year 2023.*/

-- Calculate the average mid-level salary and store it in a variable
SET @average = (SELECT AVG(salary_IN_usd) AS 'average' FROM salaries WHERE experience_level='MI');

-- Select company location and average mid-level salary for countries where the salary exceeds the calculated average.
SELECT company_location, AVG(salary_IN_usd) 
FROM salaries 
WHERE experience_level = 'MI' AND salary_IN_usd > @average 
GROUP BY company_location;


/*14.As a database analyst you have been assigned the task to Identify the company locations with the highest and lowest average salary for 
senior-level (SE) employees in 2023.*/

DELIMITER //
create procedure get_max_min_salary2()
BEGIN
	-- max salary
	select company_location, avg(salary_in_usd) as max_salary from salaries 
	where work_year=2023 and experience_level='SE'
	group by company_location
	order by max_salary desc 
	limit 1; 

	-- min salary
	select company_location,avg(salary_in_usd) as min_salary from salaries 
	where work_year=2023 and experience_level='SE'
	group by company_location
	order by min_salary asc 
	limit 1; 
end //

delimiter ;

call get_max_min_salary2();

/*15. You're a Financial analyst Working for a leading HR Consultancy, and your Task is to Assess the annual salary growth rate for various job titles. 
By Calculating the percentage Increase IN salary FROM previous year to this year, you aim to provide valuable Insights Into salary trends WITHIN different job roles.*/

with t as 
(	select a.job_title, average_current_year, average_previous_year from 
		(
		select job_title, avg(salary_in_usd) as average_current_year from salaries 
		where work_year = year(curdate()) 
		group by job_title
		) a inner join 
		(
		select job_title, avg(salary_in_usd) as average_previous_year from salaries 
		where work_year = (year(curdate()) - 1)
		group by job_title
		) b on a.job_title = b.job_title
)
SELECT *, ROUND((((average_current_year-average_previous_year)/average_previous_year)*100),2) AS 'percentage_change'
FROM t;

/*16. You've been hired by a global HR Consultancy to identify Countries experiencing significant salary growth for entry-level roles. Your task is to list the top three 
 Countries with the highest salary growth rate FROM 2020 to 2023, helping multinational Corporations identify  Emerging talent markets.*/

WITH t AS   -- creating CTE
(
    -- Subquery to calculate average salary for entry-level roles in 2021 and 2023
    SELECT 
        company_location, 
        work_year, 
        AVG(salary_in_usd) as average 
    FROM 
        salaries 
    WHERE 
        experience_level = 'EN' 
        AND (work_year = 2021 OR work_year = 2023)
    GROUP BY  
        company_location, 
        work_year
)
-- Main query to calculate percentage change in salary from 2021 to 2023 for each country
SELECT 
    *, 
    (((AVG_salary_2023 - AVG_salary_2021) / AVG_salary_2021) * 100) AS changes
FROM
(
    -- Subquery to pivot the data and calculate average salary for each country in 2021 and 2023
    SELECT 
        company_location,
        MAX(CASE WHEN work_year = 2021 THEN average END) AS AVG_salary_2021,
        MAX(CASE WHEN work_year = 2023 THEN average END) AS AVG_salary_2023
    FROM 
        t 
    GROUP BY 
        company_location
) a 
-- Filter out null values and select the top three countries with the highest salary growth rate
WHERE 
    (((AVG_salary_2023 - AVG_salary_2021) / AVG_salary_2021) * 100) IS NOT NULL  
ORDER BY 
    (((AVG_salary_2023 - AVG_salary_2021) / AVG_salary_2021) * 100) DESC 
    limit 3 ;


/*17. You have been hired by a market research agency where you been assigned the task to show the percentage of different employment type (full time, part time) in 
Different job roles, in the format where each row will be job title, each column will be type of employment type and  cell value  for that row and column will show 
the % value*/
SELECT 
    job_title,
    ROUND((SUM(CASE WHEN employment_type = 'PT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS PT_percentage, -- Calculate percentage of part-time employment
    ROUND((SUM(CASE WHEN employment_type = 'FT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS FT_percentage, -- Calculate percentage of full-time employment
    ROUND((SUM(CASE WHEN employment_type = 'CT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS CT_percentage, -- Calculate percentage of contract employment
    ROUND((SUM(CASE WHEN employment_type = 'FL' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS FL_percentage -- Calculate percentage of freelance employment
FROM 
    salaries
GROUP BY 
    job_title; -- Group the result by job title;
    
    
    
select * from salaries;












