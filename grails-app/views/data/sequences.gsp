<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Sequences sunburst</title>
    <script src="/bdo/static/js/lib/d3/d3.v3.min.js"></script>
    <script src="/bdo/static/js/lib/jquery/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css"
      href="https://fonts.googleapis.com/css?family=Open+Sans:400,600">
    <link rel="stylesheet" type="text/css" href="sequences.css"/>
    <style type="text/css">
    body {
  font-family: 'Open Sans', sans-serif;
  font-size: 12px;
  font-weight: 400;
  background-color: #fff;
  width: 860px;
  height: 700px;
  margin-top: 10px;
}

#main {
  float: left;
  width: 750px;
}

#sidebar {
  float: right;
  width: 100px;
}

#sequence {
  width: 600px;
  height: 70px;
}

#legend {
  padding: 10px 0 0 3px;
}

#sequence text, #legend text {
  font-weight: 600;
  fill: #fff;
}

#chart {
  position: relative;
}

#chart path {
  stroke: #fff;
}

#explanation {
  position: absolute;
  top: 260px;
  left: 305px;
  width: 140px;
  text-align: center;
  color: #666;
  z-index: -1;
}

#percentage {
  font-size: 2.5em;
}
#result{
    font-weight:bold;
}
    </style>
  </head>
  <body>
    <div id="main">
      <div id="sequence"></div>
      <div id="chart">
        <div id="explanation">
          <span id="percentage">100%</span><br/>
          Sales Efforts flow like this with result of <br/>
          <span id="result"></span>
        </div>
      </div>
    </div>
    <div id="sidebar">
      <!--<input type="checkbox" id="togglelegend"> Legend<br/>-->
      <div id="legend"></div>
    </div>


    <script type="text/javascript" src="/bdo/static/js/lib/d3/sequences.js"></script>
    <script type="text/javascript">
      

  </script> 
  </body>
</html>