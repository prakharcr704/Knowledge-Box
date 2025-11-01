--SQL INTERVIEW QUESTIONS - ankit bansal - https://www.youtube.com/watch?v=Iv9qBz-cyVA&t=353s

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

--4. employees who are not present in dept.
     --given that there are 2 tables - emp & dept

select emp_id from employee where emp_id not in ( select dept_id from dept)





