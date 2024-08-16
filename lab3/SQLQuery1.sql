--1
select Dnum , Dname , MGRSSN , Fname
from Departments, Employee 
where MGRSSN = Employee.SSN

--2
select Dname , Pname
from Departments D, Project P
where P.Dnum = D.Dnum

--3
select d.* , E.Fname from Dependent D left outer join Employee E
on D.ESSN = E.SSN

--4
select Plocation,Pnumber,Pname from Project
where City in ('cairo','alex')

--5
select P.* from Project P
where Pname like 'a%'

--6
select fullname = Fname + Lname from Employee
where Dno = 30 and Salary between 1000 and 2000

--7
select full_name = Fname +' '+  Lname from Employee E join Works_for w 
on Dno = 10 and  w.Hours / 4 >= 10
join Project p 
on P.Pname = 'AL Rabwah' 

--8
select full_name = S.Fname +' '+  S.Lname from Employee E, Employee S
where E.SSN =S.Superssn and E.Fname = 'kamel'

--9
select efull_name = e.Fname +' '+  e.Lname from Employee e 
join Works_for w
on e.SSN = w.ESSn
join Project p 
on w.Pno = p.Pnumber
order by pname

--10
select p.Pnumber ,d.Dname , e.lname ,e.Address,e.Bdate from Departments d join Project p
on p.Dnum = d.Dnum
join Employee e
on d.MGRSSN = e.SSN and p.City = 'cairo'

--11
select e.*
from Employee e left outer join Departments d
on d.MGRSSN = e.SSN

--12
select e.*, d.* 
from Employee e left join Dependent d
on e.SSN = d.ESSN;

--13
insert into Employee (Dno,SSN,Superssn,Salary)
Values(30,102672,112233,3000)

--14
insert into Employee (Dno,SSN)
values (30, 102660)

--15
update Employee
set Salary += Salary *0.2
where SSN = 102672

--select salary from Employee where SSN = 102672