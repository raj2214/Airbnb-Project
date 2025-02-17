/* 1. Checking number & percentage of total Airbnb's preferred host having response rate over 90% and 
acceptance rate is over 90% grouped by neighbourhood*/

WITH cte2_count_preferred_host AS (
    SELECT neighbourhood_cleansed AS locations, 
           COUNT(id) AS total_preferred_host
    FROM airbnb.primary_sheet_cleaned
    WHERE host_response_rate > 0.90 AND host_acceptance_rate > 0.90
    GROUP BY neighbourhood_cleansed
)
SELECT locations, 
       total_preferred_host AS total_good_host, 
       ROUND(100 * total_preferred_host / (SELECT COUNT(id) FROM airbnb.primary_sheet_cleaned), 2) AS good_host_percent
FROM cte2_count_preferred_host
ORDER BY good_host_percent DESC;



/* 2. Checking Number of Traveller friendly properties having flexible cancellation policy, is instantly bookable, 
ratings 4 to 5 star (review_scores_rating > 85.0), has exact location available and is available at the moment */
 
 with cte3_joined_table as (
	select * from primary_sheet_cleaned as prime
	join airbnb.cleaned_tertiary tert 
	on prime.id = tert.listing_id
 
 )
 select property_type, count(id) as total_traveller_friendly_properties from cte3_joined_table 
where instant_bookable = 1 and review_scores_rating > 85.0 and available = 'True'
group by property_type;
 


-- 3. List of top 20 locations with most number of properties available with cheapest prices and decent ratings

select neighbourhood_cleansed as cheapest_locations, count(id) as listed_properties, 
round(avg(price), 2) as average_price from airbnb.primary_sheet_cleaned where review_scores_rating > 80.0
group by neighbourhood_cleansed order by average_price asc limit 20;

 
 
 -- 4. List of top ten expensive neighbourhood with number of already listed properties, best for hosts from the point of investment
 
 select neighbourhood_cleansed as top_locations, count(id) as total_listed_properties, round(avg(price), 2)
 as per_day_revenue from airbnb.primary_sheet_cleaned group by neighbourhood_cleansed 
 order by per_day_revenue desc limit 10;






