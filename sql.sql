2.ְ����ְ���Ļ�����Ϣ��
��2 ְ����Ϣ��Employee
����	��������	����	����	����
Eno	char	8	����	Ա�����
Ename	varchar	10	������Ϊ��	Ա������
Esex	varchar	8	������Ϊ��	�Ա�
Ebirth	Date		������Ϊ��	��������
Eduty	varchar	20	������Ϊ��	ְ��
Eedu	varchar	8	������Ϊ��	ѧ��
Etel	varchar	15	������Ϊ��	�绰����
Eaddr	varchar	20	������Ϊ��	סַ
Eid	varchar	20	������Ϊ��	���֤����
Dno	char	4		���ű��
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

alter table employee add constraint C1 check(Esex in ('��','Ů'));
3.���ű����Ż�����Ϣ��
                      ��3 ������Ϣ��Department
����	��������	����	����	����
Dno	char	4	����	���ź�
Dname	varchar	10	�������	������
Dboss	char	8	�������	�����ܹ�

create table Department(
Dno char(8) primary key,
Dname varchar(10) not null,
Dboss varchar(10) not null,
);

5.���ڱ���¼Ա���ĵ�ְ�����
                    ��5 ����ͳ�Ʊ�attendance
����	��������	����	����	����
Eno	Char	8	����	Ա����
Atime	Date		����	��������
Aovertime	Int	6	������Ϊ��	�Ӱ�ʱ��
Akuang	Int	6	������Ϊ��	��������
Alate	Int	6	������Ϊ��	�ٵ�����

create table attendance(
Eno char(8),
Atime int ,
Aovertime int not null,
Akuang int not null,
Alate int not null,
primary key(Eno,Atime)
);
   6.���ʱ���¼�����������Ĺ��ʡ�
                    ��6 ���ʱ�Salary
����	��������	����	����	����
Eno	char	8	����	Ա�����
Stime	date		����	��������
Sbase	decimal	8,2	�������	��������
Sallowance	decimal	8,2	�������	����
Sreward	decimal	8,2	�������	����

create table Salary(
  Eno char(8),
	Stime date,
	Sbase decimal(10,2) not null,
	Sallowance decimal(10,2) not null,
	Sreward decimal(10,2) not null,
	primary key(Eno,Stime)
);
Ա���û�����¼Ա���û���������
               Ա���û���Euser
����	��������	����	����	����
Eno	char	8	����	Ա�����
Epassword	varchar	32	������Ϊ��	����

create table Euser(
Eno char(8)primary key,
Epassword varchar(32)
);

�����û�����¼�����û���������
               �����û���Muser
����	��������	����	����	����
Eno	char	8	����	Ա�����
Mpassword	varchar	32	������Ϊ��	����

create table Muser(
Eno char(8)primary key,
Mpassword varchar(32)
);

���۱�
Deduction
����	��������	����	����	����
Eno	char	8	����	Ա�����
Dtime	date		����	�۳�����
Insur	decimal	8,2		����
Tax	deciaml	8,2		˰

Create table Deduction(
Eno char(8),
Dtime date,
Insur decimal(8,2),
Tax decimal(8,2),
Primary key(Eno,Dtime)
);





��������ɾ��Ա����Ԫ���Զ����������ڱ����ʱ����۱�������ͼ����Eno��ͬ��Ԫ��
DELIMITER //
Create trigger e_t after delete on employee for each row begin delete from attendance where Eno=old.Eno;
	delete from salary where Eno=old.Eno;	delete from euser where Eno=old.Eno;
	delete from muser where Eno=old.Eno;	delete from deduction where Eno=old.Eno;end
 //
DELIMITER ;





������ͼ
create view salary_v(����,����,ʱ��,��������,����,����,Ӧ�ù���,�Ӱ�ʱ��,��������,�ٵ�����,����,˰,ʵ�ʹ���)as select Ename ,salary.Eno,DATE_FORMAT(Stime,'%Y%m'),Sbase,Sallowance,Sreward,round(Sbase+Sallowance+Sreward,2),Aovertime,Akuang,Alate,
round((Sbase+Sallowance+Sreward)*0.1,2),
round((Sbase+Sallowance+Sreward+Aovertime*(Sbase/30/8*2)-Akuang*(Sbase/30)-Alate*100-(Sbase+Sallowance+Sreward)*0.1)*0.05,2),
round((Sbase+Sallowance+Sreward+Aovertime*(Sbase/30/8*2)-Akuang*(Sbase/30)-Alate*100)-(Sbase+Sallowance+Sreward)*0.1-(Sbase+Sallowance+Sreward+Aovertime*(Sbase/30/8*2)-Akuang*(Sbase/30)-Alate*100-(Sbase+Sallowance+Sreward)*0.1)*0.05,2)
from salary,attendance ,employee where salary.Eno=attendance.Eno and salary.Eno=employee.Eno and DATE_FORMAT(Stime,'%Y%m')=DATE_FORMAT(Atime,'%Y%m');



�洢���̣�
������̣��ڲ��뿼�ڱ����ʱ���Ϣ֮����ã�����ΪԱ���ţ�ʱ��
 ����call in_deduction(20180001,20180909)
�ù������ڽ���ͼ�еġ����ա��͡�˰����ֵ���뵽deduction����
DELIMITER //
create procedure in_deduction(in Eno_in char(8),in time_in date)
begin
  insert into deduction(Eno,Dtime,insur,tax) select Eno,Stime,����,˰ from salary_v,salary where Eno=Eno_in and Stime=time_in and ʱ��=DATE_FORMAT(time_in,'%Y%m') and Eno_in=����;
end
//
DELIMITER ;


���¹��̣��ڸ��¿��ڱ����ʱ���Ϣ֮����ã�����ΪԱ���ţ�ʱ�� ����call update_deduction(20180001,20180909)
�ù������ڽ���ͼ�еġ����ա��͡�˰����ֵ��deduction���и���



DELIMITER //
create procedure update_deduction(in Eno_in char(8),in time_in date)
begin
     declare tax_t decimal(8,2);
		 declare insur_t decimal(8,2);
		 set insur_t=(select ���� from salary_v where ����=Eno_in and ʱ��=DATE_FORMAT(time_in,'%Y%m'));
		 set tax_t=(select ˰ from salary_v where ����=Eno_in and ʱ��=DATE_FORMAT(time_in,'%Y%m'));
		 update deduction set insur=insur_t,tax=tax_t where Eno=Eno_in and Dtime=time_in;
end //
DELIMITER ;
