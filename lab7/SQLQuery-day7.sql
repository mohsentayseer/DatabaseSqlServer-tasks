--1.	 Create a view that displays student full name, course name if the student has a grade more than 50. 
alter view vNameCrsStudent(student_full_name, course_name )
as
select St_Fname +' '+St_Lname Full_Name ,c.Crs_Name ,sc.grade from student s 
Join Stud_Course sc On s.St_Id = sc.St_Id
join Course c on c.Crs_Id = sc.Crs_Id
where sc.grade>50
--calling
select * from vNameCrsStudent

--======================================================================================================
--2.	 Create an Encrypted view that displays manager names and the topics they teach.
alter view vNameTopManager(Manager_Name, Topic_Name)
with encryption
as
select ins_name, Top_name from Department d
join Instructor i on i.Ins_Id = d.Dept_Manager
Join ins_Course ic On i.Ins_Id = ic.Ins_Id
join Course c on c.Crs_Id = ic.Crs_Id
join Topic t on t.Top_Id = c.Top_Id
--calling
sp_helptext 'vNameTopManager'
select * from vNameTopManager

--======================================================================================================
--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
create view vInstrDept(Instr_Name, Dept_Name)
as
select i.ins_name, d.dept_name
from instructor i
join department d on i.dept_id = d.dept_id
where d.dept_name in ('SD', 'Java');

-- Calling
select * from vInstrDept;
--======================================================================================================
--4.	 Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
create view v1
as
select * from student
where st_address in ('alex', 'cairo')
with check option;
-- Calling
select * from v1;
--checking
Update V1 set st_address='tanta'
Where st_address='alex';
--======================================================================================================
--5.	Create a view that will display the project name and the number of employees work on it. “Use Company DB”
use Company_SD
create view vProjectNOEmployees (Project, No_Employees)
as
	select p.Pname, count(w.ESSn)
	from Project p inner join Works_for w
	on p.Pnumber = w.Pno
	group by p.Pname
--calling
select * from vProjectNOEmployees

--======================================================================================================
--6.	Create the following schema and transfer the following tables to it 
--a.	Company Schema 
--	i.	Department table (Programmatically)
--	ii.	Project table (by wizard)
--b.	Human Resource Schema
--	i.	  Employee table (Programmatically)
create schema Company
alter schema Company transfer Departments

create schema Human_Resource
alter schema Human_Resource transfer Employee
--======================================================================================================
--7.	Create index on column (manager_Hiredate) that allow u to cluster the data in table Department. What will happen?  -> Use ITI DB
create clustered index i1
on department(manager_hiredate);
-- can't do another clusterd index in same table

--======================================================================================================
--8.	Create index that allow u to enter unique ages in student table. What will happen?  -> Use ITI DB
create unique index i2
on student(St_Age);
--can't do this because there are duplicated values in ages so age not a unique value to create unique index

--======================================================================================================
--9.	Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB
declare c1 cursor
for select salary from Employee
where salary is not null
for update
declare @sal int
open c1
fetch c1 into @sal
while @@FETCH_STATUS=0
	begin
		if @sal<3000
			update Employee
				set salary=@sal*1.1
			where current of c1
		else if @sal>=3000
			update Employee
				set Salary=@sal*1.2
			where current of c1
			fetch c1 into @sal
	end
close c1
deallocate c1

--======================================================================================================
--10.	Display Department name with its manager name using cursor. Use ITI DB
declare c1 cursor
for select d.Dept_Name ,i.Ins_Name Manger_Name from Department d
join Instructor i on i.Ins_Id=d.Dept_Manager
for read only  
declare @deptname varchar(20),@mngname varchar(20)
open c1
fetch c1 into @deptname,@mngname
while @@FETCH_STATUS=0
	begin
		select @deptname,@mngname
		fetch c1 into @deptname,@mngname
	end
close c1
deallocate c1
--======================================================================================================
--11.	Try to display all instructor names in one cell separated by comma. Using Cursor . Use ITI DB
declare c1 cursor
for select distinct(Ins_Name) from Instructor where Ins_Name is not null
for read only
declare @name varchar(10),@all_names varchar(200)=''
open c1
fetch c1 into @name
while @@FETCH_STATUS=0
	begin
		set @all_names=CONCAT(@all_names,',',@name)
		fetch c1 into @name
	end
select @all_names
close c1
deallocate c1

--======================================================================================================
--12.	Try to generate script from DB ITI that describes all tables and views in this DB
-- generate all table and views except the view which i made it encrypted (vNameTopManager)