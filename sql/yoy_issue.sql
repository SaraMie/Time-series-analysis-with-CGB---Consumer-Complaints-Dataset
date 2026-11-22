-- YoY calculation
with ts_yearly_issue as (
	select
		issue_cleaned
		, YEAR(month) year
		, sum(total) year_total
	from ts_monthly_issue_total
	group by YEAR(month), issue_cleaned
)

SELECT
    issue_cleaned,
    year,
    year_total,
    CAST((year_total * 1.0
          / NULLIF(LAG(year_total) OVER (PARTITION BY issue_cleaned ORDER BY year), 0)
          - 1) * 100 AS DECIMAL(10, 1)) AS yoy_pct
FROM ts_yearly_issue
ORDER BY issue_cleaned, year;


