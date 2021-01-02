<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Course Project</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

</head>
<header>
    <%@include file="navigation.jsp" %>
    <div class="topnav">
        <a href="./register_person.jsp">Sign up</a>
        <a class="active" href="./login.jsp">Sign in</a>
    </div>
</header>
<body>

<div class="content-container container left" style="width: 700px; margin-left: 15px; align-items: center">
    <form method="post" action="./Login">
        <div class="control-points block region">

            <div>
                <p class="reg_text_in_form"><label for="login"> Email: </label></p>
                <p><input style="width: 690px" class="reg_text_in_form" id="login" type="text"
                          name="login"><br></p>
            </div>
            <div>
                <p class="reg_text_in_form"><label for="password"> Last name: </label></p>
                <p><input style="width: 690px" class="reg_text_in_form" id="password" type="text"
                          name="password"><br></p>
            </div>


            <div class="block invisible" id="login-errors-area"
                 style="box-shadow: none; border: 2px solid crimson"></div><br>

            <div>
                <button class="region" type="submit" id="login-submit-button"
                        onclick="window.location='index.jsp';"> Sign in
                </button>

            </div>

        </div>
    </form>

</div>
<img src="images/globe.png" style=" width: 600px" class = "picture right">
</body>
</html>
