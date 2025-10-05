--SQL INTERVIEW QUESTIONS

--1. How to find duplicates in a given table?
select emp_id, count(1) from emp group by emp_id having count(1)>1

--2. How to delete duplicates?
with cte as ( select *, row_number() over(partition by emp_id order by emp_id) as rn from emp1)
delete from cte where rn > 1
