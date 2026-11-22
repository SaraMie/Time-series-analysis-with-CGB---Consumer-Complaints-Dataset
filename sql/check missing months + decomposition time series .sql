--- checking if there missing months

-- how many years we have
select
	
	count(distinct YEAR(month))
from ts_monthly_total

-- how many months we have for each year
select
	YEAR(month), 
	count(Month(month))
from ts_monthly_total
group by YEAR(month)



