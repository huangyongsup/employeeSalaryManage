<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的空间</title>
    <link rel = "stylesheet" href = "css/style.css">
    <script type = "text/javascript" src = "js/myhome.js"></script>
    <style>
        body{
            background:#FDF6E3;
        }
    </style>
</head>
<body>
<?php
    session_set_cookie_params(30);
    session_start();
    if(empty($_SESSION['account']))
    {
        session_destroy();
        echo "<script>top.alert('请先登录！');
                       location.assign('login.html');</script>";
    }
    date_default_timezone_set('PRC');
    $currentTime = date('Y-m-d H:i:s');
?>
    <div>
            <ul>
                <li id="time">当前系统时间：<?php echo $currentTime; ?> </li>
                <li><span id="account"><?php echo $_SESSION['account']; ?></span>&nbsp;欢迎您来到您的空间</li>
                <li>您的密码是：<span><?php echo $_SESSION['password']; ?></span></li>
            </ul>
    </div>
    <div id="homeBody">
        我所选的课程：
    </div>
    <div id="homeFooter">
        <button id="query">查询</button>
        <button id="signOut">退出</button>
    </div>
</body>
</html>
