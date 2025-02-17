-- 	Queries for displaying the table data
select * from airbnb.primary_sheet_cleaned;
SELECT * FROM airbnb.cleaned_tertiary;


-- Queries for checking the data type of each columns
SHOW COLUMNS FROM airbnb.cleaned_tertiary;
SHOW COLUMNS FROM airbnb.primary_sheet_cleaned;


-- Removing unncessary columns from the tables
Alter table airbnb.primary_sheet_cleaned
drop square_feet;
Alter table airbnb.cleaned_tertiary
drop price;


-- Queris for checking the number of rows in each table to ensure that the data has been proeprly uploaded
select distinct count(id) from airbnb.primary_sheet_cleaned;
select distinct count(listing_id) from airbnb.cleaned_tertiary;


-- Joining Both Tables
select * from primary_sheet_cleaned as prime
join airbnb.cleaned_tertiary tert 
on prime.id = tert.listing_id;


-- Checking the Total Numbers of Rows in resultant table formed after joining
select count(*) as total_records_combined from primary_sheet_cleaned as prime
join airbnb.cleaned_tertiary tert 
on prime.id = tert.listing_id;


-- Checking for duplicate rows
with cte1_duplicate_rows as(
	select row_number() over(partition by id order by id, host_id) as row_num from airbnb.primary_sheet_cleaned
	) 
select * from cte1_duplicate_rows where row_num >1;
-- No Duplicate Values found, We are Good to Go!


-- Checking for Null values for ids in the resultant table formed after joining
select * from primary_sheet_cleaned as prime
join airbnb.cleaned_tertiary tert 
on prime.id = tert.listing_id
where prime.id is null;


-- setting Null values for multiple columns so that its data type can be converted to INT from Text
UPDATE airbnb.primary_sheet_cleaned
SET host_response_rate = NULL
WHERE host_response_rate = '';

UPDATE airbnb.primary_sheet_cleaned
SET host_acceptance_rate = NULL
WHERE host_acceptance_rate = '';


-- Checking the status of previous query if there are any null values
select * from airbnb.primary_sheet_cleaned
where host_response_rate is null;

select * from airbnb.primary_sheet_cleaned
where host_acceptance_rate is null;


-- Altering datatype of few columns 
ALTER TABLE airbnb.primary_sheet_cleaned
MODIFY COLUMN host_response_rate INT,
MODIFY COLUMN host_acceptance_rate INT;

-- modifying data type of review_scores_rating
UPDATE airbnb.primary_sheet_cleaned
SET review_scores_rating = NULL
WHERE review_scores_rating = '';

ALTER TABLE airbnb.primary_sheet_cleaned
MODIFY COLUMN review_scores_rating FLOAT;
