--- checking if there missing months

-- how many years we have
select
	
	count(distinct YEAR(month)) years_count
from ts_monthly_total

-- how many months we have for each year
select
	YEAR(month) year,  
	count(Month(month)) months_count
from ts_monthly_total
group by YEAR(month)



