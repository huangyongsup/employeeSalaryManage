window.onload = function(){
    const form = document.forms[0];
    const tableName = "muser";
    const url = "php/requestProcess.php";
    let account = document.getElementById("account");
    let password = document.getElementById("password");
    let submit = document.getElementById("submit");
    account.focus();
    account.onblur = function(){
        let account = document.getElementById("account");
        let accountValue = account.value.replace(/(^\s*)|(\s*$)/g, "");
        if(accountValue === ""){
            account.focus();
            account.placeholder = "请输入用户名！";
        }
    };

    password.onblur = function(){
        let password = document.getElementById("password");
        let passwordValue = password.value.replace(/(^\s*)|(\s*$)/g, "");
        if(passwordValue === ""){
            password.focus();
            password.placeholder = "请输入密码！";
        }
    };

    submit.onclick = function(event){
        let accountValue = document.getElementById("account").value.replace(/(^\s*)|(\s*$)/g, "");
        let passwordValue = document.getElementById("password").value.replace(/(^\s*)|(\s*$)/g, "");
        if(accountValue === "" || passwordValue === ""){
            alert("用户名或密码不能为空");
            event.preventDefault();
            location.assign("login.html");
        }
    };

    form.addEventListener("submit", function(event){
        event.preventDefault();
        let currentURL = addURLParam(url, "method", "login");
        currentURL = addURLParam(currentURL, "tableName", tableName);
        let result = JSON.parse(postRequest(currentURL, serialize(form)));
        if(result === "manager"){
            location.assign("main.html");
        }else if(result === "employee"){
            location.assign("employeeMain.html");
        } else{
            alert("登陆失败，请稍后再试");
        }
    },false);

    function addURLParam(url, name, value){
        url += (url.indexOf("?") === -1 ? "?" : "&");
        url += encodeURIComponent(name) + "=" + encodeURIComponent(value);
        return url;
    }

    function postRequest(url, postData){
        let xhr = new XMLHttpRequest();
        xhr.open("post", url, false);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send(postData);
        if(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304){
            return xhr.responseText;
        }else{
            return false;
        }
    }

    function serialize(form){
        let parts = [];
        for(let i = 0, len = form.elements.length; i < len; ++i){
            let field = form.elements[i];
            switch(field.type){
                case "select-one":
                case "select-multiple":
                    if(field.name.length){
                        for(let j = 0, optLen = field.options.length; j < optLen; ++j){
                            let option = field.options[j];
                            if(option.selected){
                                let optValue = "";
                                if(option.hasAttribute){
                                    optValue = (option.hasAttribute("value") ?
                                        option.value : option.text);
                                }else{
                                    optValue = (option.attributes["value"].specified ?
                                        option.value : option.text);
                                }
                                parts.push(encodeURIComponent(field.name) + "=" +
                                    encodeURIComponent(optValue));
                            }
                        }
                    }
                    break;
                case undefined:
                case "file":
                case "submit":
                case "reset":
                case "button":
                    break;
                case "radio":
                case "checkbox":
                    if(!field.checked){
                        break;
                    }
                default:
                    if(field.name.length){
                        parts.push(encodeURIComponent(field.name) + "=" +
                            encodeURIComponent(field.value));
                    }
                    break;
            }
        }
        return parts.join("&");
    }


};
