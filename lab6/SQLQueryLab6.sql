--1.	 Create a scalar function that takes date and returns Month name of that date.
Create Function getMonth(@date date)
returns varchar(20)
	begin
		declare @month varchar(20)
			select @month=DATENAME(MONTH, @Date);
		return @month
	end
--calling
select dbo.getMonth('2024/02/15')

--=============================================================================================
--2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
alter Function getStudentBetween(@id1 int,@id2 int)
returns @t table ( id int , fname varchar(20))
as
begin
declare @currentId int
select @currentId = @id1 +1
while @currentId < @id2
  begin
	  insert into @t
	  select @currentId, St_Fname from Student
	  where St_Id = @currentId
select @currentId +=1
  end
return
end
--calling
select * from getStudentBetween(5, 10);

--=============================================================================================
--3.	 Create inline function that takes Student No and returns Department Name with Student full name.
alter function getStudData(@id int)
returns table 
as
	return(
		select s.st_fname +' '+s.st_lname as full_Name,d.Dept_Name  from Student s ,Department d
		where s.Dept_Id =d.Dept_Id and s.St_Id=@id)
--calling
select * from getStudData(10)

--=============================================================================================
--4.	Create a scalar function that takes Student ID and returns a message to user 
	--a.	If first name and Last name are null then display 'First name & last name are null'
	--b.	If First name is null then display 'first name is null'
	--c.	If Last name is null then display 'last name is null'
	--d.	Else display 'First name & last name are not null'
create function getFullName(@id int)
returns varchar (50)
as
	begin
		declare @Message varchar(50);
		declare @FirstName varchar(20);
		declare @LastName varchar(20);
		 select @FirstName = St_Fname, @LastName = St_Lname
		 from Student
		 where St_Id = @id;
		 if @FirstName IS NULL and @LastName IS NULL
			set @Message = 'First name & last name are null';
		 else if @FirstName IS NULL
			set @Message = 'First name is null';
		else if @LastName IS NULL
			set @Message = 'Last name is null';
		else
			set @Message = 'First name & last name are not null';
       return @Message;
	end
--calling
select dbo.getFullName(13)

--=============================================================================================
--5.	Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
create function GetManagerData (@Mngid int)
returns table
as
return 
(
    select d.Dept_Name, i.Ins_Name, mng.Manager_hiredate
    FROM Department d JOIN Department mng ON mng.Dept_Id = d.Dept_Id
	JOIN Instructor i on i.Ins_Id=mng.Dept_Manager
    WHERE mng.Dept_Manager = @Mngid
);
--calling
select * from GetManagerData(15)

--=============================================================================================
--6.	Create multi-statements table-valued function that takes a string
--	If string='first name' returns student first name
--	If string='last name' returns student last name 
--	If string='full name' returns Full Name from student table	--Note: Use “ISNULL” function
alter function getstudName(@format varchar(30))
returns @t table
		(id int,Name varchar(30))
as
	begin
		if @format='first name'
			insert into @t
			select st_id,st_fname from Student
		else if @format='last name'
			insert into @t
			select st_id,st_Lname from Student
		else if @format='full name'
			insert into @t
			select st_id,concat(st_fname,' ',st_lname) from Student
		return 
	end

--calling
select * from getstudName('full name')

--=============================================================================================
--7.	Write a query that returns the Student No and Student first name without the last char\
select St_Id,
    CASE 
        when St_Fname IS NULL then 'NULL_Name'
        else LEFT(St_Fname, LEN(St_Fname) - 1)
    END
from Student;

--=============================================================================================
--8.	Wirte query to delete all grades for the students Located in SD Department 
delete sc
from Stud_Course sc
JOIN Student s ON sc.St_Id = s.St_Id
JOIN Department d ON s.Dept_Id = d.Dept_Id
where d.Dept_Name = 'SD';

--=============================================================================================
--9.	Using Merge statement between the following two tables [User ID, Transaction Amount]
create table DailyTransactions (UserId int,TransAmount int);
create table LastTransactions (UserId int primary key,TransAmount int);

insert into DailyTransactions (UserId, TransAmount) values (1, 1000), (2, 2000), (3, 1000);
insert into LastTransactions (UserId, TransAmount) values (1, 4000), (4, 2000), (2, 10000);

merge into LastTransactions as t
using DailyTransactions as s
ON t.UserId = s.UserId
WHEN MATCHED THEN
    update set t.TransAmount = s.TransAmount
WHEN NOT MATCHED THEN
    insert (UserId, TransAmount) values (s.UserId, s.TransAmount);

--=============================================================================================
--10.	Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB then allow him to select and insert data into tables and deny Delete and update

create schema ITIStudSchema
alter schema ITIStudSchema transfer student
alter schema ITIStudSchema transfer stud_course
















