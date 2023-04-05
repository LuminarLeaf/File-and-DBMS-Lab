create database store;
use store;

#Q1
create table User(
    User_ID decimaL(3,0),
    Name varchar(30),
    City varchar(30),
    Email_id varchar(30),
    DOB date,
    primary key (User_ID)
);

create table Brand(
    Brand_ID decimal(3,0),
    Brand_Name varchar(30),
    Brand_Type varchar(30),
    Ranking decimal(3,0),
    primary key (Brand_ID)
);

create table Product(
    Prod_ID decimal(5,0),
    Prod_Name varchar(30),
    Description varchar(100),
    Price decimal(5,0),
    Ratings decimal(3,1),
    Brand_ID decimal(3,0),
    primary key (Prod_ID),
    foreign key (Brand_ID) references Brand(Brand_ID)
);

create table Offer(
    Offer_ID decimal(3,0),
    Offer_Des varchar(100),
    Validity varchar(30),
    primary key (Offer_ID)
);

create table Purchase(
    User_ID decimaL(3,0),
    Prod_ID decimal(5,0),
    foreign key (User_ID) references User(User_ID),
    foreign key (Prod_ID) references Product(Prod_ID)
);

create table Product_Has(
    Prod_ID decimal(5,0),
    Brand_ID decimal(3,0),
    Offer_ID decimal(3,0),
    foreign key (Prod_ID) references Product(Prod_ID),
    foreign key (Brand_ID) references Brand(Brand_ID),
    foreign key (Offer_ID) references Offer(Offer_ID)
);

insert into User values(50,"Bishal Nayek","Bhubaneswar","bn30@email.com","2001-05-30");
insert into User values(39,"Vaishali","Hyedrabad","v23@email.com","1997-12-23");
insert into User values(42,"Varun Sharma","Mumbai","vs01@email.com","1985-08-01");
insert into User values(98,"Abhijit Sen","Kolkata","as05@email.com","1993-07-05");
insert into User values(09,"Praveen Kumar","Delhi","pk09@email.com","1999-11-09");

insert into Brand values(01,"Harper Collins","Publisher",6);
insert into Brand values(05,"Apple","Electronics",7);
insert into Brand values(09,"Samsung","Electronics",4);
insert into Brand values(03,"Mcaffine","Skin Care",4);
insert into Brand values(10,"Peter England","Clothing",8);

insert into Product values(0325,"Tablet_1","Big Display",49990,4.3,05);
insert into Product values(9826,"Smart TV_New","Dolby Sound",29999,4.1,09);
insert into Product values(3518,"Face Combo","All Skin Type",1549,3.9,10);
insert into Product values(1437,"ASOIAF_GOT","Paperback",3110,4.5,01);
insert into Product values(2549,"Men's Jeans","Slimfit",2120,3.7,03);

insert into Offer values(05,"10% discount on ABI credit card","30 days");
insert into Offer values(20,"No Cost EMI","15 days");
insert into Offer values(16,"5% Cashback","Unlimited");
insert into Offer values(29,"Exchange Old Product","limited");
insert into Offer values(18,"RS 1500 off over RS 20000 purchase","45 days");

insert into Purchase values(42,0325);
insert into Purchase values(50,1437);
insert into Purchase values(39,3518);
insert into Purchase values(98,0325);
insert into Purchase values(09,9826);
insert into Purchase values(39,2549);

insert into Product_Has values(0325,05,29);
insert into Product_Has values(9826,09,18);
insert into Product_Has values(3518,10,16);
insert into Product_Has values(1437,01,20);
insert into Product_Has values(2549,03,16);

#Q3
select User_Name from User where User_Name like 'V%';

#Q4
select Brand_Name,Rank from Brand where Brand_Type like '%c%' or Brand_Type like '%C%';

#Q5
select Brand_ID from Brand where Brand_ID > (select MIN(Offer_ID) from Offer);

#Q6
select count(*) from Product where Price < 10000;

#Q7 TODO:
#select * from Offer limit 3;

#Q8
select Prod_ID, Prod_Name,
case
    when Price > 30000 then 'High'
    when Price > 10000 then 'Medium'
    else 'Low'
end as Price_Category
from Product;

#Q9
select STDDEV(Price) as Price_StdDev, STDDEV(Ratings) as Ratings_StdDev from Product;

#Q10
select month(DOB) as Month from User where City="Kolkata";

#Q11
#natural JOIN
select * from Product natural join Brand;
#inner join
select * from Product inner join Brand on Product.Brand_ID = Brand.Brand_ID;

#Q12
select Description from Product natural join Brand where Ratings > 4 group by Brand_Type;

#Q13
select Prod_Name from Product natural join Purchase natural join User where day(DOB) between 4 and 24;

#Q14
select name,City from User group by City;

#Q15
select Prod_Name from Product natural join Purchase group by Prod_Name having count(*) > 1;

#Q16
select Email_ID from User natural join Purchase 
group by Email_ID having count(*) = (select max(count) from (select count(*) as count from User natural join Purchase group by Email_ID) as t);

#Q17
select User.Name, Product.Prod_Name from User natural join Purchase natural join Product natural join Product_Has natural join Offer where Offer.Offer_Des like '%5%';

#Q18
select Brand_Name from Brand natural join Product_Has natural join Offer where Offer_Des like '%5%';

#Q19
select Name, Email_id from User natural join Purchase natural join Product where City = 'Kolkata' and Prod_Name = 'Tablet_1';

#Q20
select * from User natural join Purchase natural join Product where DATE_FORMAT(FROM_DAYS(DATEDIFF(now(),DOB)), '%Y')+0 > 21 and Prod_Name = 'Face Combo';
