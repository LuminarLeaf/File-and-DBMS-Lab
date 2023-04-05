create database college;
use college;

create table DEPARTMENTS(
    department_id int primary key,
    department_name varchar(20),
    department_head_id int
);

create table FACULTY(
    faculty_id int primary key,
    first_name varchar(20),
    last_name varchar(20),
    email varchar(30),
    phone_no varchar(10),
    department_id int,
    foreign key (department_id) references DEPARTMENTS(department_id)
);

create table COURSES(
    course_id int primary key,
    course_name varchar(20),
    description varchar(100),
    credits int,
    department_id int,
    foreign key (department_id) references DEPARTMENTS(department_id)
);

create table STUDENTS(
    student_id int primary key,
    first_name varchar(20),
    last_name varchar(20),
    email varchar(30),
    phone_no varchar(10),
    date_of_birth date,
    faculty_advisor_id int,
    department_id int,
    foreign key (faculty_advisor_id) references FACULTY(faculty_id),
    foreign key (department_id) references DEPARTMENTS(department_id)
);

create table ENROLLMENTS(
    enrollment_id int primary key,
    student_id int,
    course_id int,
    enrollment_date date,
    grade int,
    foreign key (student_id) references STUDENTS(student_id),
    foreign key (course_id) references COURSES(course_id)
);

-- #Q1
delimiter //
create procedure add_numbers(IN var1 INT, IN var2 INT)
begin
    select var1 + var2;
end //
delimiter ;

-- #Q2
delimiter //
create procedure students_in_dept(IN dept_id INT)
begin
    select count(*) from STUDENTS where department_id = dept_id;
end //
delimiter ;

-- #Q3
delimiter //
create procedure student_details(IN student_id INT)
begin
    select first_name, last_name, course_name, grade from STUDENTS inner join ENROLLMENTS inner join COURSES where STUDENTS.student_id = ENROLLMENTS.student_id and ENROLLMENTS.course_id = COURSES.course_id and STUDENTS.student_id = student_id;
end //
delimiter ;

-- #Q4
delimiter //
create procedure update_advisor(IN student_id INT, IN advisor_id INT)
begin
    update STUDENTS set faculty_advisor_id = advisor_id where student_id = student_id;
end //
delimiter ;

-- #Q5
delimiter //
create procedure avg_grade(IN course_id INT)
begin
    select avg(grade) from ENROLLMENTS where course_id = course_id;
end //
delimiter ;

-- #Q6
delimiter //
create procedure most_populated_dept()
begin
    select DEPARTMENTS.department_name, count(*) as "No of students" from DEPARTMENTS inner join STUDENTS where DEPARTMENTS.department_id = STUDENTS.department_id group by DEPARTMENTS.department_name order by count(*) desc limit 1;
end //
delimiter ;

-- #Q7
delimiter //
create procedure courses_offered(IN dept_id INT)
begin
    select COURSES.course_name, count(*) as "No of students" from COURSES inner join ENROLLMENTS where COURSES.course_id = ENROLLMENTS.course_id and COURSES.department_id = dept_id group by COURSES.course_name;
end //
delimiter ;

-- #Q8
delimiter //
create procedure course_details(IN dept_name VARCHAR(20))
begin
    select COURSES.course_name, COURSES.description, COURSES.credits from COURSES inner join DEPARTMENTS where COURSES.department_id = DEPARTMENTS.department_id and DEPARTMENTS.department_name = dept_name;
end //
delimiter ;

-- #Q9
delimiter //
create procedure gpa(IN student_id INT)
begin
    declare total_credits int;
    select sum(credits) into total_credits from ENROLLMENTS inner join COURSES where ENROLLMENTS.course_id = COURSES.course_id and ENROLLMENTS.student_id = student_id;
    select sum(grade*credits)/total_credits from ENROLLMENTS inner join COURSES where ENROLLMENTS.course_id = COURSES.course_id and ENROLLMENTS.student_id = student_id;
end //
delimiter ;

-- #Q10
delimiter //
create procedure highest_grade(IN dept_id INT)
begin
    select concat(first_name, " ", last_name) as "Name", grade from STUDENTS inner join ENROLLMENTS where STUDENTS.student_id = ENROLLMENTS.student_id and STUDENTS.department_id = dept_id order by grade desc limit 1;
end //
delimiter ;

-- #Q11
-- assuming max allowed credits is 20
delimiter //
create trigger check_credits
before insert on ENROLLMENTS
for each row
begin
    declare total_credits int;
    select sum(credits) into total_credits from ENROLLMENTS inner join COURSES where ENROLLMENTS.course_id = COURSES.course_id and ENROLLMENTS.student_id = new.student_id;
    if total_credits + (select credits from COURSES where course_id = new.course_id) > 20 then
        signal sqlstate '45000' set message_text = 'Total credits exceeded';
    end if;
end //
delimiter ;

-- #Q12
-- F is 0
delimiter //
create trigger check_grade
before update on ENROLLMENTS
for each row
begin
    if new.grade = 0 then
        signal sqlstate '45000' set message_text = 'Grade cannot be F';
    end if;
end //
delimiter ;

-- #Q13
delimiter //
create trigger check_courses
before delete on DEPARTMENTS
for each row
begin
    if (select count(*) from COURSES where department_id = old.department_id) > 0 then
        signal sqlstate '45000' set message_text = 'Department has courses';
    end if;
end //
delimiter ;

-- #Q14
select concat(first_name, " ", last_name) as "Name", email
from FACULTY inner join DEPARTMENTS inner join COURSES inner join ENROLLMENTS inner join STUDENTS
where FACULTY.department_id = DEPARTMENTS.department_id and DEPARTMENTS.department_id = COURSES.department_id and COURSES.course_id = ENROLLMENTS.course_id and ENROLLMENTS.student_id = STUDENTS.student_id and STUDENTS.faculty_advisor_id = FACULTY.faculty_id and DEPARTMENTS.department_head_id != FACULTY.faculty_id
group by FACULTY.faculty_id;

-- #Q15
select DEPARTMENTS.department_name, concat(first_name, " ", last_name) as "Name", count(*) as "No of students"
from DEPARTMENTS inner join FACULTY inner join STUDENTS
where DEPARTMENTS.department_id = FACULTY.department_id and FACULTY.faculty_id = STUDENTS.faculty_advisor_id
group by FACULTY.faculty_id
order by count(*) desc;
