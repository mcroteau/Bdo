<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<% def commonUtilities = grailsApplication.classLoader.loadClass('io.seal.common.CommonUtilities').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Salesman Dashboard</title>

</head>
<body>
	
	<g:if test="${flash.message}">
		<div class="alert alert-info" role="status">${raw(flash.message)}</div>
	</g:if>

        <style type="text/css">

            #chart-stats-container-outer{
                width:300px;
                text-align:center;
            }
            #chart-container{
                position:relative;
                margin-bottom:27px;
            }
            #chart-label{
                top:78px;
                left:17%;
                color:#c9c7c7;
                font-size:23px;
                width:200px;
                position:absolute;
            }
            #chart-stats-container{
                border-right:solid 1px #ddd;
            }
            .chart-stats{
                width:149px;
                text-align:center;
                border-top:solid 1px #ddd;
                border-bottom:solid 1px #ddd;
                border-left:solid 1px #ddd;
            }
            .chart-stats-total{
                font-size:32px;
                font-weight:bold;
                padding-left:10px;
            }
            .chart-stats-right{
                margin-left:10px;
                font-size:9px;
            }
            .chart-stats-name{
                color:#fff;
                padding:2px 7px;
            }
            .chart-percent-wrapper{
                text-align:center;
            }
            .chart-percent-sign{
                font-size:11px;
            }

            #divider{
                height:300px;
                margin-top:32px;
                margin-right:30px;
                border-left:solid 1px #ddd;
            }

            #sales-stats-outer-container{
                width:400px;
                margin-top:30px;
            }

            .sales-stats-container{
                margin-bottom:19px;
            }

            .sales-stats-left{
                width:260px;
                text-align:right;
                padding-right:15px;
            }
            .sales-stats-right{
                width:90px;
                text-align:left;
                color:#6c6b6b;
                font-size:12px;
                padding-top:6px;
            }

            .sales-stat-value{
                font-size:32px;
                font-weight:bold;
            }

            .sales-stat-dollar{
                font-size:13px;
                font-weight:normal;
            }

            .conversion-rate-container{
                margin-top:37px;
            }

            .conversion-rate,
            .conversion-rate-description{
                height:67px;
                border-radius: 3px;
                -moz-border-radius: 3px;
                -webkit-border-radius: 3px;
            }


            .conversion-rate{
                color:#fff;
                width:93px;
                font-size:31px;
                font-weight:bold;
                text-align:center;
                background:#3e809b;
                margin-left:27px;
                padding-top:10px;
            }
            .conversion-rate span{
                color:#fff;
                font-size:27px;
                font-weight:bold;
            }


            .conversion-rate-description{
                color:#fff;
                width:125px;
                font-size:13px;
                padding-top:13px;
                text-align:center;
                background:#105878;
                margin-left:12px;
            }
            #top-producing span{
                font-size:16px;
            }
            #dashboard-select{
                float-right;
                width:175px;
            }
            .salesman-stat{
                font-weight:bold;
            }
        </style>

    <h1 style="text-align:center;margin:10px auto 5px;background:#efefef; padding:20px;">
        Salesman Overview
        <select class="form-control" id="dashboard-select">
            <option value="ALL">All Data</option>
            <option value="SALESMAN" selected>Salesman Data</option>
        </select>
        <br class="clear"/>

        <h3 style="color:#777; text-align:center;margin:0px auto">${commonUtilities.getAuthenticatedAccount().nameEmail}</h3>
    </h1>

    <div id="date-selectors" style="text-align:center;display:block; padding:10px 20px; border:solid 0px #ddd;">
        <g:form controller="dashboard" action="index" method="get" class="range-form">
            <span class="secondary">
                Date Range :&nbsp;
            </span>
            <input type="text" name="startDate" id="start-date" class="form-control" value="${startDate}"/>
            &nbsp;
            <span class="secondary">to</span>
            &nbsp;
            <input type="text" name="endDate" id="end-date" class="form-control" value="${endDate}"/>
            <a href="javascript:" class="btn btn-default" id="refresh" title="${message(code:'refresh')}"><span class="glyphicon glyphicon-refresh"></span></a>
            <g:link controller="dashboard" action="index" params="[ allData : true ]" class="btn btn-default all-data">All Data</g:link>
        </g:form>
    </div>


    <div id="sales-stats-outer-container" class="pull-left">

        <div class="sales-stats-container">
            <div class="sales-stats-left sales-stat-value pull-left">
                ${data.salesActionsCount}
            </div>
            <div class="sales-stats-right pull-left">
                Actions<br/>Performed
            </div>
            <br class="clear"/>
        </div>


        <div class="sales-stats-container">
            <div class="sales-stats-left sales-stat-value pull-left">
                ${data.salesCount}
            </div>
            <div class="sales-stats-right pull-left">
                Sales
            </div>
            <br class="clear"/>
        </div>

        <div class="sales-stats-container">
            <div class="sales-stats-left sales-stat-value pull-left">
                <span class="sales-stat-dollar">$</span>
                ${data.salesTotal}
            </div>
            <div class="sales-stats-right pull-left">
                Sales<br/>Total
            </div>
            <br class="clear"/>
        </div>


        <div class="sales-stats-container">
            <div class="sales-stats-left sales-stat-value pull-left">
                <span class="sales-stat-dollar">$</span>
                ${data.averageSale}
            </div>
            <div class="sales-stats-right pull-left">
                Average<br/>Sale
            </div>
            <br class="clear"/>
        </div>


        <div class="conversion-rate-container" style="width:300px;margin-left:auto;margin-right:auto;">
            <div class="conversion-rate pull-left">
                ${data.conversionRate}<span>%</span>
            </div>
            <div class="conversion-rate-description pull-left">
                Conversion<br/>Rate
            </div>
            <br class="clear"/>
        </div>
    </div>


    <div id="divider" class="pull-left"></div>


	<div id="chart-stats-container-outer" class="pull-left">

        <div id="chart-container">
            <div id="chart-label">Sales Actions<br/>Break Down</div>
		    <canvas id="sales-actions-chart" height="240px" width="240px"></canvas>
        </div>



        <div id="chart-stats-container">
            <g:each in="${data.salesActions}" var="stats">
    			<div class="chart-stats pull-left">
    				<div class="chart-stats-left">
    					<span class="chart-stats-total">${stats.value}</span>
    				</div>
        				<div class="chart-stats-right">
        					<div class="chart-percent-wrapper chart-percent-top">
        						<span class="chart-percent">${stats.percent}</span>
        						<span class="chart-percent-sign">% of total</span>
        					</div>
        				</div>
                        <br class="clear"/>
                    <div class="chart-stats-name" style="background:${stats.color}">
                           ${stats.name}
                    </div>
    			</div>
            </g:each>
            <br class="clear"/>
        </div>

	</div>			    	


    <br class="clear"/>




<style type="text/css">

#main {
  float: left;
  width: 660px;
  position:relative;
}

#sidebar {
  float: right;
  width: 70px;
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

#sequences {
  position: relative;
}

#sequences path {
  stroke: #fff;
}

#explanation {
  position: absolute;
  top: 315px;
  left: 237px;
  width: 140px;
  text-align: center;
  color: #676767;
  z-index: 1000;
}

#percentage {
  font-size: 2.5em;
}
#result{
    font-weight:bold;
}
</style>

<h1 style="margin-top:70px;">Sales Efforts</h1>

<p style="margin:0px 0px 30px; font-size:16px;">Below is a break down of your Sales Actions for the given time span and the outcome. The outcomes are at the end of each starting point. At the top is the sequence break down with a percent of outcomes or sales actions</p>

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



<script type="text/javascript" src="${resource(dir:'js/lib/chartjs/Chart.js')}"></script>
	
<script type="text/javascript">

$(document).ready(function(){

    var $dashboardSelect = $("#dashboard-select")
    $dashboardSelect.change(function(event){
        var value = $dashboardSelect.val()
        if(value == "SALESMAN"){
            window.location = "/${applicationService.getContextName()}/dashboard"
        }else{
            window.location = "/${applicationService.getContextName()}/overview"
        }
    });

    var $startDate = $('#start-date'),
        $endDate = $('#end-date');
    
    //TODO:fix  
    $startDate.datepicker();
    $endDate.datepicker();


    var $refreshDataDiv = $('#refreshable-data'),
        $calculatingDiv = $('#calculating'),
        $form = $('.range-form');

    var $refreshBtn = $('#refresh'),
        $allDataBtn = $('.all-data');

    $allDataBtn.click(function(){
        $startDate.val("--")
        $endDate.val("--")
    })
        
    $refreshBtn.click(refreshData);

    function refreshData(){
        $refreshDataDiv.fadeOut(50);
        $calculatingDiv.fadeIn(50);
        $form.submit();
    }


    var startDate = $startDate.val(),
        endDate = $endDate.val()

            
    var data = [    
    	{
            value: ${data.mailers.value},
            color:"#70b4d2",
            highlight: "#599fbe",
            label: "Mailers"
        },
        {
            value: ${data.emails.value},
            color:"#70dc9d",
            highlight: "#5dc98a",
            label: "Emails"
        },
        {
            value: ${data.coldCalls.value},
            color: "#e25330",
            highlight: "#d44522",
            label: "Cold Calls"
        },
        {
            value: ${data.followUps.value},
            color: "#3e809b",
            highlight: "#2c6b85",
            label: "Follow Ups"
        },
        {
            value: ${data.meetings.value},
            color: "#105878",
            highlight: "#074865",
            label: "Meetings"
        },
        {
            value: ${data.demos.value},
            color: "#105878",
            highlight: "#074865",
            label: "Demos"
        }
    ]


    //background: #D2322D !important;
    //border:solid 1px #b3140f;

    var options = {
    	
        segmentShowStroke : true,
        segmentStrokeColor : "#f2f2f2",
        segmentStrokeWidth : 2,
        percentageInnerCutout : 76.5, 
        animationSteps : 20,
        animationEasing : "easeOutQuart",
        animateRotate : false,
        animateScale : false,

    	onAnimationComplete: function(){ },
    }

    var ctx = $("#sales-actions-chart").get(0).getContext("2d");

    var myDoughnutChart = new Chart(ctx).Doughnut(data, options);



    /**
        Beginning of Sequence Chart
    **/

    // Dimensions of sunburst.
    var width = 600;
    var height = 600;
    var radius = Math.min(width, height) / 2;

    // Breadcrumb dimensions: width, height, spacing, width of tip/tail.
    var b = {
      w: 57, h: 30, s: 3, t: 10
    };

    var colors = {
        "mailer" : "#3E7F9B",
        "coldcall": "#6fb3d1",
        "email": "#70DC9C",
        "followup": "#42B06E",
        "meeting": "#3E7F9B",
        "demo": "#105878",
        "sale": "#E25230",
        "prospect": "#BE8E12",
        "client": "#023348",
        "idle": "#BBBBBB",
        "saleseffort": "#3E7F9B",
        "imported": "#f8f8f8"
    }

    // Total size of all segments; we set this later, after loading the data.
    var totalSize = 0; 

    var svg = d3.select("#chart").append("svg:svg")
        .attr("width", width)
        .attr("height", height)
        .append("svg:g")
        .attr("id", "container")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

    var partition = d3.layout.partition()
        .size([2 * Math.PI, radius * radius])
        .value(function(d) { return d.size; });

    var arc = d3.svg.arc()
        .startAngle(function(d) { return d.x; })
        .endAngle(function(d) { return d.x + d.dx; })
        .innerRadius(function(d) { return Math.sqrt(d.y); })
        .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });

    // Use d3.text and d3.csv.parseRows so that we do not need to have a header
    // row, and can receive the csv as an array of arrays.
    //d3.text("http://localhost:9463/abcr/static/js/lib/d3/visit-sequences.csv", function(text) {
    //d3.text("http://localhost:9463/abcr/static/js/lib/d3/mock3-sequences.csv", function(text) {
    d3.text("/${applicationService.getContextName()}/data/salesman_sequences", function(text) {
      var csv = d3.csv.parseRows(text);
      var json = buildHierarchy(csv);
      createVisualization(json);


        var randomId = Math.floor(Math.random() * ids.length) + 0  

        var $id = $("#" + ids[1])
        $id.click()
        $id.d3Click();


        var paths = $("path")
        var randomPathIndex = Math.floor(Math.random() * paths.length) + 0
        var $path = $(paths[randomPathIndex])
        $path.click()
        $path.d3Click()
    });


    /**
        Main function to draw and set up the visualization, once we have the data.
    **/
    function createVisualization(json) {

      // Basic setup of page elements.
      initializeBreadcrumbTrail();
      drawLegend();
      
      // Bounding circle underneath the sunburst, to make it easier to detect
      // when the mouse leaves the parent g.
      svg.append("svg:circle")
          .attr("r", radius)
          .style("opacity", 0);

      // For efficiency, filter nodes to keep only those large enough to see.
      var nodes = partition.nodes(json)
          .filter(function(d) {
          return (d.dx > 0.005); // 0.005 radians = 0.29 degrees
          });

      var path = svg.data([json]).selectAll("path")
          .data(nodes)
          .enter().append("svg:path")
          .attr("id", function(d) { 
            return d.id; 
          })
          .attr("class", function(d) { 
            return d.clazz; 
          })
          .attr("display", function(d) { 
            return d.depth ? null : "none"; 
            })
          .attr("d", arc)
          .attr("fill-rule", "evenodd")
          .style("fill", function(d) { return colors[d.name]; })
          .style("opacity", 1)
          .on("mouseover", mouseover)
          .on("click", mouseover)



      // Add the mouseleave handler to the bounding circle.
      d3.select("#container").on("mouseleave", mouseleave);


      // Get total size of the tree = value of root node from partition.
      totalSize = path.node().__data__.value;

     };


    // Fade all but the current sequence, and show it in the breadcrumb trail.
    function mouseover(d) {

      var percentage = (100 * d.value / totalSize).toPrecision(3);
      var percentageString = percentage + "%";
      if (percentage < 0.1) {
        percentageString = "< 0.1%";
      }

      d3.select("#percentage")
          .text(percentageString);

      d3.select("#explanation")
          .style("visibility", "");

        d3.select("#result").text(d.name)


      var sequenceArray = getAncestors(d);
      updateBreadcrumbs(sequenceArray, percentageString);

      // Fade all the segments.
      d3.selectAll("path")
          .style("opacity", 0.3);

      // Then highlight only those that are an ancestor of the current segment.
      svg.selectAll("path")
          .filter(function(node) {
                    return (sequenceArray.indexOf(node) >= 0);
                  })
          .style("opacity", 1);
    }



    // Restore everything to full opacity when moving off the visualization.
    function mouseleave(d) {

      // Hide the breadcrumb trail
      d3.select("#trail")
          .style("visibility", "hidden");

      // Deactivate all segments during transition.
      d3.selectAll("path").on("mouseover", null);

      // Transition each segment to full opacity and then reactivate it.
      d3.selectAll("path")
          .transition()
          .duration(1000)
          .style("opacity", 1)
          .each("end", function() {
                  d3.select(this).on("mouseover", mouseover);
                });

      d3.select("#explanation")
          .style("visibility", "");



      d3.select("#percentage")
          .text("100%");
    }

    // Given a node in a partition layout, return an array of all of its ancestor
    // nodes, highest first, but excluding the root.
    function getAncestors(node) {
      var path = [];
      var current = node;
      while (current.parent) {
        path.unshift(current);
        current = current.parent;
      }
      return path;
    }

    function initializeBreadcrumbTrail() {
      // Add the svg area.
      var trail = d3.select("#sequence").append("svg:svg")
          .attr("width", width)
          .attr("height", 40)
          .attr("id", "trail");
      // Add the label at the end, for the percentage.
      trail.append("svg:text")
        .attr("id", "endlabel")
        .style("fill", "#000");
    }

    // Generate a string that describes the points of a breadcrumb polygon.
    function breadcrumbPoints(d, i) {
      var points = [];
      points.push("0,0");
      points.push(b.w + ",0");
      points.push(b.w + b.t + "," + (b.h / 2));
      points.push(b.w + "," + b.h);
      points.push("0," + b.h);
      if (i > 0) { // Leftmost breadcrumb; don't include 6th vertex.
        points.push(b.t + "," + (b.h / 2));
      }
      return points.join(" ");
    }

    // Update the breadcrumb trail to show the current sequence and percentage.
    function updateBreadcrumbs(nodeArray, percentageString) {

      // Data join; key function combines name and depth (= position in sequence).
      var g = d3.select("#trail")
          .selectAll("g")
          .data(nodeArray, function(d) { return d.name + d.depth; });

      // Add breadcrumb and label for entering nodes.
      var entering = g.enter().append("svg:g");

      entering.append("svg:polygon")
          .attr("points", breadcrumbPoints)
          .style("fill", function(d) { return colors[d.name]; });

      entering.append("svg:text")
          .attr("x", (b.w + b.t) / 2)
          .attr("y", b.h / 2)
          .attr("dy", "0.35em")
          .attr("text-anchor", "middle")
          .style("font-size", "12px")
          .text(function(d) { return d.name; });

      // Set position for entering and updating nodes.
      g.attr("transform", function(d, i) {
        return "translate(" + i * (b.w + b.s) + ", 0)";
      });

      // Remove exiting nodes.
      g.exit().remove();

      // Now move and update the percentage at the end.
      d3.select("#trail").select("#endlabel")
          .attr("x", (nodeArray.length + 0.5) * (b.w + b.s))
          .attr("y", b.h / 2)
          .attr("dy", "0.35em")
          .attr("text-anchor", "middle")
          .text(percentageString);

      // Make the breadcrumb trail visible, if it's hidden.
      d3.select("#trail")
          .style("visibility", "");

    }

    function drawLegend() {

      // Dimensions of legend item: width, height, spacing, radius of rounded rect.
      var li = {
        w: 75, h: 30, s: 3, r: 3
      };

      var legend = d3.select("#legend").append("svg:svg")
          .attr("width", li.w)
          .attr("height", d3.keys(colors).length * (li.h + li.s));

      var g = legend.selectAll("g")
          .data(d3.entries(colors))
          .enter().append("svg:g")
          .attr("transform", function(d, i) {
                  return "translate(0," + i * (li.h + li.s) + ")";
               });

      g.append("svg:rect")
          .attr("rx", li.r)
          .attr("ry", li.r)
          .attr("width", li.w)
          .attr("height", li.h)
          .style("fill", function(d) { return d.value; });

      g.append("svg:text")
          .attr("x", li.w / 2)
          .attr("y", li.h / 2)
          .attr("dy", "0.35em")
          .attr("text-anchor", "middle")
          .text(function(d) { return d.key; });
    }

    d3.select("#legend").style("visibility", "");





    var ids = []

    // Take a 2-column CSV and transform it into a hierarchical structure suitable
    // for a partition layout. The first column is a sequence of step names, from
    // root to leaf, separated by hyphens. The second column is a count of how 
    // often that sequence occurred.
    function buildHierarchy(csv) {

        var root = {"name": "root", "children": [], id: generateId()};

        for (var i = 0; i < csv.length; i++) {
            
            var sequence = csv[i][0];
            var size = csv[i][1];

            if (isNaN(size)) { // e.g. if this is a header row
                continue;
            }

            var parts = sequence.split("-");
            var currentNode = root;

            
            for (var j = 0; j < parts.length; j++) {
                
                //console.log("current node", currentNode, sequence, size)
                var children = currentNode["children"];
                var nodeName = parts[j];
                var childNode;

                if(nodeName == ""){
                    continue;
                }

                if(children === undefined)children = []

                if (j + 1 < parts.length) {
                    
                    // Not yet at the end of the sequence; move down the tree.
                    var foundChild = false;
                    for (var k = 0; k < children.length; k++) {
                        if (children[k]["name"] == nodeName) {
                            childNode = children[k];
                            foundChild = true;
                            break;
                        }
                    }
                    
                    // If we don't already have a child node for this branch, create it.
                    if (!foundChild) {
                        var id = generateId()
                        ids.push(id)
                        childNode = { "name": nodeName, "children": [], id: id, clazz: "data-node"};
                        children.push(childNode);
                    }
                    
                    currentNode = childNode;
                
                } else {
                    // Reached the end of the sequence; create a leaf node.
                    childNode = {"name": nodeName, "size": size};
                    children.push(childNode);
                }
            }
        }

        return root;
    };


    function generateId() {
      var text = "";
      var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

      for (var i = 0; i < 7; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));

      return text;
    }


    jQuery.fn.d3Click = function () {
      this.each(function (i, e) {
        var evt = new MouseEvent("click");
        e.dispatchEvent(evt);
      });
    };



    // Hack to make this example display correctly in an iframe on bl.ocks.org
    //d3.select(self.frameElement).style("height", "700px");
});

</script>

</body>
</html>