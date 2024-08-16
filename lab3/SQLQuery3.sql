create table Instructor
(
 ID int Primary key identity(1,1),
 Iaddress varchar(50),
 hiredate date default getdate(),
 salary int default 3000,
 overtime int,
 BD date,
 fname varchar(50),
 lname varchar(50),
 netsalary as(isnull(salary,0)+isnull(overtime,0)) persisted,
 age as(year(getdate())-year(bd)),
 constraint inst_addre check(Iaddress in('cairo','alex')),
 constraint salary_range check(salary between 1000 and 5000),
 constraint uni_overtime unique(overtime),
)
create table Course 
(
CID int Primary key identity(1,1),
Cname varchar(50),
Duration int,
constraint uni_Duration unique(Duration),
)
create table inst_course
(
inst_id int references Instructor(ID)
	on delete cascade  on update cascade,
cour_id int references Course(CID)
on delete cascade  on update cascade,
constraint inst_course_pk primary key(inst_id, cour_id),
)
create table Lab
(
LID int identity(1,1),
loca varchar(50),
capacity int,
course_id int references Course(CID)
on delete cascade  on update cascade,
constraint cour_lab primary key(LID, course_id),
constraint capa_seats check(capacity>20),
)