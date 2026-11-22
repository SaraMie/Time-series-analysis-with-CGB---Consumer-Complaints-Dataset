-- extract the time-series

-- count of complaints per month
select
	DATETRUNC(MONTH, Date_of_Issue),
	COUNT(Ticket_ID)
from complaints_clean
group by DATETRUNC(MONTH, Date_of_Issue)