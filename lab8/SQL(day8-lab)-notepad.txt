--1.	Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 

alter proc getNumofStud
as
select Dept_Name ,count(St_Id) Student_count from Student s ,Department d
where d.Dept_Id = s.Dept_Id
group by d.Dept_Name;
--calling
getNumofStud
--========================================================================================================================
--2.	Create a stored procedure that will check for the # of employees in the project p1(pno=100) if they are more than 3 print message to the user'The number of employees in the project p1 is 3 or more' if they are less display a message to the user “'The following employees work for the project p1'” in addition to the first name and last name of each one. [Company DB] 

alter proc NumofEmp as
declare @num int = (select count(ESSn) from Works_for where pno=100)

	if @num >3
		select 'The number of employees in the project p1 is 3 or more'
	else if @num <=3
		begin
			select 'The following employees work for the project p1'
			select  fname+' '+lname full_name from Employee e ,Works_for w
			where w.ESSn = e.ssn and w.pno =300
		end
--calling
NumofEmp
--========================================================================================================================
--3.	Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him.
-- The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table.[Company DB]

alter proc oldNew_Data @oldEmpNum int ,@newEmpNum int ,@projNum int 
as
if exists(select ESSn from Works_for where essn = @oldEmpNum and pno = @projNum )
update Works_for
set essn =@newEmpNum where essn =@oldEmpNum and pno = @projNum 
else
select 'Employee ssn or project Num are not existing'
--calling
oldNew_Data 968574,102672,100
--========================================================================================================================
--4.	add column budget in project table and insert any draft values in it then Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
--	p2 			   Dbo 		 2008-01-31		   95000 	  200000 
--This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--Example:
--If a user updated the budget column then the project number, user name that made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column

alter table project add budget int 
create table history_audit (ProjectNo int,UserName varchar(30),ModifiedDate date,Budget_Old int ,Budget_New int)

alter trigger t1 on project
after update
as
if update(budget)
begin
	declare @newbud int ,@oldbud int,@pnum int
	select @newbud = budget ,@pnum = Pnumber from inserted
	--select @pnum = budget from inserted
	select @oldbud = budget from deleted
	insert into history_audit
	values(@pnum,suser_name(),getdate(),@oldbud,@newbud)
end
--checking
update project set budget= 2000 where Pnumber = 100
update project set budget= 4000 where Pnumber = 200
select * from history_audit
--========================================================================================================================
--5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB] 'Print a message for user to tell him that he can’t insert a new record in that table'

alter trigger t2 on Departments 
instead of insert
as
select ' You can’t insert a new record in Departments table'
--checking
insert into Departments values ('Dp5',50,512463,getdate())
--========================================================================================================================
--6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].

alter trigger t3 on Employee 
instead of insert
as
if month(getdate())=7
select 'You can’t insert in july'
else
begin
insert into Employee
select * from inserted
end
--checking
insert into Employee (fname,ssn) values ('mohsen',232323)
--========================================================================================================================
--7.	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note) 
--where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”

create table Student_audit(serv_uName varchar(30), _Date date,Note varchar(200))

create trigger t4 on Student
after insert as
begin
	declare @UserName varchar(50);
    declare @KeyVal int;
	declare @Note varchar(200);
	  select @UserName = SUSER_NAME();
	  select @KeyVal = St_Id from inserted;
	  select @Note = @UserName + ' Insert New Row with Key=' + CAST(@KeyVal as varchar(20)) + ' in table Student';
insert into Student_audit (serv_uName, _Date, Note)
values (@UserName, GETDATE(), @Note);
end
--checking
INSERT INTO Student (St_Id,St_Fname, St_Lname, St_Address, St_Age)
VALUES (23453,'mo', 'tay', 'portsaid', 25);
select * from Student_audit;
--========================================================================================================================
--8.	 Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”

create trigger t5 on student
instead of delete
as
begin
    declare @username varchar(100);
    declare @keyval int;
    declare @note varchar(200);

    set @username = suser_name();
    select @keyval = st_id from deleted;
    set @note = 'try to delete row with key=' + cast(@keyval as nvarchar(50));
    
	insert into student_audit (serv_uname, _date, note)
    values (@username, getdate(), @note);
end;
--checking
delete from student where st_id = 1;
select * from student_audit;
