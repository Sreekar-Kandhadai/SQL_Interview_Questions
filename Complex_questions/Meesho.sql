-- A database contains daily Covid cases reported for 2021. 
-- Calculate the percentage increase in covid cases each month versus cumulative cases as of the prior month.
-- Return the month number, and the percentage increase rounded to one decimal. Order the result by the month.

CREATE TABLE daily_cases (
    record_date VARCHAR(10),
    case_count INT
);
-- INSERT INTO daily_cases (record_date, case_count) VALUES
-- ('2021-01-01', 100),
-- ('2021-01-02', 150),
-- ('2021-01-03', 120),
-- ('2021-01-04', 130),
-- ('2021-01-05', 160),
-- ('2021-02-01', 140),
-- ('2021-02-02', 180),
-- ('2021-02-03', 200),
-- ('2021-02-04', 170),
-- ('2021-02-05', 190);
INSERT INTO daily_cases (record_date, case_count) VALUES
('2021-01-01', 35984),
('2021-01-16', 44614),
('2021-01-31', 45285),
('2021-02-15', 66089),
('2021-03-02', 171438),
('2021-03-17', 113594),
('2021-04-01', 175257),
('2021-04-16', 117325),
('2021-05-01', 156273),
('2021-05-16', 127783),
('2021-05-31', 139975),
('2021-06-15', 56670),
('2021-06-30', 63238),
('2021-07-15', 50248),
('2021-07-30', 25869),
('2021-08-14', 12021),
('2021-08-29', 42355),
('2021-09-13', 31289),
('2021-09-28', 81926),
('2021-10-13', 14629),
('2021-10-28', 12281),
('2021-11-12', 91223),
('2021-11-27', 10706),
('2021-12-12', 64819),
('2021-12-27', 53434);

---------------------------------------------------------------
Solution 1: Using Self-Join
---------------------------------------------------------------
with cte as (
select month(record_date) as record_month ,sum(case_count) as total_cases from 
daily_cases  group by month(record_date)
),
cte1 as(
select  a.record_month,a.total_cases,sum(b.total_cases) as prev_month_cases from 
cte a left join cte b on 
a.record_month > b.record_month group by a.record_month,a.total_cases
)

select record_month, total_cases as monthly_cases,
round((total_cases*1.0/prev_month_cases)*100.0,1) as percentage
from cte1 order by record_month;

---------------------------------------------------------------
Solution 2: Using Window Function
---------------------------------------------------------------

with cte as (
select month(record_date) as record_month ,sum(case_count) as total_cases from 
daily_cases  group by month(record_date)
),

cte1 as(
select  record_month,total_cases,sum(total_cases) 
over(order by record_month rows between unbounded preceding and 1 preceding) as 
prev_month_cases from 
cte
)


select record_month, total_cases as monthly_cases,
round((total_cases*1.0/prev_month_cases)*100.0,1) as percentage
from cte1 order by record_month;

