

drop table if exists complaints_clean;

select
	Ticket_ID
	, Date_of_Issue
    , case when Date_of_Issue is null then 1 else 0 end as is_date_missing -- flag column
    , case 
        when issue is null then 'Unknown'
        when issue like '%Availability%' then 'Availability'  -- merging Availability into one categ
        when issue like '%Interference%' then 'Interference'  -- merging Interference into one categ
        else issue
        end as issue_cleaned
    -- fixing the values of Time_of_Issue
	, TRY_CONVERT(time, 
        LOWER(
          REGEXP_REPLACE(
            Time_of_Issue,
            '^\s*([0-9]{1,2}):([0-9]{1,2})\s*([ap]).*[^a-z0-9]*m.*$', 
            '\1:\2\3m',
            1, 1, 'i'
          )
        )  ) as time_of_issue_cleaned
    , case when Time_of_Issue is null then 1 else 0 end as is_time_missing -- flag column
INTO complaints_clean
from complaints
where 
    Date_of_Issue is null -- keeping the nulls
    or YEAR(date_of_issue) between year('1/1/2015') and year('1/1/2026') -- exclude all dates out this period (badly they are impossible dates)




