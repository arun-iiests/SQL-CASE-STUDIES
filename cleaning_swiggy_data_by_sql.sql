use campusx;

-- Count the number of null values in the columns
		select 
			sum(case when hotel_name=''  then 1 else 0  end) as hotel_name ,
			sum(case when rating=''  then 1 else 0  end) as rating ,
			sum(case when time_minutes=''  then 1 else 0  end) as time_minutes ,
			sum(case when food_type=''  then 1 else 0  end) as food_type ,
			sum(case when location=''  then 1 else 0  end) as location ,
			sum(case when offer_above=''  then 1 else 0  end) as offer_above ,
			sum(case when offer_percentage=''  then 1 else 0  end) as offer_percentage 
			from swiggy;

-- counting the null values by dynamic method
			-- select * from information_schema.columns where table_name ='swiggy' and table_schema='campusx';
			select column_name from information_schema.columns where table_name ='swiggy' and table_schema='campusx';
			

		delimiter //
		create procedure  count_blank_rows()
		begin
				select group_concat(
					   concat('sum(case when`', column_name, '`='''' Then 1 else 0 end) as `', column_name ,'`')
					) into @sql 
					from information_schema.columns  where table_name= 'swiggy';

				set @sql = concat('select ', @sql,' from swiggy');


				prepare smt from  @sql;
				execute  smt ;
				deallocate  prepare smt;
			end
		//
		delimiter ;

		call count_blank_rows();

		-- Shifting the time_minutes values from the rating values 
		create table clean as
		select * from swiggy where rating >5;

		select * from clean;


		update swiggy as s
		inner join clean as c on s.hotel_name=c.hotel_name
		set s.time_minutes=c.rating;

		select * from swiggy ;  -- "time_minutes column is cleaned"

-- Cleaning the rating column
		select location,round(avg(rating),2) from swiggy
		where rating <=5
		group by location;

		update swiggy as s 
		join 
		(
			select location,round(avg(rating),2) as 'avg_rating' from swiggy
			where rating <=5
			group by location
		) as r on s.location=r.location
		set s.rating=r.avg_rating
		where s.rating >5;

		select * from swiggy;  
      
        select round(avg(rating),2) into @oa from swiggy where rating <=5 ;
        select @oa;
		update swiggy  set rating=@oa where rating >5;
	
		select * from swiggy;   -- "rating" column is  also cleaned

-- Let's now clean the "location" column

		select distinct(location) from swiggy where location like '%kandivali%';

		update swiggy 
		set location= 'Kandivali East'
		where location like '%east%';

		update swiggy 
		set location= 'Kandivali West'
		where location like '%West%';

		update swiggy 
		set location= 'Kandivali East'
		where location like '%e%';

		update swiggy 
		set location= 'Kandivali West'
		where location like '%wt%'; -- So "location" column is also cleaned

-- Let's now clean the "offer_percentage" column

		update swiggy
		set offer_percentage =0
		where  offer_above='';

		select * from swiggy;  -- Its also done
        
        
-- Let's now clean the "food_type" column

		select substring_index('South Indian, Chinese, North Indian, Fast Food, Indian, Beverages, Street Food',',',2);

		select * from 
		(
		select *, substring_index( substring_index(food_type ,',',numbers.n),',', -1) as 'food'
		from  swiggy 
			join
			(
				select 1+a.N + b.N*10 as n from 
				(
					(
					SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 
					UNION ALL SELECT 8 UNION ALL SELECT 9) a
					cross join 
					(
					SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 
					UNION ALL SELECT 8 UNION ALL SELECT 9)b
				)
			)  as numbers 
			on  char_length(food_type)  - char_length(replace(food_type ,',','')) >= numbers.n-1  
		)a;
        
        -- It's cleaned now;

