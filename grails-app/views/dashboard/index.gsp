<% def applicationService = grailsApplication.classLoader.loadClass('io.seal.ApplicationService').newInstance()%>
<% def commonUtilities = grailsApplication.classLoader.loadClass('io.seal.common.CommonUtilities').newInstance()%>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="default">
	<title>Dashboard</title>

    <script type="text/javascript" src="${resource(dir:'js/lib/d3/d3.v3.min.js')}"></script>

</head>
<body>
	
	<g:if test="${flash.message}">
		<div class="notify" role="status">${raw(flash.message)}</div>
	</g:if>


<style type="text/css">

#main {
  float: left;
  width: 360px;
  position:relative;
}

#sidebar {
  float: right;
  width: 70px;
}

#sequence {
  width: 300px;
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
        
        <br class="clear"/>

    </div>
    <div id="sidebar">
      <div id="legend"></div>
    </div>

    <br class="clear"/>
    
    <script>

    var width = 600;
    var height = 600;
    var radius = Math.min(width, height) / 2;

    // Breadcrumb dimensions: width, height, spacing, width of tip/tail.
    var b = {
      w: 57, h: 30, s: 3, t: 10
    };

    var colors = {
        "mailer" : "#E25230",
        "coldcall": "#BE8E12",
        "email": "#70DC9C",
        "followup": "#42B06E",
        "meeting": "#3E7F9B",
        "demo": "#105878",
        "sale": "#3E7F9B",
        "prospect": "#6fb3d1",
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


</script>
</body>
</html>