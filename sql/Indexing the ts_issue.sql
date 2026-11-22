
drop table if exists indexing_ts_issue;
-- Indexing

select 
	total
	, issue_cleaned
	, month
	, cast (round(
		total*100.0	/	
		nullif( -- result is null if base value is 0
		-- this is the value of the base month for each issue where here the base month is from first date
			FIRST_VALUE(total) over(partition by issue_cleaned order by month ) -- this is the base value
			, 0)
		, 2) as DECIMAL(10, 2) ) as index_100
into indexing_ts_issue
from ts_monthly_issue_total
order by month
