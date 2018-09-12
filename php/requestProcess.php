<?php
header('Content-Type:application/json;charset=UTF-8');
    require_once 'MysqlTools.php';
    $mysqlTools = new MysqlTools();
    session_start();
    $method = null;
    $tableName = null;

    if(!empty($_GET['method']) && !empty($_GET['tableName'])){
        $method = $_GET['method'];
        $tableName = $_GET['tableName'];
    }

    if(!empty($_POST['method']) && !empty($_POST['tableName'])){
        $method = $_POST['method'];
        $tableName = $_POST['tableName'];
    }

    switch($method){
        case 'getTableHead':
           echo json_encode($mysqlTools->executeDQL("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{$tableName}'"));
           break;
        case 'getContent':
           echo json_encode($mysqlTools->executeDQL("SELECT * FROM {$tableName}"));
           break;
        case 'deleteData':
            if(batchDelete()){
                echo json_encode("true");
            }else{
                echo json_encode("false");
            }
            break;
        case 'login':
            if(!empty($_POST['Eno']) && !empty($_POST['Mpassword'])){
                if(check($_POST['Eno'], $_POST['Mpassword'])){
                    echo json_encode("ture");
                }else{
                    return json_encode("false");
                }
            }
            break;
        case 'alterData':
            if(alterDataFun()){
                echo json_encode(true);
            }else{
                echo json_encode(false);
            }
            break;
        case 'addData':
            if(addDataFun()){
                echo json_encode(true);
            }else{
                echo json_encode(false);
            }
            break;
        case 'getRow':
            echo json_encode(getRowFun());
            break;
        default:
           echo Json_encode("nothing");
           break;
       }

function alterDataFun()
{
    global $mysqlTools;
    global $tableName;
    $queryStr = "UPDATE" . $tableName . "SET";
    if ($tableName == "salary") {
        $queryStr .= "Sbase={$_POST['Sbase']}, Sallowance={$_POST['Sallowance']},
        Sreward={$_POST['Sreward']} where Eno={$_POST['Eno']} and Stime={$_POST['Stime']}";
    } elseif ($tableName == "employee") {
        $queryStr .= "Ename={$_POST['Ename']}, Esex={$_POST['Esex']}, Ebirth={$_POST['Ebirth']},
        Eduty={$_POST['Eduty']}, Eedu={$_POST['Eedu']}, Etel={$_POST['Etel']},Eadr={$_POST['Eadr']},
        Eid={$_POST['Eid']},Dno={$_POST['Dno']}, WHERE Eno={$_POST['Eno']}";
    } elseif ($tableName == "attendance") {
        $queryStr .= "Atime={$_POST['Atime']}, Aovertime={$_POST['Aovertime']},
        Akuang={$_POST['Akuang']}, Alate={$_POST['Alate']} WHERE Eno={$_POST['Eno']} AND Atime={$_POST['Atime']}";
    }

    if ($mysqlTools->executeDML($queryStr)) {
        $query = "";
        if ($tableName == "salary") {
            $query = "CALL UPDATE_DEDUCTION({$_POST['Eno']}, {$_POST['Stime']})";
        } elseif ($tableName == "attendance") {
            $query = "CALL UPDATE_DEDUCTION({$_POST['Eno']},{$_POST['Atime']})";
        }
        if ($mysqlTools->executeDML($query)) {
            return true;
        } else {
            return false;
        }
    }
}

function addDataFun()
{
    global $mysqlTools;
    global $tableName;
    $queryStr = "INSERT INTO" . $tableName . "VALUES(";
    if ($tableName == "salary") {
        $queryStr .= "{$_POST['Sbase']},{$_POST['Sallowance']},
      {$_POST['Sreward']})";
    } elseif ($tableName == "employee") {
        $queryStr .= "{$_POST['Eno']},{$_POST['Ename']},{$_POST['Esex']},{$_POST['Ebirth']},
        {$_POST['Eduty']},{$_POST['Eedu']},{$_POST['Etel']},{$_POST['Eadr']},
        {$_POST['Eid']},{$_POST['Dno']})";
    } elseif ($tableName == "attendance") {
        $queryStr .= "{$_POST['Eno']},{$_POST['Atime']}, {$_POST['Aovertime']},
        {$_POST['Akuang']},{$_POST['Alate']}";
    }

    if ($mysqlTools->executeDML($queryStr)) {
        $query = "";
        if ($tableName == "salary") {
            $query = "CALL UPDATE_DEDUCTION({$_POST['Eno']}, {$_POST['Stime']})";
        } elseif ($tableName == "attendance") {
            $query = "CALL UPDATE_DEDUCTION({$_POST['Eno']},{$_POST['Atime']})";
        }
        if ($mysqlTools->executeDML($query)) {
            return true;
        } else {
            return false;
        }
    }
}


function getRowFun(){
        global $mysqlTools;
        global $tableName;
        if(!empty($_GET['primaryKey'])){
            $primaryKey =$_GET['primaryKey'];
            $primaryKeyValue = $_GET[$primaryKey];
            $query = "SELECT * FROM {$tableName} WHERE {$primaryKey} = {$primaryKeyValue}";
            return $mysqlTools->executeDQL($query);
        }else{
            return false;
        }
}

function batchDelete(){
    global $mysqlTools;
    global $tableName;
    $index = 0;
    $deleteDataIndex = "deleteData" . $index;
    if(!empty($_POST['primaryKey'])) {
        $primaryKey = $_POST['primaryKey'];
        while (!empty($_POST[$deleteDataIndex])) {
            if ($mysqlTools->executeDML("DELETE FROM {$tableName} WHERE {$primaryKey} = {$_POST[$deleteDataIndex]}")) {
                ++$index;
                $deleteDataIndex = "deleteData" . $index;
            } else {
                return false;
            }
        }
    }else{
        return "没有主键值";
    }
    return true;
}

function check($account, $password)
{
    global $mysqlTools;
    global $tableName;
    $query = "SELECT Mpassword FROM {$tableName} WHERE Eno='{$account}'";
    $result = $mysqlTools->executeDQL($query);

    if ($password == $result[0]['Mpassword'])
    {
        //session_start();
        $_SESSION['account'] = $account;
        $_SESSION['password'] = $password;
        return true;
    } else {
        return false;
    }
}

function getColumnName(){
    global $mysqlTools;
    global $tableName;
    $query = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{$tableName}'";
    $colName = $mysqlTools->executeDQL($query);
    $queryStr = "";
    for($i = 0; $i < count($colName); ++$i){
        $queryStr .= $colName[$i]['COLUMN_NAME'] . "=" . $_POST[$colName[$i]['COLUMN_NAME']];
    }
    return $queryStr;
}




