--1.Display (Using Union Function)
	--a.The name and the gender of the dependence that's gender is Female and depending on Female Employee.
	--b.And the male dependence that depends on Male Employee.
select d.Dependent_name, d.Sex from Dependent d join Employee e
on d.ESSN = e.SSN
where d.sex = 'F' and e.Sex ='F'
union all
select d.Dependent_name, d.Sex from Dependent d join Employee e
on d.ESSN = e.SSN
where d.sex = 'M' and e.Sex ='M'

--2.For each project, list the project name and the total hours per week (for all employees) spent on that project.
select p.Pname, sum(w.Hours)/4 as 'Total hours per week' from Project p join Works_for w
on p.Pnumber = w.Pno
group by p.Pname

--3.Display the data of the department which has the smallest employee ID over all employees' ID.
select * from Departments d ,Employee e
where d.Dnum=e.Dno and e.SSN =(select min(SSN) from Employee) 

--4.For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select d.Dname , max(e.salary)as 'max salary',min(e.salary)as 'min salary',avg(e.salary)as 'avg salary' from Departments d , Employee e
where d.Dnum = e.dno
group by Dname

--5.List the full name of all managers who have no dependents.
select e.Fname+ ' '+e.Lname as fullname from Employee e join Departments d 
on e.SSN = d.MGRSSN
except
select e.Fname+ ' '+e.Lname as fullname from Dependent de ,Employee e
where de.ESSN = e.SSN

--6.For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select Dno,Dname, count(SSN) as empCount from Employee ,Departments
where Dno = Dnum
group by Dno, Dname
having avg(Salary)< (select avg(Salary) from Employee)

--7.Retrieve a list of employee’s names and the projects names they are working on ordered by department number 
--and within each department, ordered alphabetically by last name, first name.
select Fname+ ' '+Lname as fullname ,Pname from Employee join Works_for
on ESSn=SSN
join Project
on Pnumber = Pno
order by Dnum ,fullname

--8.Try to get the max 2 salaries using sub query
select salary from Employee							--SELECT MAX(Salary) AS Salary
where salary in (select max(salary) from Employee	--FROM Employee
union												--WHERE Salary < (SELECT MAX(Salary) FROM Employee)
select max(salary) from Employee					--UNION
where salary < (select max(salary) from Employee )) --SELECT MAX(Salary) AS Salary
order by Salary desc								--FROM Employee;

--9.Get the full name of employees that is similar to any dependent name
select Fname+ ' '+Lname as fullname from Employee
intersect
select Dependent_name from Dependent

--10.Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
SELECT ssn, fname FROM Employee
WHERE EXISTS (
    SELECT 1
    FROM Dependent
    WHERE ESSN = SSN
);

--11.In the department table insert new department called "DEPT IT”, with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
insert into Departments values('DEPT IT',100,112233,'11/1/2006')

--12.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
	--a.First try to update her record in the department table
	update Departments set MGRSSN = 968574
	where Dnum =100

	--b.Update your record to be department 20 manager.
	insert into Employee
	values ('Mohsen', 'Tayseer', 102672, '11-04-1998', 'Portfouad,Portsaid' ,'m', 5000, 968574, 20)
	update Departments set MGRSSN = 102672 where dnum = 20 

	--c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
	insert into Employee values ('member', 'team', 102660, '05-08-2000', 'portsaid', 'm', 3000, 968574, 20)
	update Employee set Superssn = 102672 where SSN = 102660

--13.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case you know that you will be temporarily in his position.
	--Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).
delete from Dependent where ESSN = 223344
update Departments set MGRSSN = 102672 where MGRSSN = 223344
delete from Works_for where essn = 223344

update Employee set Superssn = 102672 where Superssn = 223344

delete from Employee where ssn = 223344

--14.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
update Employee set Salary = salary + (Salary*0.3) 
where ssn in (select ssn from Employee e inner join Works_for w
				on e.SSN = w.ESSn inner join Project p 
				on w.Pno = p.Pnumber where p.Pname = 'Al Rabwah')