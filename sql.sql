//�������ݿⲢѡ�� 
CREATE DATABASE homework; 
USE homework;

//����student��course���ű�
CREATE TABLE student(id TINYINT UNSIGNED AUTO_INCREMENT,
		account VARCHAR(8) NOT NULL,
		password VARCHAR(8) NOT NULL,
		sex VARCHAR(8) NOT NULL,
		courseId VARCHAR(8) NOT NULL,
		PRIMARY KEY(id));

CREATE TABLE course(courseId VARCHAR(8),
		courseName VARCHAR(16) NOT NULL,
		PRIMARY KEY(courseId));


//�����ݿ���������(��������)
//��������������ʹ��php�ű���executeDML.php
INSERT INTO student VALUES(default,'admin','root','��','jsj001');

INSERT INTO course VALUES('jsj001','����������');


<?php
require_once 'MysqlTools.php';
$mysqlTools = new MysqlTools();
function student()
{
    global $mysqlTools;
    for($i = 200;$i < 350; ++$i)
    {
        $account = 's'.$i;
        $password = $i;
        $sex = '';
        if($i % 2 == 0)
        {
            $sex = '��';
        }
        else $sex = 'Ů';
        $courseId = 'jsj00'.mt_rand(2, 9);
        $statement = "INSERT INTO student VALUES(DEFAULT,'{$account}','{$password}','{$sex}','{$courseId}')";
        $mysqlTools->executeDML($statement);
    }
}

function course($courseId, $courseName)
{
    global $mysqlTools;
        $statement = "INSERT INTO course VALUES('{$courseId}','{$courseName}')";
        $mysqlTools->executeDML($statement);
}
    try{
        student();
        course('jsj002', '������ƻ���');
        course('jsj003','���ݽṹ');
        course('jsj004','��ɢ��ѧ');
        course('jsj005','���Դ���');
        course('jsj006','��������ԭ��');
        course('jsj007','���������');
        course('jsj008','���ݿ�ϵͳ');
        course('jsj009','����ϵͳ');
    } catch(Exception $exception){
        echo $exception->getMessage();
    }
    echo 'success��';

?>
