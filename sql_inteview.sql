--SQL INTERVIEW QUESTIONS

--1. How to find duplicates in a given table?
select emp_id, count(1) from emp group by emp_id having count(1)>1
