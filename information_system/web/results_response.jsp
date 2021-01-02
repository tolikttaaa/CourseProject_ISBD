<%@ page import="java.util.ArrayList" %>
<%@ page import="ifmo.Championship" %>
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
        <a class="active" href="./results.jsp">Back</a>
    </div>
</header>
<body>

<div class="left">
    <img src="images/acc-icon-2-1-300x300.png" width="400px">
</div>

<table align="right" class="block content" id = responsesTable style="margin-top: 110px; width: 700px" >
    <tr><td>Place</td><td>Team name</td><td>Score</td><td>Award</td></tr>
    <%
        ArrayList<Championship> list = (ArrayList)config.getServletContext().getAttribute("list");
       for(int i = 0; i < list.size(); i++) {
    %>
    <tr>
                <td><%=list.get(i).place%></td>
                <td><%=list.get(i).team_name%></td>
                <td><%=list.get(i).score%></td>
                <td><%=list.get(i).award%></td>

    </tr>

        <%
            }
        %>
</table>
</body>
</html>