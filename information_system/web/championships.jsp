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
        <a href="./index.jsp">Home</a>
        <a class="active" href="./championships.jsp">Championships</a>
        <a href="./information_about_participant.jsp">Info</a>
        <a href="./results.jsp">Results</a>
        <a href="./about_us.jsp">About Us</a>
    </div>
</header>
<body>
<div class="left">
            <div class="content-container container" style="width: 700px; margin-left: 15px">
                <form method="post" action="./StartChampionship">
                    <div class="control-points block region">
                        <p class="subtitle_form"> Start championship</p>

                        <p>
                            <select class="reg_text_in_form" id="start_championship_id" type="text" name="start_championship_id" style="width: 690px">  <!--Supplement an id here instead of using 'name'-->
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
</div>
<div class="right">
            <div class="content-container container" style="width: 700px; margin-left: 15px">
                <form method="post" action="./FinishChampionship">
                    <div class="control-points block region" style="text-align: left">
                        <p class="subtitle_form">  End championship</p>
                        <p>
                            <select class="reg_text_in_form" id="end_championship_id" type="text" name="end_championship_id" style="width: 690px">  <!--Supplement an id here instead of using 'name'-->
                                <option value="0" selected>Select championship id</option>
                                <option value="1" >1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                            </select>
                        </p>


                        <div class="block invisible" id="end-championship-errors-area"
                             style="box-shadow: none; border: 2px solid crimson"></div>
                        <div class="block invisible" id="end-championship-errors-area-canvas"
                             style="box-shadow: none; border: 2px solid crimson"></div>


                        <div>
                            <button class="region" type="submit" id="end-championship-submit-button">End
                                championship
                            </button>


                        </div>
                    </div>
                </form>

            </div>
</div>

</body>
</html>
