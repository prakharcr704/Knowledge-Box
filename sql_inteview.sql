--SQL INTERVIEW QUESTIONS

--1. How to find duplicates in a given table?
select emp_id, count(1) from emp group by emp_id having count(1)>1

--2. How to delete duplicates?
with cte as ( select *, row_number() over(partition by emp_id order by emp_id) as rn from emp1)
delete from cte where rn > 1

--3 Difference between union and union all
  -- union all 
    -- will result in having all the row from both table.
    -- eg table 1 (9 rows) + table 2 (8 rows) = 17 rows ( will also have duplicate row from table 1 )
  -- union
    -- will remove duplicates 

select manager_id from emp
union
select manager_id from emp1
--above query will give only unique manager ids.



