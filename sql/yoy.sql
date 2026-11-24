
-- adding yoy as new column
ALTER TABLE ts_yearly_total ADD yoy_pct DECIMAL(10, 2) null;
GO

-- we need cte to fill the column, so we can 'set' column value one by one

-- calc yoy
WITH calc AS (
    SELECT
        year,
        CAST(
            (total * 1.0 / NULLIF(LAG(total) OVER (ORDER BY year), 0) - 1) * 100
            AS DECIMAL(10, 2)
        ) AS new_yoy
    FROM ts_yearly_total
)

-- updating the new column yoy_pct of ts_yearly_total with new_yoy of calc 
update t
set t.yoy_pct = calc.new_yoy
from ts_yearly_total as t
join calc on t.year = calc.year

