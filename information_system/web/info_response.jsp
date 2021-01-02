<%@ page import="ifmo.Person" %>
<%@ page import="java.util.ArrayList" %>
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
        <a class="active" href="./information_about_participant.jsp">Back</a>
    </div>
</header>
<body>

<div class="left">
   <img src="images/acc-icon-2-1-300x300.png" width="400px">
</div>

<table align="right" class="block content" id = responsesTable style="margin-top: 110px; width: 700px" >
    <tr><td>First name</td><td>Last name</td><td>Birth date</td></tr>
    <%
        ArrayList<Person> list = (ArrayList)config.getServletContext().getAttribute("list");
        for(int i = 0; i < list.size(); i++) {
    %>
    <tr>
        <td><%=list.get(i).first_name%></td>
        <td><%=list.get(i).last_name%></td>
        <td><%=list.get(i).birth_date%></td>

    </tr>

    <%
        }
    %>
</table>
</body>
</html>
