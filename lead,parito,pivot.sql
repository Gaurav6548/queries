USE school;
INSERT INTO employee_salaries (employee_ID, salary, year) VALUES
(1, 160000, 2021);
select * from employee_salaries;
WITH salary_change AS (
    SELECT
        employee_ID,
        salary,
        year,
        LAG(salary, 1, 0) OVER (PARTITION BY employee_ID ORDER BY year) AS prev_salary
    FROM employee_salaries
),
raises AS (
    SELECT
        employee_ID,
        COUNT(*) AS raise_count
    FROM salary_change
    WHERE salary > prev_salary
    GROUP BY employee_ID
)
SELECT employee_ID
FROM raises
WHERE raise_count >= 3;

WITH salary_change AS (
    SELECT
        employee_ID,
        salary,
        year,
        LAG(salary, 1, 0) OVER (PARTITION BY employee_ID ORDER BY year) AS prev_salary
    FROM employee_salaries
)
select * from salary_change;
with salary_change as(
select employee_ID,salary,year,
lag(salary,1,0) over(partition by employee_ID order by year) as prev_sal
from employee_salaries)
select distinct employee_ID from salary_change where salary>prev_sal ;

with salary_change as(
select employee_ID,salary,year,
lag(salary,1,0) over(partition by employee_ID order by year) as prev_sal
from employee_salaries)
select employee_ID from salary_change where salary>prev_sal and year=2020 ;

with salary_change as (
select employee_ID,salary,year,
lag(salary,1) over(partition by employee_ID order by year) as prev_sal
from employee_salaries),
raise_count as(
select employee_ID,count(*) as raise
from salary_change where salary>prev_sal and prev_sal is not null
group by employee_ID),
consecutive_year as(
select employee_ID,count(*) as year_change
from employee_salaries 
where year between 2018 and 2020
group by employee_ID)
select r.employee_ID from raise_count r join consecutive_year c on r.employee_ID=c.employee_ID
where r.raise=2 and c.year_change=3;

with salary_change as(select employee_ID,salary,year,
lag(salary,1) over(partition by employee_ID order by year) as prev_sal
from employee_salaries),
double_sal as(
select employee_ID from salary_change where
salary=2*prev_sal)
select employee_ID from double_sal;

/* new table */

create table seat(id int ,student varchar(10));
insert into seat values(1,'gaurav'),(2,'nitin'),(3,'ujjwal'),(4,'himanshu'),(5,'pranav');
select * from seat;

select id,
case 
when mod(count(*) over(),2)=1 and id=count(*) over() then student
when mod(id,2)=1 then lead(student) over(order by id)
else lag(student) over(order by id)
end as student
from seat ;

select id,
case when id=1 then (select student from seat where id =2)
when id=2 then (select student from seat where id =1)
when id=3 then (select student from seat where id =4)
when id=4 then (select student from seat where id =3)
else student
end as student
from seat;

 /* new table */
 
 CREATE TABLE sales (
    id INT PRIMARY KEY,
    customerid INT,
    amount DECIMAL(10, 2)
);

INSERT INTO sales (id, customerid, amount) VALUES
(1, 1, 100.00),
(2, 1, 200.00),
(3, 2, 300.00),
(4, 2, 400.00),
(5, 3, 500.00),
(6, 3, 600.00),
(7, 4, 700.00),
(8, 4, 800.00),
(9, 5, 900.00),
(10, 5, 1000.00);
select * from sales;

with cust_sale as(
select customerid,
sum(amount) as amount,
sum(amount)/sum(sum(amount)) over() as cum_per
from sales
group by customerid
),
top_cus as(
select customerid,
amount,cum_per,
sum(cum_per) over(order by amount desc) as cum_sum
from cust_sale)
select * from top_cus where cum_sum<=0.8;

with cust_sale as(
select customerid,
sum(amount) as amount,
sum(amount)/sum(sum(amount)) over() as cum_per
from sales
group by customerid
),
top_cus as(
select customerid,
amount,cum_per,
sum(cum_per) over(order by amount desc) as cum_sum
from cust_sale)
select c.id,p.customerid from top_cus p join sales c on p.customerid=c.customerid where p.cum_sum<=0.8;

/*new table*/
CREATE TABLE monthly_sale (
    product_id INT,
    year INT,
    month INT,
    sales_amount DECIMAL(10, 2)
);
INSERT INTO monthly_sale (product_id, year, month, sales_amount)
VALUES
    (1, 2023, 1, 1000),
    (1, 2023, 2, 1200),
    (1, 2023, 3, 1500),
    (2, 2023, 1, 800),
    (2, 2023, 2, 900),
    (2, 2023, 3, 1000);
select * from monthly_sale;
select product_id,year,
sum(case when month=1 then sales_amount else 0 end) as 'jan',
sum(case when month=2 then sales_amount else 0 end) as 'feb',
sum(case when month=3 then sales_amount else 0 end) as 'mar'
from monthly_sale
group by product_id,year;

create table quarter_wise(id int,month int,sales int);
insert into quarter_wise values(1,1,100),(1,2,200),(1,12,500),(2,5,700),(2,9,400),
(3,2,200),(3,8,900),(3,10,200);
select * from quarter_wise;

select id,
sum(case when month in (1,2,3) then sales else 0 end) as 'quarter_1',
sum(case when month in (4,5,6) then sales else 0 end) as 'quarter_2',
sum(case when month in (7,8,9) then sales else 0 end) as 'quarter_3',
sum(case when month in (10,11,12) then sales else 0 end) as 'quarter_4'
from quarter_wise
group by id;

-- Query to find month with highest sales for each product
SELECT 
    product_id,
    year,
    CASE 
        WHEN GREATEST(january, february, march) = january THEN 'January'
        WHEN GREATEST(january, february, march) = february THEN 'February'
        WHEN GREATEST(january, february, march) = march THEN 'March'
        -- Add more months as needed
    END AS month_with_highest_sales,
    GREATEST(january, february, march) AS highest_sales_amount
FROM (
    SELECT 
        product_id,
        year,
        SUM(CASE WHEN month = 1 THEN sales_amount ELSE 0 END) AS january,
        SUM(CASE WHEN month = 2 THEN sales_amount ELSE 0 END) AS february,
        SUM(CASE WHEN month = 3 THEN sales_amount ELSE 0 END) AS march
        -- Add more months as needed
    FROM 
        monthly_sale
    GROUP BY 
        product_id, year
) AS monthly_sales_pivot;



