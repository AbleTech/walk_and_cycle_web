class window.ElevationGraph
  constructor: ->
    @svg = d3.select("#elevation_graph").append("svg")
      .attr("width", 600)
      .attr("height", 100)

    @margin =
      top: 10
      right: 10
      bottom: 20
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
      @hover_line
        .attr("x", d3.event.layerX - @margin.left)
        .style("visibility", "visible")
    @paper.on "mouseleave", =>
      @hover_line.style("visibility", "hidden")



  updateData: (elevation_data, total_distance)->
    @x_scale.domain([0, total_distance])
    min_alt = Math.max(0, elevation_data.min_height)
    max_alt = Math.max(100, elevation_data.max_height)
    @y_scale.domain([min_alt, max_alt]).nice()

    @paper.selectAll(".elevation_area, .elevation_stroke").remove()

    @paper.selectAll(".x_axis").remove()
    @paper.selectAll(".y_axis").remove()

    @paper.append("path")
      .datum(elevation_data.data)
      .attr("class","elevation_area")
      .attr("d", @area)

    @axes.append("g")
      .attr("class", "x_axis")
      .attr("transform", "translate(#{@margin.left},#{@height+@margin.top})")
      .call(@x_axis)
    @axes.append("g")
      .attr("class", "y_axis")
      .attr("transform", "translate(#{@margin.left},#{@margin.top})")
      .call(@y_axis)

    @paper.append("path")
      .datum(elevation_data.data)
      .attr("class", "elevation_stroke")
      .attr("d", @line)


