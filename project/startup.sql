create database erp;
use erp;

create table department(
dept_id int primary key,
dept_name varchar(20) not null,
dept_head int not null,
);

create table professors(
prof_id int primary key,
prof_name varchar(20) not null,
prof_dept int not null,
prof_phone varchar(10) not null,
prof_email varchar(20) not null,
prof_address varchar(20) not null
prof_post varchar(20) not null
);

create table students(
stud_id int primary key,
stud_name varchar(20) not null,
stud_dept int not null,
stud_phone varchar(10) not null,
stud_email varchar(20) not null,
stud_dob date not null,
stud_hall varchar(20) not null,
stud_room varchar(20) not null,
foreign key(stud_dept) references department(dept_id)
);

create table courses(
course_id int primary key,
course_name varchar(20) not null,
course_dept int not null,
course_prof int not null,
course_sem int not null,
course_credits int not null,
foreign key(course_dept) references department(dept_id),
foreign key(course_prof) references professors(prof_id)
);

create table prerequisites(
course_id int primary key,
prereq_id int not null,
foreign key(course_id) references courses(course_id),
foreign key(prereq_id) references courses(course_id)
);

create table faculty_advisors(
stud_id int primary key,
prof_id int not null,
foreign key(stud_id) references students(stud_id),
foreign key(prof_id) references professors(prof_id)
);

create table course_enrollment(
stud_id int primary key,
course_id int not null,
