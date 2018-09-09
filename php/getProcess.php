<?php
header('Content-Type:application/json;charset=UTF-8');
    require_once 'MysqlTools.php';
    $mysqlTools = new MysqlTools();

    $method = null;
    $tableName = null;
    $batchNodeArr = null;

    if(!empty($_GET['method']) && !empty($_GET['tableName'])){
        $method = $_GET['method'];
        $tableName = $_GET['tableName'];
    }

//    if(!empty($_POST['batchNodeJson'])){
//        $batchNodeArr = Json_decode($_POST['batchNodeJson']);
//        //$method = $batchNodeArr[count($batchNodeArr)-1]["method"];
//        echo Json_encode($batchNodeArr);
//    }

    switch($method){
           case 'getTableHead':
               echo json_encode($mysqlTools->executeDQL("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{$tableName}'"));
               break;
           case 'getContent':
               echo json_encode($mysqlTools->executeDQL("SELECT * FROM {$tableName}"));
               break;
           default:
               echo Json_encode($_POST['batchNodeJson']);
               break;
       }







