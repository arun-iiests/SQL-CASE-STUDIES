use campusx;

-- 	1. Find the month with most number of flights

		select monthname(date_of_journey) as month_name, count(*) as count from flights 
		group by monthname(date_of_journey) 
		order by count desc;


-- 	2. Which week day has most costly flights

		select dayname(date_of_journey) as week_day, round(avg(price),2) as avg_price from flights 
		group by dayname(date_of_journey) 
		order by avg_price desc
        limit 1;
        
		
 -- 3. Find number of indigo flights every month
 
		select monthname(date_of_journey) as month_name, count(*) as no_of_indigo_per_month from 
		flights where airline='indigo' 
		group by monthname(date_of_journey)
		order by  no_of_indigo_per_month asc;
        
        
-- 	4. Find list of all flights that depart between 10AM and 2PM from Banglore to Delhi

		select * from flights where Source='Banglore' and Destination='Delhi' 
		and dep_time > '10:00:00' and dep_time < '14:00:00';
	
    
-- 5. Find the number of flights departing on weekends from Bangalore

		select count(*) from flights where source='Banglore'
		and (dayname(date_of_journey)='Saturday' or dayname(date_of_journey)='Sunday');
					-- OR
		SELECT COUNT(*) FROM flights
		WHERE source = 'banglore' AND
		DAYNAME(date_of_journey) IN ('saturday','sunday');
        
        
-- 6. Calculate the arrival time for all flights by adding the duration to the departure time.

		-- firstly create the standard and single departure datetime by concanating "date_of_journey" and "dep_time"
		alter table flights add column departure datetime;

		update flights 
		set departure =str_to_date(concat(date_of_journey,' ' , dep_time),'%Y-%m-%d %H:%i');

		ALTER TABLE flights
		ADD COLUMN duration_mins INTEGER,
		ADD COLUMN arrival DATETIME;

		UPDATE flights
		SET duration_mins= ( replace(substring_index(trim(duration),' ',1),'h','') *60 + 
																	
					case when substring_index(trim(duration),' ',1)=substring_index(trim(duration),' ',-1) then 0
					else replace(substring_index(trim(duration),' ',-1),'m','')
					END) ;


		select *, 
			case when substring_index(trim(duration),' ',1)=substring_index(trim(duration),' ',-1) then 0
			else replace(substring_index(trim(duration),' ',-1),'m','')
			end as mins
		 from flights ;

		update flights
		set arrival= adddate(departure, interval duration_mins MINUTE);

		select TIME(arrival) from flights;


-- 	7. Calculate the arrival date for all the flights

		select date(arrival) from flights;


-- 8. Find the number of flights which travel on multiple dates.

		select count(*) from flights where date(departure) != date(arrival);

-- 9. Calculate the average duration of flights between all city pairs. The answer should In xh ym format

		select source,destination , time_format(sec_to_time(avg(duration_mins)*60),'%kh %im') as avg_duartion 
		from flights group by source,destination;
        
        
-- 10. Find all flights which departed before midnight but arrived at their destination after midnight having only 0 stops.

		select count(*) from flights where total_stops='non-stop' and date(departure) != date(arrival);
        
        
-- 11. Find quarter wise number of flights for each airline

		select airline, quarter(departure), count(*) from flights group by airline, quarter(departure);
        
-- 12. Average time duration for flights that have 1 stop vs more than 1 stops

		WITH temp_table AS (SELECT *,
		CASE 
			WHEN total_stops = 'non-stop' THEN 'non-stop'
			ELSE 'with stop'
		END AS 'temp'
		FROM flights)

		SELECT temp,
		TIME_FORMAT(SEC_TO_TIME(AVG(duration_mins)*60),'%kh %im') AS 'avg_duration',
		AVG(price) AS 'avg_price'
		FROM temp_table
		GROUP BY temp;


-- 	13. Find all Air India flights in a given date range originating from Delhi 1st Mar 2019 to 10th Mar 2019 

		select * from flights where airline= 'Air India' and source='Delhi' 
		and (DATE(departure) BETWEEN '2019-03-01' AND '2019-03-10');

-- 14. Find the longest flight of each airline

		select airline, date_format(sec_to_time((avg(duration_mins)*60)),'%kh %im')as max_duration from flights 
		group by airline
		ORDER BY MAX(duration_mins) DESC;

-- 16. Find all the pair of cities having average time duration > 3 hours

		select source, destination, avg(duration_mins) as avg_duration from flights 
		group by source, destination having avg_duration > 180;
        

-- 	17. Make a weekday vs time grid showing frequency of flights from Banglore and Delhi

		select dayname(departure),
		SUM(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM - 6AM',
		SUM(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM - 12PM',
		SUM(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM - 6PM',
		SUM(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM - 12PM'
		from flights where source='Banglore' and Destination in ('delhi','new delhi')
		group by dayname(departure)
        ORDER BY DAYOFWEEK(departure) ASC;


-- 	18. Make a weekday vs time grid showing avg flight price from Banglore and Delhi

		select dayname(departure),
		avg(case when hour(departure) between 0 and 5 then price ELSE NULL end)  AS '12AM - 6AM',
		avg(case when hour(departure) between 6 and 11 then price  ELSE NULL end)  AS '6AM - 12PM',
		avg(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN price ELSE NULL END) AS '12PM - 6PM',
		avg(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN price ELSE NULL END) AS '6PM - 12PM'
		from flights where source='Banglore' and Destination in ('delhi','new delhi')
		group by dayname(departure)
        ORDER BY DAYOFWEEK(departure) ASC;

select * from flights;

