select * from Employee

select Fname,Lname,Salary,Dno from Employee

select Pname,Plocation,Dnum from Project

select Fullname=Fname+Lname, salary*12*0.10 as "ANNUAL COMM"  from Employee

select SSN,Fname from Employee
where Salary  > 1000

select SSN,Fname from Employee
where (Salary * 12) > 10000

select Fname,Lname,Salary from Employee
where Sex = 'F'

select Dnum,Dname from Departments
where MGRSSN = 968574


select Pnumber,Pname,Plocation from Project
where Dnum = 10