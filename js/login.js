window.onload = function(){
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

};
