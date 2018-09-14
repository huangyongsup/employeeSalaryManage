const signOut = document.getElementById("signOut");
const url = "php/requestProcess.php";
const tableName = "none";
const navCol = document.getElementById("navCol");

(function(){
    let currentURL = addURLParam(url, "method", "isLogin");
    currentURL = addURLParam(currentURL, "tableName", tableName);
    let jsonResult = JSON.parse(getRequest(currentURL));
    if(jsonResult === "unloaded"){
        location.assign("login.html");
    }
})();

navCol.onclick = function(event){
    for(let i of event.target.parentElement.parentElement.children){
        i.firstChild.classList.remove("extra");
    }
    event.target.classList.add("extra");
};

signOut.addEventListener("click", function(){
    let msg = "确定退出登陆吗？";
    if(confirm(msg) === true){
        if(signOutRequest()){
            location.assign("login.html");
        }else{
            alert("退出失败");
        }
    }
}, false);

function signOutRequest(){
    let currentURL = addURLParam(url, "method", "signOut");
    currentURL = addURLParam(currentURL, "tableName", tableName);
    if(JSON.parse(getRequest(currentURL)) === "session had been destroyed"){
        return true;
    }else{
        return false;
    }
}

function addURLParam(url, name, value){
    url += (url.indexOf("?") === -1 ? "?" : "&");
    url += encodeURIComponent(name) + "=" + encodeURIComponent(value);
    return url;
}

function getRequest(url){
    let xhr = new XMLHttpRequest();
    xhr.open("get", url, false);
    xhr.send(null);
    if(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304){
        return xhr.responseText;
    }else{
        return false;
    }
}