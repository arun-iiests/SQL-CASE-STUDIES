use campusx;

select * from sharktank;

TRUNCATE table sharktank;

-- Load data infile
load data infile "C:/DataAnalysis/Data_Analysis_projects/Shark_tank_India/sharktank.csv"
into table sharktank
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows ;

select * from sharktank;

-- 1 Your Team have to  promote shark Tank India  season 4, The senior come up with the idea to show highest funding domain wise  
--  and you were assigned the task to show the same.

		select * from
			(
			select   industry, `Total_Deal_Amount(in_lakhs)`,row_number() over(partition by industry order by `Total_Deal_Amount(in_lakhs)` desc) as rnk from sharktank
			) t where rnk=1;

-- 2 You have been assigned the role of finding the domain where female as pitchers have female to male pitcher ratio >70%

		select * ,(female/Male)*100 as ratio from
		(
		select Industry, sum(female_presenters) as 'Female', sum(male_presenters) as 'Male' from sharktank group by Industry 
        having sum(female_presenters)>0  and sum(male_presenters)>0
		)m where (female/Male)*100>70;


-- 3 You are working at marketing firm of Shark Tank India, you have got the task to determine volume of per year sale pitch made, pitches who received 
-- offer and pitches that were converted. Also show the percentage of pitches converted and percentage of pitches received.

		select k.season_number , k.total_pitches , m.pitches_received, ((pitches_received/total_pitches)*100) as 'percentage  pitches received', l.pitches_converted 
		,((pitches_converted/pitches_received)*100) as 'Percentage pitches converted' 
		 from
		(
				(
				select season_number , count(startup_Name) as 'Total_pitches' from sharktank group by season_number
				)k 
				inner join
				(
				select season_number , count(startup_name) as 'Pitches_Received' from sharktank where received_offer='yes' group by season_number
				)m on k.season_number= m.season_number
				inner join
				(
				select season_number , count(Accepted_offer) as 'Pitches_Converted' from sharktank where  Accepted_offer='Yes' group by  season_number 
				)l on m.season_number= l.season_number
		);

-- 4 As a venture capital firm specializing in investing in startups featured on a renowned entrepreneurship TV show, how would you determine the season with the
-- highest average monthly sales and identify the top 5 industries with the highest average monthly sales during that season to optimize investment decisions?


		set @seas= (select season_number  from
		(
		select  season_number , round(avg(`Monthly_Sales(in_lakhs)`),2)as 'average' from sharktank where`Monthly_Sales(in_lakhs)` != 'Not_mentioned'
		 group by season_number  
		 )k order by average desc
		 limit 1);
		 
		select @seas;

		select industry , round(avg(`Monthly_Sales(in_lakhs)`),2) as average from  sharktank where season_number = @seas and `Monthly_Sales(in_lakhs)`!= 'Not_mentioned'
		group by industry
		order by average desc
		limit 5;

-- 5.As a data scientist at our firm, your role involves solving real-world challenges like identifying industries with consistent increases in funds raised over 
-- multiple seasons. This requires focusing on industries where data is available across all three years.
--  Once these industries are pinpointed, your task is to delve into the specifics, analyzing the number of pitches made, offers received, and offers 
-- converted per season within each industry.

select industry ,season_number , sum(`Total_Deal_Amount(in_lakhs)`) from sharktank group by industry ,season_number;

WITH ValidIndustries AS (
    SELECT 
        industry, 
        MAX(CASE WHEN season_number = 1 THEN `Total_Deal_Amount(in_lakhs)` END) AS season_1,
        MAX(CASE WHEN season_number = 2 THEN `Total_Deal_Amount(in_lakhs)` END) AS season_2,
        MAX(CASE WHEN season_number = 3 THEN `Total_Deal_Amount(in_lakhs)` END) AS season_3
    FROM sharktank 
    GROUP BY industry 
    HAVING season_3 > season_2 AND season_2 > season_1 AND season_1 != 0
)

SELECT 
    t.season_number,
    t.industry,
    COUNT(t.startup_Name) AS Total,
    COUNT(CASE WHEN t.received_offer = 'Yes' THEN t.startup_Name END) AS Received,
    COUNT(CASE WHEN t.accepted_offer = 'Yes' THEN t.startup_Name END) AS Accepted
FROM sharktank AS t
JOIN ValidIndustries AS v ON t.industry = v.industry
GROUP BY t.season_number, t.industry; 

-- 6. Every shark want to  know in how much year their investment will be returned, so you have to create a system for them , where shark will enter the name of the 
-- startup's  and the based on the total deal and quity given in how many years their principal amount will be returned.

		delimiter //
		create procedure TOT( in startup varchar(100))
		begin
		   case 
			  when (select Accepted_offer ='No' from sharktank where startup_name = startup)
					then  select 'Turn Over time cannot be calculated';
			 when (select Accepted_offer ='yes' and `Yearly_Revenue(in_lakhs)` = 'Not Mentioned' from sharktank where startup_name= startup)
				   then select 'Previous data is not available';
			 else
				 select `startup_name`,`Yearly_Revenue(in_lakhs)`,`Total_Deal_Amount(in_lakhs)`,`Total_Deal_Equity(%)`, 
				 `Total_Deal_Amount(in_lakhs)`/((`Total_Deal_Equity(%)`/100)*`Total_Deal_Amount(in_lakhs)`) as 'years'
				 from sharktank where Startup_Name= startup;
			
			end case;
		end
		//
		DELIMITER ;


		call tot('BluePineFoods');


-- 7. In the world of startup investing, we're curious to know which big-name investor, often referred to as "sharks," tends to put the most money into each
-- deal on average. This comparison helps us see who's the most generous with their investments and how they measure up against their fellow investors.

select sharkname, round(avg(investment),2)  as 'average' from
(
SELECT `Namita_Investment_Amount(in lakhs)` AS investment, 'Namita' AS sharkname FROM sharktank WHERE `Namita_Investment_Amount(in lakhs)` > 0
union all
SELECT `Vineeta_Investment_Amount(in_lakhs)` AS investment, 'Vineeta' AS sharkname FROM sharktank WHERE `Vineeta_Investment_Amount(in_lakhs)` > 0
union all
SELECT `Anupam_Investment_Amount(in_lakhs)` AS investment, 'Anupam' AS sharkname FROM sharktank WHERE `Anupam_Investment_Amount(in_lakhs)` > 0
union all
SELECT `Aman_Investment_Amount(in_lakhs)` AS investment, 'Aman' AS sharkname FROM sharktank WHERE `Aman_Investment_Amount(in_lakhs)` > 0
union all
SELECT `Peyush_Investment_Amount((in_lakhs)` AS investment, 'peyush' AS sharkname FROM sharktank WHERE `Peyush_Investment_Amount((in_lakhs)` > 0
union all
SELECT `Amit_Investment_Amount(in_lakhs)` AS investment, 'Amit' AS sharkname FROM sharktank WHERE `Amit_Investment_Amount(in_lakhs)` > 0
union all
SELECT `Ashneer_Investment_Amount` AS investment, 'Ashneer' AS sharkname FROM sharktank WHERE `Ashneer_Investment_Amount` > 0
)k group by sharkname;


-- 8. Develop a system that accepts inputs for the season number and the name of a shark. The procedure will then provide detailed insights into the total investment made by 
-- that specific shark across different industries during the specified season. Additionally, it will calculate the percentage of their investment in each sector relative to
-- the total investment in that year, giving a comprehensive understanding of the shark's investment distribution and impact.

DELIMITER //
create PROCEDURE getseasoninvestment(IN season INT, IN sharkname VARCHAR(100))
BEGIN
      
    CASE 

        WHEN sharkname = 'namita' THEN
            set @total = (select  sum(`Namita_Investment_Amount(in lakhs)`) from sharktank where Season_Number= season );
            SELECT Industry, sum(`Namita_Investment_Amount(in lakhs)`) as 'sum' ,(sum(`Namita_Investment_Amount(in lakhs)`)/@total)*100 as 'Percent' FROM sharktank WHERE 
            season_Number = season AND `Namita_Investment_Amount(in lakhs)` > 0
            group by industry;
        WHEN sharkname = 'Vineeta' THEN
			set @total = (select  sum(`Vineeta_Investment_Amount(in_lakhs)`) from sharktank where Season_Number= season );
            SELECT industry,sum(`Vineeta_Investment_Amount(in_lakhs)`) as 'sum',(sum(`Vineeta_Investment_Amount(in_lakhs)`)/@total)*100 as 'Percent' FROM sharktank 
            WHERE season_Number = season AND `Vineeta_Investment_Amount(in_lakhs)` > 0
            group by industry;
        WHEN sharkname = 'Anupam' THEN
			set @total = (select  sum(`Anupam_Investment_Amount(in_lakhs)`) from sharktank where Season_Number= season );
            SELECT industry,sum(`Anupam_Investment_Amount(in_lakhs)`) as 'sum',(sum(`Anupam_Investment_Amount(in_lakhs)`)/@total)*100 as 'Percent' FROM sharktank 
            WHERE season_Number = season AND `Anupam_Investment_Amount(in_lakhs)` > 0
            group by Industry;
        WHEN sharkname = 'Aman' THEN
			set @total = (select  sum(`Aman_Investment_Amount(in_lakhs)`) from sharktank where Season_Number= season );
            SELECT industry,sum(`Aman_Investment_Amount(in_lakhs)`) as 'sum',(sum(`Aman_Investment_Amount(in_lakhs)`)/@total)*100 as 'Percent'  FROM sharktank 
            WHERE season_Number = season AND `Aman_Investment_Amount(in_lakhs)` > 0
			group by Industry;
        WHEN sharkname = 'Peyush' THEN
			set @total = (select  sum(`Peyush_Investment_Amount((in_lakhs)`) from sharktank where Season_Number= season );
             SELECT industry,sum(`Peyush_Investment_Amount((in_lakhs)`) as 'sum',(sum(`Peyush_Investment_Amount((in_lakhs)`)/@total)*100 as 'Percent'  FROM sharktank 
             WHERE season_Number = season AND `Peyush_Investment_Amount((in_lakhs)` > 0
             group by Industry;
        WHEN sharkname = 'Amit' THEN
			set @total = (select  sum(`Amit_Investment_Amount(in_lakhs)`) from sharktank where Season_Number= season );
              SELECT industry,sum(`Amit_Investment_Amount(in_lakhs)`) as 'sum',(sum(`Amit_Investment_Amount(in_lakhs)`)/@total)*100 as 'Percent'  
              WHERE season_Number = season AND `Amit_Investment_Amount(in_lakhs)` > 0
             group by Industry;
        WHEN sharkname = 'Ashneer' THEN
			set @total = (select  sum(`Ashneer_Investment_Amount`) from sharktank where Season_Number= season );
            SELECT industry,sum(`Ashneer_Investment_Amount`),(sum(`Ashneer_Investment_Amount`)/@total)*100 as 'Percent'  FROM sharktank 
            WHERE season_Number = season AND `Ashneer_Investment_Amount` > 0
             group by Industry;
        ELSE
            SELECT 'Invalid shark name';
    END CASE;
    
END //
DELIMITER ;


drop procedure getseasoninvestment;
call getseasoninvestment(1, 'Ashneer');

select * from sharktank;
   