define ->
  class window.ElevationGraph
    constructor: (element, @journey)->
      @svg = d3.select(element).append("svg")
        .attr("width", 600)
        .attr("height", 120)

      @margin =
        top: 10
        right: 10
        bottom: 40
        left: 25

      @width  = @svg.attr("width") - @margin.left - @margin.right
      @height = @svg.attr("height") - @margin.top - @margin.bottom

      @axes = @svg.append("g")

      @paper = @svg.append("g").attr("transform", "translate(#{@margin.left},#{@margin.top})")

      @x_scale = d3.scale.linear().range([0, @width])
      @y_scale = d3.scale.linear().range([@height, 0])

      @x_axis = d3.svg.axis().scale(@x_scale).orient("bottom")
      @y_axis = d3.svg.axis().scale(@y_scale).orient("left").ticks(5)

      rect = @paper.append("rect")
        .attr("x", 0)
        .attr("y", 0)
        .attr("width", @width)
        .attr("height", @height)
        .attr("class", "bg_rect")
        .style("fill","#ffffff")
        .style("stroke", "none")

      @hover_line = @paper.append("rect")
        .attr("x", 0)
        .attr("y", 0)
        .attr("width", 1)
        .attr("height", @height)
        .style("visibility", "hidden")


      @area = d3.svg.area()
        .x((d)=> @x_scale(d[0]))
        .y0(@height)
        .y1((d)=> @y_scale(d[1]))

      @line = d3.svg.line()
        .x((d)=> @x_scale(d[0]))
        .y((d)=> @y_scale(d[1]))

      @paper.on "mousemove", =>
        x_position = d3.event.offsetX - @margin.left
        @hover_line
          .attr("x", x_position)
          .style("visibility", "visible")
        @journey.showElevationMarker(x_position/@width)

      @paper.on "mouseleave", =>
        @hover_line.style("visibility", "hidden")
        @journey.hideElevationMarker()

      @updateData(@journey.get("elevation"), @journey.get("total_distance"))

    updateData: (elevation_data, total_distance)->
      @x_scale.domain([0, total_distance])
      min_alt = Math.max(0, elevation_data.min_height)
      max_alt = Math.max(100, elevation_data.max_height)
      @y_scale.domain([min_alt, max_alt]).nice()

      @paper.selectAll(".elevation_area, .elevation_stroke").remove()

      @axes.selectAll(".x_axis").remove()
      @axes.selectAll(".y_axis").remove()

      @paper.append("path")
        .datum(elevation_data.data)
        .attr("class","elevation_area")
        .attr("d", @area)
        .style("fill", "#b3c533")
        .style("fill-opacity", 0.35)

      @axes.append("g")
        .attr("class", "x_axis")
        .attr("transform", "translate(#{@margin.left},#{@height+@margin.top})")
        .call(@x_axis)
        .append("text")
        .attr("y", 25)
        .attr("x", @width)
        .style("text-anchor", "end")
        .style("fill-opacity", "0.5")
        .text("Distance Traveled (m)")
      @axes.append("g")
        .attr("class", "y_axis")
        .attr("transform", "translate(#{@margin.left},#{@margin.top})")
        .call(@y_axis)
        .append("text")
        .style("dominant-baseline", "hanging")
        .style("fill-opacity", "0.5")
        .attr("dx", 2)
        .text("Altitude (m)")

      @paper.append("path")
        .datum(elevation_data.data)
        .attr("class", "elevation_stroke")
        .attr("d", @line)
        .style("stroke", "#b3c533")
        .style("fill", "none")


