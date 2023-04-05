create database ott;

use ott;

#Q1
create table USER(
User_Id varchar(25),
User_Name varchar(25),
DOB date,
Age decimal(3,0),
Email_id varchar(50),
Watching_hour decimal(5,0),
primary key (User_Id)
);

create table SHOWS(
Show_Id decimal(5,0),
Title varchar(30),
Release_date date,
Language varchar(30),
Rating_Id decimal(8,0),
Genre_Id decimal(4,0),
primary key (Show_Id)
);

create table RATING(
Rating_Id decimal(8,0),
Show_Id decimal(5,0),
Star decimal (2,0),
Date date,
Comment varchar(100),
primary key (Rating_Id),
foreign key (Show_Id) references SHOWS(Show_Id)
);

create table GENRE(
Genre_Id decimaL(4,0),
Show_Id decimal(5,0),
Genre_Name varchar(30),
primary key (Genre_Id),
foreign key (Show_Id) references SHOWS(Show_Id)
);

create table WATCH_REVIEW(
User_Id varchar(25),
Show_Id decimal(5,0),
Rating_Id decimal(8,0),
Genre_Id decimal(4,0),
foreign key (User_Id) references USER(User_Id),
foreign key (Rating_Id) references RATING(Rating_Id),
foreign key (Show_Id) references SHOWS(Show_Id),
foreign key (Genre_Id) references GENRE(Genre_Id)
);

alter table SHOWS add constraint rating foreign key (Rating_Id) references RATING(Rating_Id);
alter table SHOWS add constraint genre foreign key (Genre_Id) references GENRE(Genre_Id);

#Q2
insert into USER values("dip23","Dinesh Patel","2002-10-23",20,"abc@email.com",125);
insert into USER values("vs2001","Vikram Sharma","2001-07-15",21,"vik@email.com",329);
insert into USER values("agra30","Sukesh Agarwal","1993-02-09",30,"sa@email.com",75);
insert into USER values("mg2509","Manish Gupta","1997-09-25",25,"man@email.com",156);
insert into USER values("tri28","Trina Dutta","1995-11-09",27,"tri28@email.com",249);

#Q3
set foreign_key_checks=0;
insert into SHOWS values(156,"Stranger Things","2016-07-15","English",4895,08);
insert into SHOWS values(258,"Sacred Games","2018-07-05","Hindi",7589,01);
insert into SHOWS values(895,"The Witcher","2019-12-20","English",5248,15);
insert into SHOWS values(659,"Money Heist","2017-05-02","English",3698,03);
insert into SHOWS values(321,"Breaking Bad","2008-01-20","English",6742,04);

#Q4
insert into RATING values(4895,156,4,"2021-05-16","Nice");
#insert into RATING values(3574,001,1,"2018-11-29","Very Bad");
#insert into RATING values(8517,010,5,"2022-08-15","Wonderful");
insert into RATING values(5248,895,3,"2021-09-06","Could be better");
insert into RATING values(6742,321,5,"2020-10-19","Outstanding");
insert into RATING values(3698,659,5,"2021-09-30","Fantastic");
insert into RATING values(7589,258,3,"2022-01-25","Average");

#Q5
insert into GENRE values(01,258,"Crime");
insert into GENRE values(03,659,"Thriller");
insert into GENRE values(04,321,"Suspense");
insert into GENRE values(15,895,"Fantasy");
insert into GENRE values(08,156,"Science Fiction");

#Q6
insert into WATCH_REVIEW values("mg2509",156,4895,08);
insert into WATCH_REVIEW values("vs2001",321,6742,04);
insert into WATCH_REVIEW values("tri28",895,5248,15);
insert into WATCH_REVIEW values("agra30",659,3698,03);
insert into WATCH_REVIEW values("vs2001",258,7589,01);

show tables;
select * from USER;
select * from SHOWS;
select * from RATING;
select * from GENRE;
select * from WATCH_REVIEW;

set foreign_key_checks=1;

#Q7
update RATING set Star=4 where Rating_Id=7589;
select * from RATING;

#Q8
#to run this remove # at line 75
#delete from RATING where Show_Id=001;
#select * from RATING;

#Q9
insert into USER values("sagar23","Sagar Bhowmik","1999-10-23",23,"sag@gmail.com",12);
select * from USER;

#Q10
alter table SHOWS drop foreign key rating;
alter table SHOWS drop column Rating_Id;
describe SHOWS;
select * from SHOWS;

#Q11
alter table USER change column Watching_hour Screen_Time decimaL(5,0);
describe USER;

#Q12
select Comment from RATING where Star = 5;

#Q13
select distinct User_id from WATCH_REVIEW;

#Q14
select Email_id from USER where Age>25;

#Q15
select Title from SHOWS, RATING where SHOWS.Show_Id = RATING.Show_Id and Star >=4;

#Q16
select Genre_Name from GENRE,RATING where GENRE.Show_Id = RATING.Show_Id and Comment = "Outstanding";

#Q17
select * from USER where User_Name like "%a";

#Q18
select count(Show_Id) as No_Of_Shows, Genre_Id from SHOWS group by (Genre_Id) order by No_Of_Shows desc;

#Q19
# with limit
select Title from shows where show_id = (select show_id from rating order by star desc limit 4,1);
# without limit
select Title from shows where show_id = (select )

#Q20
#sql 5.6
select SHOWS.Show_Id as Show_ID, max(Star) FROM SHOWS JOIN RATING ON SHOWS.Show_Id=RATING.Show_Id GROUP BY Genre_Id;

#Q21
select * from SHOWS where Title LIKE '%r' and LENGTH(Title)=11;

#Q22
select REPLACE(Title,'e','E') from SHOWS;

#Q23
select Title from SHOWS where Release_date LIKE '2018%' and Language='Hindi';

#Q24
select User_Name from USER where Age between 20 and 25;