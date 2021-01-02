<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Course Project</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="css/styles.css" rel="stylesheet" type="text/css">
</head>
<header>
    <%@include file="navigation.jsp" %>
    <div class="topnav">
        <a class="active" href="./register_person.jsp">Sign up</a>
        <a href="./login.jsp">Sign in</a>
    </div>
</header>
<body>

<div class="left">
<div class="content-container container">
    <form method="post" action="./InsertData">
        <div class="control-points block region">
            <p class="subtitle_form"> Registration</p>
<div style="color: #808080; font-family: Arial, Helvetica, sans-serif">
            <div>
                <p class="reg_text_in_form"><label for="first_name"> First name: </label></p>
                <p><input style="width: 690px" class="reg_text_in_form" id="first_name" type="text"
                          name="first_name"><br></p>
            </div>
            <div>
                <p class="reg_text_in_form"><label for="last_name"> Last name: </label></p>
                <p><input style="width: 690px" class="reg_text_in_form" id="last_name" type="text"
                          name="last_name"><br></p>
            </div>
            <div>
                <p class="reg_text_in_form"><label for="phone_number"> Phone number: </label></p>
                <p><input style="width: 690px" class="reg_text_in_form" id="phone_number" type="text"
                          name="phone_number"><br></p>
            </div>
            <div>
                <p class="reg_text_in_form"><label for="email"> Email address: </label></p>
                <p><input style="width: 690px" class="reg_text_in_form" id="email" type="text"
                          name="email" width="400px"><br></p>
            </div>

            <div>
                <p class="reg_text_in_form"><label for="birth_date"> Birth date: </label></p>
                <p><input style="width: 690px" class="reg_text_in_form" id="birth_date" type="date"
                          name="birth_date"><br></p>
            </div>
            <div>
                <p><input id="admin_role" type="checkbox"
                          name="admin_role" width="400px" value="admin"> Apply as administrator
                    <br></p>
            </div>
            </div>
            <div class="block invisible" id="person-errors-area"
                 style="box-shadow: none; border: 2px solid crimson"></div>
            <div class="block invisible" id="person-errors-area-canvas"
                 style="box-shadow: none; border: 2px solid crimson"></div>


            <div>
                <button class="region" type="submit" id="person-submit-button">Submit</button>

            </div>
        </div>
    </form>
</div>
</div>
<div class="right"><img src="images/OnCampusTimeline-01-1434x4000.png" height="800px" class="picture"></div>
</body>
</html>
