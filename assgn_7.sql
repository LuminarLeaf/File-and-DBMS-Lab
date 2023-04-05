-- ---------------------------------------------------
--              run in MySQL 8.0
-- ---------------------------------------------------

create database company;
use company;

create table PROJECT(
    project_id int primary key,
    project_name varchar(20),
    duration int
);

create table EMPLOYEES(
    emp_id int primary key,
    emp_name varchar(20),
    birth_date date,
    gender char(1),
    hire_date date,
    dept_id int,
    manager_id int,
    project_id int,
    salary int,
    foreign key (manager_id) references EMPLOYEES(emp_id),
    foreign key (project_id) references PROJECT(project_id)
);

create table DEPARTMENT(
    dept_id int primary key,
    dept_name varchar(20),
    manager_id int,
    total_emp int,
    foreign key (manager_id) references EMPLOYEES(emp_id)
);

create table EXEMP(
    emp_id int primary key,
    emp_name varchar(20),
    reg_date date
);

alter table EMPLOYEES add constraint fk_dept_id foreign key (dept_id) references DEPARTMENT(dept_id);

-- # Q1
create trigger set_hire_date
before insert on EMPLOYEES
for each row
set new.hire_date = curdate();

-- # Q2
delimiter //
create trigger check_salary
before insert on EMPLOYEES
for each row
begin
    if new.salary < 500000 then
        signal sqlstate '45000'
        set message_text = 'Salary should be greater than 500000';
    end if;
end//
delimiter ;

-- # Q3
delimiter //
create trigger check_birth_date
before insert on EMPLOYEES
for each row
begin
    if new.birth_date is null or new.gender is null then
        signal sqlstate '45000'
        set message_text = 'Birth date or gender is missing';
    end if;
end//
delimiter ;

-- # Q4
create trigger update_total_emp
after insert on EMPLOYEES
for each row
update DEPARTMENT set total_emp = total_emp + 1 where dept_id = new.dept_id;

-- # Q5
create trigger update_manager_id
after update on DEPARTMENT
for each row
update EMPLOYEES set manager_id = new.manager_id where dept_id = new.dept_id;

-- # Q6
delimiter //
create trigger check_increment
before update on EMPLOYEES
for each row
begin
    if new.salary - old.salary < 0.1 * old.salary or new.salary - old.salary > 0.5 * old.salary then
        signal sqlstate '45000'
        set message_text = 'Increment should be between 10% and 50%';
    end if;
end//
delimiter ;

-- # Q7
create trigger insert_exemp
after delete on EMPLOYEES
for each row
insert into EXEMP values (old.emp_id, old.emp_name, curdate());

-- # Q8
delimiter //
create trigger check_dept
before delete on DEPARTMENT
for each row
begin
    if (select count(*) from EMPLOYEES where dept_id = old.dept_id) > 1 then
        signal sqlstate '45000'
        set message_text = 'Department has more than 1 employee';
    end if;
end//
delimiter ;

-- # Q9
select emp_name, salary
from EMPLOYEES, DEPARTMENT
where EMPLOYEES.dept_id = DEPARTMENT.dept_id and salary = (select max(salary) from EMPLOYEES where dept_id = DEPARTMENT.dept_id);

-- # Q10
select emp_name
from EMPLOYEES
where project_id is null;

-- # Q11
select EMPLOYEES.emp_name, EMPLOYEES.salary
from EMPLOYEES, EMPLOYEES as M
where EMPLOYEES.manager_id = M.emp_id and EMPLOYEES.salary < M.salary;

-- # Q12
select emp_name, project_name
from EMPLOYEES, PROJECT
where EMPLOYEES.project_id = PROJECT.project_id and duration > (select avg(duration) from PROJECT);

-- # Q13
select emp_name, birth_date
from EMPLOYEES as emp
where gender = 'M' and birth_date = (select max(birth_date) from EMPLOYEES where dept_id = emp.dept_id);

-- # Q14
select emp_id, emp_name
from EMPLOYEES, PROJECT
where EMPLOYEES.project_id = PROJECT.project_id and duration > 6
order by salary desc
Limit 5;

-- # Q15
select emp_name, salary
from EMPLOYEES
where salary in (select salary from EMPLOYEES as emp where emp.dept_id = EMPLOYEES.dept_id order by salary asc limit 3);
