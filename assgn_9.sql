-- -------------------------------------------------------
--                     USE MYSQL 8.0
-- -------------------------------------------------------
create database COURSE_INFO;
use COURSE_INFO;

create table RegUSER(
    RNo int,
    RName varchar(20),
    ROccu varchar(10) check (ROccu in ('FACULTY', 'STUDENT', 'STAFF')) NOT NULL,
    Age int,
    HighQual varchar(5) check (HighQual in ('BTECH', 'MTECH', 'PHD')) NOT NULL,
    PRIMARY KEY(RNo)
);

create table Faculty(
    FId int,
    ResearchArea varchar(4) check (ResearchArea in ('AI', 'ML', 'ALGO', 'DBMS')) NOT NULL,
    FDept varchar(3) check (FDept in ('CS', 'ECE', 'EE', 'ME')) NOT NULL,
    PRIMARY KEY(FId),
    FOREIGN KEY fk_std_0(FId) REFERENCES RegUSER(RNo)
);

create table Course(
    CId int,
    CName varchar(10),
    CDuration varchar(10) check (CDuration in ('SHORT', 'MEDIUM', 'LONG')) NOT NULL,
    CDept varchar(3) check (CDept in ('CS', 'ECE', 'EE', 'ME')) NOT NULL,
    FId int,
    PRIMARY KEY(CId),
    FOREIGN KEY fk_std_1(FId) REFERENCES Faculty(FId)
);

create table PreRequisite(
    CId int,
    PreqCId int,
    FOREIGN KEY fk_std_2(CId) REFERENCES Course(CId),
    FOREIGN KEY fk_std_3(PreqCId) REFERENCES Course(CId),
    PRIMARY KEY(CId, PreqCId)
);

create table CourseReg(
    RNo int,
    CId int,
    Score int,
    PRIMARY KEY(RNo, CId),
    FOREIGN KEY fk_std_4(RNo) REFERENCES RegUSER(RNo),
    FOREIGN KEY fk_std_5(CId) REFERENCES Course(CId)
);

-- #Q1
SELECT E1.RNo, E1.RName, Faculty.FId, E2.RName AS 'FName', Course.CId, CName
FROM RegUSER AS E1
JOIN CourseReg ON E1.RNo = CourseReg.RNo
JOIN Course ON CourseReg.CId = Course.CId
JOIN Faculty ON Course.FId = Faculty.FId
JOIN RegUSER AS E2 ON Faculty.FId = E2.RNo
WHERE E1.HighQual = 'BTECH';

-- #Q2
SELECT E1.RNo, E1.RName, Faculty.FId, E2.RName AS 'FName', Course.CId, Course.CName
FROM RegUSER E1
JOIN CourseReg ON E1.RNo = CourseReg.RNo
JOIN Course ON CourseReg.CId = Course.CId
JOIN Faculty ON Course.FId = Faculty.FId
JOIN RegUSER E2 ON Faculty.FId = E2.RNo
WHERE E1.ROccu <> 'STAFF' AND CDuration = 'SHORT' AND FDept = 'CS';

-- #Q3
SELECT E1.RNo, E1.RName, Faculty.FId ,E2.RName AS 'FName', Course.CId, Course.CName
FROM RegUSER E1
JOIN CourseReg ON E1.RNo = CourseReg.RNo
JOIN Course ON CourseReg.CId = Course.CId
JOIN Faculty ON Course.FId = Faculty.FId
JOIN RegUser E2 ON Faculty.FId = E2.RNo
WHERE E1.HighQual = 'BTECH' AND not FDept IN ('EE', 'ME') AND ResearchArea <> 'DBMS';

-- #Q4
SELECT E1.RNo, E1.RName, Course.CId, Course.CName, Score
FROM RegUSER AS E1 INNER JOIN CourseReg INNER JOIN Course INNER JOIN Faculty INNER JOIN RegUSER AS E2
WHERE E1.HighQual = 'MTECH' AND E1.RNo = CourseReg.RNo AND CourseReg.CId = Course.CId AND Course.FId = Faculty.FId AND Faculty.FId = E2.RNo AND Course.CDept IN ('CS', 'EE')
GROUP BY Course.CDept, E1.RNo, Course.CId
ORDER BY Course.CDept, Score DESC
LIMIT 4;

-- #Q5
SELECT RegUser.RNo, RName, Course.CId, CName
FROM RegUSER
JOIN CourseReg ON RegUSER.RNo = CourseReg.RNo
JOIN Course ON CourseReg.CId = Course.CId
JOIN PreRequisite ON Course.CId = PreRequisite.CId
GROUP BY PreRequisite.CId, RNo
HAVING COUNT(*) > 1;

-- #Q6
SELECT RegUser.RNo,RegUSER.RName,Course.CId,Course.CName
FROM RegUSER NATURAL JOIN CourseReg NATURAL JOIN Course
WHERE 2 <> (SELECT count(PreqCId) FROM Prerequisite WHERE Prerequisite.CId=Course.CId);

-- #Q7
select E1.RNo, E1.RName, Faculty.FId, E2.RName, Course.CId, CName
FROM RegUSER E1
JOIN CourseReg ON E1.RNo = CourseReg.RNo
JOIN Course ON CourseReg.CId = Course.CId
JOIN Faculty ON Course.FId = Faculty.FId
JOIN RegUSER E2 ON Faculty.FId = E2.RNo
WHERE E1.HighQual in ('BTECH', 'MTECH') and Course.CDept in ('ECE', 'EE') and Course.CDuration = 'MEDIUM' and not FDept = 'ME' and not ResearchArea in ('AI','ML');

-- #Q8 TODO: course wise avg in dept avg
SELECT CName, RName as 'FName', FDept, AVG(Score) AS 'AvgScore'
FROM Course
JOIN Faculty ON Course.FId = Faculty.FId
JOIN RegUSER ON Faculty.FId = RegUSER.RNo
JOIN CourseReg ON Course.CId = CourseReg.CId
GROUP BY CName, RName, FDept
HAVING AVG(Score) > (
    SELECT CDept, AVG(Score) FROM CourseReg
    JOIN Course ON CourseReg.CId = Course.CId
    WHERE CDept = Faculty.FDept
    GROUP BY CDept
);

-- #Q9
delimiter %%
CREATE TRIGGER preq_fulfilled BEFORE INSERT ON CourseReg
for each row
BEGIN
    IF (SELECT count(RNo) FROM CourseReg WHERE CId in (SELECT PreqCId FROM Prerequisite p WHERE p.CId = new.CId) and RNo=new.RNo) != (SELECT count(PreqCId) FROM Prerequisite p WHERE p.CId = new.CId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pre-requisites not cleared.';
    END IF;
END;
%% delimiter ;

-- #Q10
delimiter %%
CREATE TRIGGER limit_cross BEFORE INSERT ON CourseReg
for each row
BEGIN
    IF (SELECT count(RNo) from CourseReg WHERE CId=new.CId ) >= 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Course limit exceeded.';
    END IF;
END;
%% delimiter ;

-- #Q11
DELIMITER //
CREATE PROCEDURE find_fac_ra_preq()
BEGIN
    SELECT DISTINCT rname,FId,researcharea,reguser.rname
    FROM Faculty NATURAL JOIN Course NATURAL JOIN reguser
    WHERE reguser.rno = FId AND CId IN (SELECT preqcid FROM Prerequisite) AND FID = REGUSER.RNO;
END//
DELIMITER ;
CALL find_fac_ra_preq();

-- #Q12
DELIMITER //
CREATE PROCEDURE preq_fac(IN a VARCHAR(20))
BEGIN
    SELECT Course.CId,Course.CName,Course.FId,reguser.rname
    FROM RegUSER,Course
    WHERE Course.CId In (SELECT preqcid FROM prerequisite,Course WHERE Course.cname = a AND COURSE.CID = PREREQUISITE.CID) AND reguser.rno = FId;
END//
DELIMITER ;
CALL preq_fac('course6');

-- #Q13
-- create a procedure that takes the name of a student as input and finds the name of students who got the highest mmarks in each course in which the input student has registered along with the subject name and total no of students registered for each course.
drop procedure find_highest;
DELIMITER //
CREATE PROCEDURE find_highest(IN a VARCHAR(20))
BEGIN
    SELECT Course.CName,RegUser.RName,MAX(Score)
    FROM CourseReg
    JOIN Course ON CourseReg.CId = Course.CId
    JOIN RegUser ON CourseReg.RNo = RegUser.RNo
    WHERE CourseReg.CId IN (
        SELECT CR.CId FROM CourseReg as CR
        JOIN RegUser as RG ON CR.RNo = RG.RNo
        WHERE RG.RName = a
    )
    GROUP BY CourseReg.CId, RegUSER.RName;
END//
DELIMITER ;
CALL find_highest('Akhil');

-- #Q15
DELIMITER //
CREATE PROCEDURE find_pop_dep()
BEGIN
    SELECT cdept,COUNT(rno)
    FROM Course NATURAL JOIN CourseReg
    GROUP BY cdept 
    ORDER BY COUNT(rno) DESC
    LIMIT 1;
END//
DELIMITER ;
CALL find_pop_dep();
