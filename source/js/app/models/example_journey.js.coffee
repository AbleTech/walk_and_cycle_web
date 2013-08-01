define ["app/models/journey", "app/collections/waypoints", "marker_with_label", "app"], (Journey, Waypoints, MarkerWithLabel)->
  class ExampleJourney extends Journey
    initialize: ->
      @waypoints = new Waypoints()
      @waypoints.reset(@get('waypoints'))

    parse: (response)-> response

    visible: ->
      @get("mode") == @collection.mode

    polyline: ->
      return @_polyline if @_polyline?
      @_polyline = new google.maps.Polyline
        path: google.maps.geometry.encoding.decodePath(@get("encoded_polyline").polyline)
        strokeColor: "#2564a5"
        strokeWeight: 4
        strokeOpacity: 0.7
        title: @get("name")
      google.maps.event.addListener @_polyline, "mouseover", @highlight
      google.maps.event.addListener @_polyline, "mouseout", @unhighlight
      google.maps.event.addListener @_polyline, "click", @showExample
      @_polyline

    exampleMarker: ->
      return @_example_marker if @_example_marker?
      @_example_marker = new MarkerWithLabel
        position: @halfwayPoint()
        title: @get("name")
        labelContent: @collection.indexOf(@) + 1
        labelClass: "example_marker_label"
        labelAnchor: new google.maps.Point(13, 32)
        icon:
          url: "img/white-icon.png"
          scaledSize: new google.maps.Size(23, 32)
          anchor: new google.maps.Point(13,32)
      google.maps.event.addListener @_example_marker, "mouseover", @highlight
      google.maps.event.addListener @_example_marker, "mouseout", @unhighlight
      google.maps.event.addListener @_example_marker, "click", @showExample
      @_example_marker

    queryString: ->
      query = "?mode=#{@get('mode')}"
      @waypoints.each (waypoint)->
        query += "&#{waypoint.queryStr()}"
      query

    halfwayPoint: =>
      distance = 0.5 * @get("total_distance")
      @pointAlongPath(distance)

    showExample: =>
      App.router.navigate @queryString(), {trigger: true, replace: true}

    highlight: =>
      @polyline().setOptions
        strokeColor: "#fa780f"
      @trigger "highlight"

    unhighlight: =>
      @polyline().setOptions
        strokeColor: "#2564a5"
      @trigger "unhighlight"
