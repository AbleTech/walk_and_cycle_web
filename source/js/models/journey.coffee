class JourneyPlanner.Models.Journey extends Backbone.Model

  defaults:
    mode: "walking"

  initialize: ->
    @waypoints = new JourneyPlanner.Collections.Waypoints()
    @steps     = new JourneyPlanner.Collections.Steps()
    @on "change", =>
      @waypoints.reset(@get('waypoints'))
      @steps.reset(@get('steps'))
    @on "sync", =>
      @updateMap() if @get("encoded_polyline")
      @updateGraph() if @get("elevation")

  validate: (attrs, options)->
    errors = []
    unless _(["walking", "cycling"]).indexOf(attrs.mode) >= 0
      errors.push "#{attrs.mode} is not a valid mode"

    valid_waypoints = @waypoints.filter (waypoint)-> waypoint.isValid()
    unless valid_waypoints.length > 1
      errors.push "you need a minimum of two waypoints"
    return errors if errors.length > 0

  url: ->
    query = "mode=#{@get('mode')}"
    @waypoints.each (waypoint)->
      query += "&#{waypoint.queryStr()}"
    "http://www.journeyplanner.org.nz/api/route.json?callback=?&#{query}"

  parse: (response,options)->
    if response.success and response.total > 0
      response.journeys[0]

  clearMap: ->
    @path_overlay?.setMap(null)
    if @waypoint_markers?
      _(@waypoint_markers).each (marker)-> marker.setMap(null)

  updateGraph: ->
    JourneyPlanner.App.graph.updateData(@get("elevation"), @get("total_distance"))


  updateMap: ->
    JourneyPlanner.App.map?.fitBounds(@steps.bounding_box())

    @path_overlay = new google.maps.Polyline
      map: JourneyPlanner.App.map
      path: google.maps.geometry.encoding.decodePath(@get("encoded_polyline").polyline)
      strokeColor: "#2564a5"
      strokeWeight: 4
      strokeOpacity: 0.7

    @waypoint_markers = []
    @waypoints.each (waypoint)=>
      marker = waypoint.getMarker()
      marker.setMap(JourneyPlanner.App.map)
      @waypoint_markers.push(marker)


