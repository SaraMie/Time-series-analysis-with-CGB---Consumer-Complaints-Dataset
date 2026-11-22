--- creating time-series tables

-- time-series of yearly totals
drop table if exists ts_yearly_total;
select
	YEAR(Date_of_Issue) as year,
	COUNT(Ticket_ID) as total,
	rank() over (order by COUNT(Ticket_ID)) as rank-- from less to most
into ts_yearly_total
from complaints_clean
where
	Date_of_Issue is not null
group by YEAR(Date_of_Issue)
order by YEAR(Date_of_Issue)

-- time-series of monthly totals
drop table if exists ts_monthly_total;
select
	cast(datetrunc(month, Date_of_Issue) as date) as month, -- use the datetrunk for get month with year
	COUNT(Ticket_ID) as total,
	rank() over (order by COUNT(Ticket_ID)) as rank-- from less to most
into ts_monthly_total
from complaints_clean
where
	Date_of_Issue is not null
group by DATETRUNC(MONTH, Date_of_Issue)
order by DATETRUNC(MONTH, Date_of_Issue)

-- time-series of monthly totals
drop table if exists ts_monthly_issue_total;
select
	cast(datetrunc(month, Date_of_Issue) as date) as month, 
	issue_cleaned,
	COUNT(issue_cleaned) as total,
	rank() over (partition by DATETRUNC(MONTH, Date_of_Issue) order by COUNT(issue_cleaned)) as rank-- rank of issue in a month form less to most
into ts_monthly_issue_total
from complaints_clean
where
	Date_of_Issue is not null
group by DATETRUNC(MONTH, Date_of_Issue), issue_cleaned
order by DATETRUNC(MONTH, Date_of_Issue)


