
-- check duplicates
select Ticket_ID, count(*)
from complaints
group by Ticket_ID
having count(*) > 1;

-- is ticket id null ?
select
	COUNT(Ticket_ID)
from complaints
where Ticket_ID is null

-- samples 
select top 3
	*
from complaints



-- Cleaning steps counts
select
    count(*) as total_rows,
	count(*) - count(Date_of_Issue) as null_date, 
    count(*) - count(Time_of_Issue) as null_time,
    sum(case when TRY_CONVERT(smalldatetime, Date_of_Issue) is null then 1 else 0 end) as invalid_dates,
    sum(case when TRY_CONVERT(time, Time_of_Issue) is null then 1 else 0 end) as invalid_time,
    count(*) - count(issue) as null_val_issue,
    sum(case when issue = 'Availability (including rural call completion)' then 1 else 0 end) 
    + sum(case when issue = 'Interference (including signal jammers)' then 1 else 0 end)
    as merged_issues,
    
from complaints;

select
    max(len(trim(Time_of_Issue)))
from complaints


ALTER TABLE complaints ALTER COLUMN time_of_issue nvarchar(280) NULL; -- to support the regexp_replace cause it doesn't support NVARCHAR(max)/VARCHAR(max) inputs


--------------------- LAB ----------------------------

select
    Issue
from complaints
where issue=''
group by Issue
