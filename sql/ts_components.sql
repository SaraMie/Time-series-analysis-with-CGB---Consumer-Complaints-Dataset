drop table if exists ts_components;

with monthly_avg as (
	select
		month(month) m
		, avg(detrended_data) avg_m
	from detrended_data
	group by month(month)
)
, seasonality_raw as (
select
	m
	,avg_m - avg(avg_m) over()  as mean_centered
from monthly_avg
)

select 
	data.month
	,data.total
	,data.trend
	, s.mean_centered as seasonally_index
	,data.total - s.mean_centered as seasonally_adjusted
	, data.total - data.trend - s.mean_centered as residual
into ts_components
from detrended_data as data
join seasonality_raw as s on s.m = month(data.month)