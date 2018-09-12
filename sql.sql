2.职工表：职工的基本信息。
表2 职工信息表Employee
列名	数据类型	长度	属性	描述
Eno	char	8	主键	员工编号
Ename	varchar	10	不允许为空	员工姓名
Esex	varchar	8	不允许为空	性别
Ebirth	Date		不允许为空	出生年月
Eduty	varchar	20	不允许为空	职务
Eedu	varchar	8	不允许为空	学历
Etel	varchar	15	不允许为空	电话号码
Eaddr	varchar	20	不允许为空	住址
Eid	varchar	20	不允许为空	身份证号码
Dno	char	4		部门编号
        create table Employee(
	  Eno char(8) Primary Key,
	  Ename varchar(10) not null ,
	  Esex varchar(2) not null,
	  Ebirth date  not null,
		 Eduty varchar(20) not null ,
	  Eedu varchar(8) not null,
     Etel char(15) not null,
     Eadr char(40) not null,
		  Eid char(20) not null,
     Dno char(20) not null References Department(Dno)ON UPDATE CASCADE ON DELETE CASCADE
	  );

alter table employee add constraint C1 check(Esex in ('男','女'));
3.部门表：部门基本信息。
                      表3 部门信息表Department
列名	数据类型	长度	属性	描述
Dno	char	4	主键	部门号
Dname	varchar	10	不允许空	部门名
Dboss	char	8	不允许空	部门总管

create table Department(
Dno char(8) primary key,
Dname varchar(10) not null,
Dboss varchar(10) not null,
);

5.考勤表：记录员工的到职情况。
                    表5 考勤统计表attendance
列名	数据类型	长度	属性	描述
Eno	Char	8	主键	员工号
Atime	Date		主键	考勤年月
Aovertime	Int	6	不允许为空	加班时间
Akuang	Int	6	不允许为空	旷工天数
Alate	Int	6	不允许为空	迟到次数

create table attendance(
Eno char(8),
Atime int ,
Aovertime int not null,
Akuang int not null,
Alate int not null,
primary key(Eno,Atime)
);
   6.工资表：记录保存计算出来的工资。
                    表6 工资表Salary
列名	数据类型	长度	属性	描述
Eno	char	8	主键	员工编号
Stime	date		主键	工作年月
Sbase	decimal	8,2	不允许空	基本工资
Sallowance	decimal	8,2	不允许空	津贴
Sreward	decimal	8,2	不允许空	奖金

create table Salary(
  Eno char(8),
	Stime date,
	Sbase decimal(10,2) not null,
	Sallowance decimal(10,2) not null,
	Sreward decimal(10,2) not null,
	primary key(Eno,Stime)
);
员工用户表：记录员工用户名和密码
               员工用户表：Euser
列名	数据类型	长度	属性	描述
Eno	char	8	主键	员工编号
Epassword	varchar	32	不允许为空	密码

create table Euser(
Eno char(8)primary key,
Epassword varchar(32)
);

管理用户表：记录管理用户名和密码
               管理用户表：Muser
列名	数据类型	长度	属性	描述
Eno	char	8	主键	员工编号
Mpassword	varchar	32	不允许为空	密码

create table Muser(
Eno char(8)primary key,
Mpassword varchar(32)
);

代扣表
Deduction
列名	数据类型	长度	属性	描述
Eno	char	8	主键	员工编号
Dtime	date		主键	扣除年月
Insur	decimal	8,2		保险
Tax	deciaml	8,2		税

Create table Deduction(
Eno char(8),
Dtime date,
Insur decimal(8,2),
Tax decimal(8,2),
Primary key(Eno,Dtime)
);





触发器：删除员工表元组自动触发，考勤表、工资表、代扣表、工资视图所有Eno相同的元组
DELIMITER //
Create trigger e_t after delete on employee for each row begin delete from attendance where Eno=old.Eno;
	delete from salary where Eno=old.Eno;	delete from euser where Eno=old.Eno;
	delete from muser where Eno=old.Eno;	delete from deduction where Eno=old.Eno;end
 //
DELIMITER ;





工资视图
create view salary_v(姓名,工号,时间,基本工资,津贴,奖金,应得工资,加班时长,旷工天数,迟到次数,保险,税,实际工资)as select Ename ,salary.Eno,DATE_FORMAT(Stime,'%Y%m'),Sbase,Sallowance,Sreward,round(Sbase+Sallowance+Sreward,2),Aovertime,Akuang,Alate,
round((Sbase+Sallowance+Sreward)*0.1,2),
round((Sbase+Sallowance+Sreward+Aovertime*(Sbase/30/8*2)-Akuang*(Sbase/30)-Alate*100-(Sbase+Sallowance+Sreward)*0.1)*0.05,2),
round((Sbase+Sallowance+Sreward+Aovertime*(Sbase/30/8*2)-Akuang*(Sbase/30)-Alate*100)-(Sbase+Sallowance+Sreward)*0.1-(Sbase+Sallowance+Sreward+Aovertime*(Sbase/30/8*2)-Akuang*(Sbase/30)-Alate*100-(Sbase+Sallowance+Sreward)*0.1)*0.05,2)
from salary,attendance ,employee where salary.Eno=attendance.Eno and salary.Eno=employee.Eno and DATE_FORMAT(Stime,'%Y%m')=DATE_FORMAT(Atime,'%Y%m');



存储过程：
插入过程：在插入考勤表，工资表信息之后调用，参数为员工号，时间
 例：call in_deduction(20180001,20180909)
该过程用于将视图中的“保险”和“税”的值插入到deduction表中
DELIMITER //
create procedure in_deduction(in Eno_in char(8),in time_in date)
begin
  insert into deduction(Eno,Dtime,insur,tax) select Eno,Stime,保险,税 from salary_v,salary where Eno=Eno_in and Stime=time_in and 时间=DATE_FORMAT(time_in,'%Y%m') and Eno_in=工号;
end
//
DELIMITER ;


更新过程：在更新考勤表，工资表信息之后调用，参数为员工号，时间 例：call update_deduction(20180001,20180909)
该过程用于将视图中的“保险”和“税”的值在deduction表中更新



DELIMITER //
create procedure update_deduction(in Eno_in char(8),in time_in date)
begin
     declare tax_t decimal(8,2);
		 declare insur_t decimal(8,2);
		 set insur_t=(select 保险 from salary_v where 工号=Eno_in and 时间=DATE_FORMAT(time_in,'%Y%m'));
		 set tax_t=(select 税 from salary_v where 工号=Eno_in and 时间=DATE_FORMAT(time_in,'%Y%m'));
		 update deduction set insur=insur_t,tax=tax_t where Eno=Eno_in and Dtime=time_in;
end //
DELIMITER ;
