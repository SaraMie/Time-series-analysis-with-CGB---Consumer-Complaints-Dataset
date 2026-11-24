
-- calculate CAGR
-- = [ (endVal/startVal)^(1/nYears) ] - 1
with bounds as (
	select
		MAX(year) as end_year
		, MIN(year) as start_year
		, MAX(year) - MIN(year) as n_years
		
	from ts_yearly_total
	
) ,
calc as (
	select
	cast( 
		100.0 * (
			POWER(
				CAST((select total from ts_yearly_total where year = end_year) as float)
				/ (select total from ts_yearly_total where year = start_year)
				,1.0 / (end_year - start_year)
			) - 1 )
		as decimal(10,2)
	) as cagr_pct
	from bounds

)

select cagr_pct from calc

