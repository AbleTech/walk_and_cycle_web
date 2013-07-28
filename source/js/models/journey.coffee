class JourneyPlanner.Models.Journey extends Backbone.Model

  defaults:
    mode: "walking"
    altitude_factor: 1.13046330315024

  initialize: ->
    @waypoints = new JourneyPlanner.Collections.Waypoints()
    @waypoints.journey = @
    @steps     = new JourneyPlanner.Collections.Steps()
    @set "pace", $.cookie("jp_speed") || "average"

    @on "change", =>
      @waypoints.reset(@get('waypoints'))
      @steps.reset(@get('steps'))
    @on "change:pace", =>
      $.cookie("jp_speed", @get("pace"), {path: "/", expires: 365})
    @on "sync", =>
      @updateMap() if @get("encoded_polyline")
      $("a[href='#results']").show().tab("show")

  validate: (attrs, options)->
    errors = []
    unless @get("example")
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
    "http://192.168.1.171:17905/api/route.json?callback=?&#{query}"

  parse: (response,options)->
    if response.success and response.total > 0
      response.journeys[0]

  total_time: ->
    (@get("total_distance")/(@currentSpeed()*1000))*60

  car_cost: ->
    JourneyPlanner.CAR_COST[@get("mode")] * (@get("total_distance")/1000)

  health_cost: ->
    JourneyPlanner.HEALTH_COST[@get("mode")] * (@get("total_distance")/1000)

  carbon_saving: ->
    0.214 * (@get("total_distance")/1000)

  calculate_calories: (weight)->
    Math.round(weight * @total_time() * @currentEffort() * @get("altitude_factor"))

  currentSpeed: ->
    JourneyPlanner.SPEEDS[@get("mode")][@get("pace")]

  currentEffort: ->
    JourneyPlanner.EFFORT[@get("mode")][@get("pace")]

  elevation_marker:->
    @_elevation_marker ||= new google.maps.Marker
      map: JourneyPlanner.App.map
      icon: @elevation_icon()

  elevation_icon: ->
    anchor: new google.maps.Point(14,34)
    url: "/img/elevation_markers/icon_#{@get('mode')}.png"

  showElevationMarker: (fraction=0)->
    distance = fraction * @get("total_distance")
    @elevation_marker().setOptions
      position: @pointAlongPath(distance)
      visible: true

  hideElevationMarker: ->
    @elevation_marker().setVisible(false)

  pointAlongPath: (distance=0)->
    interpolated_point = null
    if @polyline()?
      cumulative_distance = 0
      @polyline().getPath().forEach (point, index)=>
        if index > 0 and interpolated_point == null
          previous_point = @polyline().getPath().getAt(index - 1)
          segment_length = google.maps.geometry.spherical.computeDistanceBetween(previous_point, point)
          if (cumulative_distance + segment_length) > distance
            distance_fraction = (distance - cumulative_distance) / segment_length
            interpolated_point = google.maps.geometry.spherical.interpolate(previous_point, point, distance_fraction)
            return
          else
            cumulative_distance += segment_length

    interpolated_point

  showOverlays: (map)->
    @polyline()?.setMap(map)
    for marker in @waypointMarkers()
      marker.setMap(map)

  hideOverlays: ->
    @showOverlays(null)

  polyline: ->
    if @get("encoded_polyline")
      @_polyline ||= new google.maps.Polyline
        map: JourneyPlanner.App.map
        path: google.maps.geometry.encoding.decodePath(@get("encoded_polyline").polyline)
        strokeColor: "#2564a5"
        strokeWeight: 4
        strokeOpacity: 0.7

  waypointMarkers: ->
    @waypoints.map (waypoint)=>
      marker = waypoint.getMarker()
      marker

  updateMap: ->
    if JourneyPlanner.App.map?
      JourneyPlanner.App.map.fitBounds(@steps.bounding_box())
      @showOverlays(JourneyPlanner.App.map)



