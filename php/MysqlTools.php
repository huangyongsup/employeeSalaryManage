<?php

class MysqlTools
{
    private $pdo;
    private $username = 'root';
    private $password = 'root';
    private $dsn = 'mysql:host=localhost;dbname=homework';

    //构造函数
    function __construct()
    {
        $this->connect();
    }

    //连接数据库
    function connect()
    {
        try {
            $this->pdo = new PDO($this->dsn, $this->username, $this->password);
        } catch (PDOException $exception) {
            echo $exception->getMessage();
        }
    }

    //析构函数
    function __destruct()
    {
        $this->pdo = null;
    }

    //执行数据查询语言
    function executeDQL($query)
    {
        if ($result = $this->pdo->query($query)) {
            $arr = [];
            $i = 0;
            while($rows = $result->fetch(PDO::FETCH_ASSOC)){
                array_push($arr, $rows);
            }
            return $arr;
        }
    }

    //执行数据操作语言
    function executeDML($statement)
    {
        if($this->pdo->exec($statement))
        {
            return true;
        }
        else{
            return false;
        }
    }


}


