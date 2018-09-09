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
            $sex = '男';
        }
        else $sex = '女';
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
        course('jsj002', '程序设计基础');
        course('jsj003','数据结构');
        course('jsj004','离散数学');
        course('jsj005','线性代数');
        course('jsj006','计算机组成原理');
        course('jsj007','计算机网络');
        course('jsj008','数据库系统');
        course('jsj009','操作系统');
    } catch(Exception $exception){
        echo $exception->getMessage();
    }
    echo 'success！';