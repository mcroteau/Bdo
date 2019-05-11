<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Top Performing Sequence</title>
        <script src="http://localhost:9463/abcr/static/js/lib/d3/d3.v3.min.js"></script>
        <script src="http://localhost:9463/abcr/static/js/lib/jquery/jquery.min.js"></script>
    
        <style type="text/css">
            body{
                text-align:center;
                font-family: sans-serif;
            }
            #top-performing-container{
                width:90px;
                height:390px;
                position:relative;
                border:solid 0px #ddd;
            }
            #top-performing-sale-label{
                color:#fff;
                font-size:9px;
                padding:2px 7px;
                text-transform: uppercase;
                left:0px;
                top:15px;
                width:25px;
                position:absolute;
                background:#3e809b;
                display:inline-block;
                -webkit-border-radius: 2px;
                -moz-border-radius: 2px;
                border-radius: 2px;
                -moz-transform: rotate(270deg);
                -webkit-transform: rotate(270deg);
                -o-transform: rotate(270deg);
                -ms-transform: rotate(270deg);
                transform: rotate(270deg);
            }
            #top-performing-sequence{
                height:350px;
                width:87px;
                top:35px;
                left:0px;
                z-index:-1;
                position:absolute;
                border:solid 0px #ddd;
            }
            #top-performing-svg{
                margin: auto
            }
            .sequence-node-label{

            }
        </style>
    </head>
    <body>

        <div id="top-performing-container">
            <span id="top-performing-sale-label">Sale</span>
            <div id="top-performing-sequence"></div>
        </div>

        <script type="text/javascript">

            var data = [
                {
                    "date" : "03/01/2018",
                    "action": "test"
                },
                {
                    "date" : "03/01/2018",
                    "action": "test"
                },
                {
                    "date" : "03/01/2018",
                    "action": "test"
                },
                {
                    "date" : "03/01/2018",
                    "action": "test"
                },
                {
                    "date" : "03/01/2018",
                    "action": "test"
                },
                {
                    "date" : "03/01/2018",
                    "action": "test"
                },
                {
                    "date" : "03/01/2018",
                    "action": "test"
                },
                {
                    "date" : "03/01/2018",
                    "action": "test"
                }
            ]




            var svgWidth = 70;
            var svgHeight = 350;

            d3.select("#top-performing-sequence").append("svg:svg")
                        .attr("width", svgWidth)
                        .attr("height", svgHeight)
                        .attr("id", "top-performing-svg")

            var svg = d3.select("#top-performing-svg")

            console.log("svg", svg)

            var rect = svg.append("rect")
                    .attr("width", 2)                   
                    .attr("x", 6)
                    .attr("height", "100%")
                    .attr("fill", "#d4e9f1")
                    .attr("id", "top-performing-timeline")


            var increment = svgHeight/data.length
            console.log(increment)

            var circle = svg.selectAll("circle").data(data);

            console.log("circle", circle)

            var starting = increment - 6
            var nodes = circle.enter().append("circle")
                        .attr("fill", "#023248")
                        .attr("cx", 7)   
                        .attr("cy", function(d, index){
                            index = index + 1
                            var y = starting
                            if(index > 1){
                                y = index * increment - 10
                            }
                            return y
                        })  
                        .attr("r", 4)                  
                        .attr("class", "sequence-node")

            console.log(nodes)


            var text = svg.selectAll("text").data(data);

            var texts = text.enter().append("text")
                    .attr("x", 14)
                    .attr("y", function(d, index){
                        index = index + 1
                        var y = starting
                        if(index > 1){
                            y = index * increment - 8
                        }
                        return y
                    })
                    .text( function (d) { 
                        return d.action;
                     })
                    .attr("font-family", "sans-serif")
                    .attr("font-size", "12px")
                    .attr("fill", "#999")
                    .attr("class", "sequence-node-label")
                    //.attr("transform", "rotate(345, 0, 0)")
                    .attr("transform", function(d, i){
                        var y = (i + 1) * 20;
                        return "translate(0,"+y+"),rotate(345)";
                    });


            console.log(svg, texts)






        </script>
    </body>
</html>