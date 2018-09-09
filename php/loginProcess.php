<?php
session_start();
require_once 'MysqlTools.php';
$mysqlTools = new MysqlTools();
$account = $_POST['account'];
$password = $_POST['password'];

//对登陆进行验证
function check($account,$password)
{
    global $mysqlTools;
    $query = "SELECT password FROM Student WHERE account='{$account}'";
    $result = $mysqlTools->executeDQL($query);

    if ($password == $result['password'])
    {
        session_start();
        $_SESSION['account'] = $account;
        $_SESSION['password'] = $password;
        header("Location:../salary.html");
    } else
        {
            echo "<script>top.alert('用户名或密码不正确！');
                            location.assign('php/login.html');</script>";
            exit();
        }
}

if(empty($account) || empty($password))
{
    echo "<script>alert('账户或密码不能为空!');
                    top.location.href='php/login.html';</script>";
    exit();
}
else
{
    check($account, $password);
}





