--1.	Retrieve number of students who have a value in their age.
select COUNT(*) from Student
where St_Age Is Not Null;

--2.	Get all instructors Names without repetition.
select * from (
select *,Dense_Rank() over (order by Ins_Name) as DR
from Instructor) as newInstructor

--3.	Display student with the following Format (use isNull function)
select St_Id as"Student ID" , ISNULL(St_Fname + ' ' + St_Lname , 'N/A') as "Student Full Name" , ISNULL(Dept_Name,'N/A') as "Department Name"
from Student as s,Department as d
where s.Dept_Id = d.Dept_Id

--4.	Display instructor Name and Department Name  Note: display all the instructors if they are attached to a department or not
select Ins_Name , Dept_Name from Instructor as i Left join Department as d
on i.Dept_Id = d.Dept_Id

--5.	Display student full name and the name of the course he is For only courses which have a grade  
select "Student Full Name"= St_Fname + ' ' + St_Lname , crs_Name from Student as s join Stud_Course as sc
on s.St_Id = sc.St_Id join Course as c
on sc.Crs_Id =c.Crs_Id 
where sc.Grade IS NOT NULL;

--6.	Display number of courses for each topic name
select Top_Name , COUNT(*) as "num Of Courses" from Course as c,Topic as t
where t.Top_Id = c.Top_Id
group by t.Top_Name

--7.	Display max and min salary for instructors
select Max(Salary) as MaxSalary , Min(Salary)as MinSalary from Instructor

--8.	Display instructors who have salaries less than the average salary of all instructors.
select Ins_Name salary from Instructor
where Salary < (select  avg(Salary) from Instructor);

--9.	Display the Department name that contains the instructor who receives the minimum salary.
select Dept_Name from Department as d,Instructor as i
where i.Dept_Id = d.Dept_Id and salary = (select Min(Salary) from Instructor)

--10.	 Select max two salaries in instructor table. 
SELECT TOP 2 * FROM Instructor ORDER BY salary DESC;

--11.	Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
select Ins_Name, COALESCE(CONVERT(NVARCHAR, Salary),'bouns') from Instructor

--12.	Select Average Salary for instructors 
SELECT AVG(Salary) AS AvgSalary FROM Instructor;

--13.	Select Student first name and the data of his supervisor 
SELECT s1.St_Fname AS StudentFName, s2.St_Fname + ' ' + s2.St_Lname AS SupervisorName, s2.St_Address, s2.St_Age 
FROM Student s2 JOIN Student s1 ON s1.St_super = s2.St_Id;

--14.	Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
select * from(select Ins_Name,Dept_Id,Salary,
	DENSE_RANK() OVER (PARTITION BY Dept_Id ORDER BY Salary DESC) AS DR
    from Instructor) as newTable
	WHERE Salary IS NOT NULL and DR <= 2

--15.	 Write a query to select a random  student from each department.  “using one of Ranking Functions”
select * from (select St_Id,St_Fname,St_Lname,Dept_Id,
    ROW_NUMBER() OVER (PARTITION BY Dept_Id ORDER BY NEWID()) AS RN
    FROM Student)as newTable
	WHERE St_Fname IS NOT NULL and RN = 1;