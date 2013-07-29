!function(){window.ElevationGraph=function(){function t(t,i){var e,a=this;this.journey=i,this.svg=d3.select(t).append("svg").attr("width",600).attr("height",120),this.margin={top:10,right:10,bottom:40,left:25},this.width=this.svg.attr("width")-this.margin.left-this.margin.right,this.height=this.svg.attr("height")-this.margin.top-this.margin.bottom,this.axes=this.svg.append("g"),this.paper=this.svg.append("g").attr("transform","translate("+this.margin.left+","+this.margin.top+")"),this.x_scale=d3.scale.linear().range([0,this.width]),this.y_scale=d3.scale.linear().range([this.height,0]),this.x_axis=d3.svg.axis().scale(this.x_scale).orient("bottom"),this.y_axis=d3.svg.axis().scale(this.y_scale).orient("left").ticks(5),e=this.paper.append("rect").attr("x",0).attr("y",0).attr("width",this.width).attr("height",this.height).attr("class","bg_rect"),this.hover_line=this.paper.append("rect").attr("x",0).attr("y",0).attr("width",1).attr("height",this.height).style("visibility","hidden"),this.area=d3.svg.area().x(function(t){return a.x_scale(t[0])}).y0(this.height).y1(function(t){return a.y_scale(t[1])}),this.line=d3.svg.line().x(function(t){return a.x_scale(t[0])}).y(function(t){return a.y_scale(t[1])}),this.paper.on("mousemove",function(){var t;return t=d3.event.offsetX-a.margin.left,a.hover_line.attr("x",t).style("visibility","visible"),a.journey.showElevationMarker(t/a.width)}),this.paper.on("mouseleave",function(){return a.hover_line.style("visibility","hidden"),a.journey.hideElevationMarker()}),this.updateData(this.journey.get("elevation"),this.journey.get("total_distance"))}return t.prototype.updateData=function(t,i){var e,a;return this.x_scale.domain([0,i]),a=Math.max(0,t.min_height),e=Math.max(100,t.max_height),this.y_scale.domain([a,e]).nice(),this.paper.selectAll(".elevation_area, .elevation_stroke").remove(),this.axes.selectAll(".x_axis").remove(),this.axes.selectAll(".y_axis").remove(),this.paper.append("path").datum(t.data).attr("class","elevation_area").attr("d",this.area),this.axes.append("g").attr("class","x_axis").attr("transform","translate("+this.margin.left+","+(this.height+this.margin.top)+")").call(this.x_axis).append("text").attr("y",25).attr("x",this.width).style("text-anchor","end").style("fill-opacity","0.5").text("Distance Traveled (m)"),this.axes.append("g").attr("class","y_axis").attr("transform","translate("+this.margin.left+","+this.margin.top+")").call(this.y_axis).append("text").style("dominant-baseline","hanging").style("fill-opacity","0.5").attr("dx",2).text("Altitude (m)"),this.paper.append("path").datum(t.data).attr("class","elevation_stroke").attr("d",this.line)},t}()}.call(this);