DROP TABLE IF EXISTS detrended_data;

WITH month_12_ma AS (
    SELECT month,
           total,
           -- Trailing 12-month average over rows i-11 to i.
           -- NULL for the first 11 rows (no full window yet).
           CASE WHEN ROW_NUMBER() OVER (ORDER BY month) < 12 THEN NULL
                ELSE AVG(1.0 * total) OVER (ORDER BY month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)
           END AS [12-MA]
    FROM ts_monthly_total
),
trend_raw AS (
    SELECT month,
           total,
           [12-MA],
           -- Averaging with the previous row's 12-MA gives the 2x12-MA,
           -- covering rows i-12 to i (half weight on the two end months).
           ([12-MA] + LAG([12-MA]) OVER (ORDER BY month)) / 2 AS trend
    FROM month_12_ma
),
trend_centered AS (
    SELECT month,
           total,
           -- trend_raw describes the middle of its window, 6 months earlier.
           -- LEAD(trend, 6) moves it 6 rows forward in time onto that month,
           -- so the trend is centered. Without it, every value would sit 6 months late.
           -- The first 6 and last 6 rows are NULL (no full window available).
           LEAD(trend, 6) OVER (ORDER BY month) AS trend
    FROM trend_raw
)
SELECT month,
       total,
       trend,
       total - trend AS detrended_data
INTO detrended_data
FROM trend_centered;