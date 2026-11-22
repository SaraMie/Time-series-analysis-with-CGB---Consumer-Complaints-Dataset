
drop table if exists indexing_ts_yearly_issue;
-- time series years per issues
with ts_yearly_issue as (
	select
		issue_cleaned
		, YEAR(month) year
		, sum(total) year_total
	from ts_monthly_issue_total
	where YEAR(month) >=2019 -- setting base date to 2019
	group by YEAR(month), issue_cleaned
	
)
-- indexing
select 
	year_total
	, issue_cleaned
	, year
	, cast (round(
		year_total*100.0	/	
		nullif( -- result is null if base value is 0
		-- this is the value of the base month for each issue where here the base month is from first date
			FIRST_VALUE(year_total) over(partition by issue_cleaned order by year ) -- this is the base value
			, 0)
		, 2) as DECIMAL(10, 2) ) as index_100
into indexing_ts_yearly_issue
from ts_yearly_issue
order by year
