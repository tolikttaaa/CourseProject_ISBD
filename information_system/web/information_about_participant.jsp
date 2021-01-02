<%@ page import="ifmo.Person" %>
<%@ page import="java.util.ArrayList" %><%--<%@ page import="ifmo.Participant" %>--%>
<%--<%@ page import="java.util.ArrayList" %>--%>
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
        <a href="./championships.jsp">Championships</a>
        <a class="active" href="./information_about_participant.jsp">Info</a>
        <a href="./results.jsp">Results</a>
        <a href="./about_us.jsp">About Us</a>
    </div>
</header>
<body>
<div class="left">
    <div class="content-container container">
        <form method="post" action="./PersonalInfo">
            <div class="control-points block region">
                <p class="subtitle_form"> Search information about participant</p>
                <div style="color: #808080; width: 700px; font-family: Arial, Helvetica, sans-serif">
                    <div>
                        <p class="reg_text_in_form"><label for="search_last_name"> Last name: </label></p>
                        <p><input style="width: 690px" class="reg_text_in_form" id="search_last_name" type="text"
                                  name="search_last_name"><br></p>
                    </div>

                </div>
                <div class="block invisible" id="person-errors-area"
                     style="box-shadow: none; border: 2px solid crimson"></div>
                <div class="block invisible" id="person-errors-area-canvas"
                     style="box-shadow: none; border: 2px solid crimson"></div>


                <div>
                    <button class="region" type="submit" id="person-search-button">Search</button>

                </div>
            </div>
        </form>
    </div>
</div>

<%--<table align="right" class="block content" id = responsesTable style="margin-top: 110px; width: 700px" >--%>
<%--    <tr><td>First name</td><td>Last name</td><td>Birth date</td></tr>--%>
<%--    <%--%>
<%--    ArrayList<Person> list = (ArrayList)config.getServletContext().getAttribute("list");--%>
<%--   for(int i = 0; i < list.size(); i++) {--%>
<%--%>--%>
<%--    <tr>--%>
<%--        <td><%=list.get(i).first_name%></td>--%>
<%--        <td><%=list.get(i).last_name%></td>--%>
<%--        <td><%=list.get(i).birth_date%></td>--%>

<%--    </tr>--%>

<%--    <%--%>
<%--        }--%>
<%--    %>--%>
<%--</table>--%>
</body>
</html>
