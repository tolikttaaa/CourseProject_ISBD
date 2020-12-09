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
        <a href="./index.jsp">Home</a>
        <a href="register_person.jsp">For All</a>
        <a href="./championships.jsp">Championships</a>
        <a href="./information_about_participant.jsp">Info</a>
        <a class="active" href="./results.jsp">Results</a>
        <a href="./about_us.jsp">About Us</a>
    </div>
</header>
<body>
<div class="content-container container left" style="width: 700px; margin-left: 15px">
    <form method="post" action="control">
        <div class="control-points block region">
            <p class="subtitle_form"> Get results of championship</p>

            <p>
                <select class="reg_text_in_form" id="result_championship_id" type="text" name="result_championship_id" style="width: 690px">  <!--Supplement an id here instead of using 'name'-->
                    <option value="0" selected>Select championship id</option>
                    <option value="1" >1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
            </p>


            <div class="block invisible" id="start-championship-errors-area"
                 style="box-shadow: none; border: 2px solid crimson"></div>
            <div class="block invisible" id="start-championship-errors-area-canvas"
                 style="box-shadow: none; border: 2px solid crimson"></div>


            <div>
                <button class="region" type="submit" id="start-championship-submit-button">Start
                    championship
                </button>


            </div>
        </div>
    </form>
</div>
<table align="right" class="block content" id = responsesTable style="margin-top: 110px; width: 700px" >
    <tr><td>Place</td><td>Team name</td><td>Score</td><td>Award</td></tr>
    <%--    <%--%>
    <%--    ArrayList<Participant> list = (ArrayList)config.getServletContext().getAttribute("list");--%>
    <%--   for(int i = 0; i < list.size(); i++) {--%>
    <%--%>--%>
    <tr>
        <%--        <td><%=list.get(i).first_name%></td>--%>
        <%--        <td><%=list.get(i).last_name%></td>--%>
        <%--        <td><%=list.get(i).birth_date%></td>--%>

    </tr>

    <%--    <%--%>
    <%--        }--%>
    <%--    %>--%>
</table>
</body>
</html>
