define ["jquery", "underscore", "backbone", "config", "app/collections/waypoints", "app/collections/steps", "app/models/waypoint", "app/models/weather_details", "jquery.cookie"],
($, _, Backbone, Config, Waypoints, Steps, Waypoint, WeatherDetails)->

  class Journey extends Backbone.Model

    defaults:
      mode: "walking"
      altitude_factor: 1.13046330315024

    initialize: ->
      @waypoints = new Waypoints()
      @waypoints.journey = @
      @steps     = new Steps()
      @set "pace", $.cookie("jp_speed") || "average"

      @on "change", =>
        @waypoints.reset(@get('waypoints'))
        @steps.reset(@get('steps'))
      @on "change:pace", =>
        $.cookie("jp_speed", @get("pace"), {path: "/", expires: 365})
      @on "sync", =>
        $("a[href='#results']").show().tab("show")
        @updateMap() if @get("encoded_polyline")

      @on "live_drag", @liveDrag


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
      "http://staging.journeyplanner.org.nz/api/route.json?#{query}"

    parse: (response,options)->
      if response.success and response.total > 0
        response.journeys[0]

    weather_details: ->
      center = @steps.bounding_box().getCenter()
      @_weather_details = new WeatherDetails({lat: center.lat(), lng: center.lng()})
      @_weather_details.fetch()
      @_weather_details

    total_time: ->
      (@get("total_distance")/(@currentSpeed()*1000))*60

    car_cost: ->
      Config.CAR_COST[@get("mode")] * (@get("total_distance")/1000)

    health_cost: ->
      Config.HEALTH_COST[@get("mode")] * (@get("total_distance")/1000)

    carbon_saving: ->
      0.214 * (@get("total_distance")/1000)

    calculate_calories: (weight)->
      Math.round(weight * @total_time() * @currentEffort() * @get("altitude_factor"))

    currentSpeed: ->
      Config.SPEEDS[@get("mode")][@get("pace")]

    currentEffort: ->
      Config.EFFORT[@get("mode")][@get("pace")]

    elevation_marker:->
      @_elevation_marker ||= new google.maps.Marker
        map: App.map
        icon: @elevation_icon()

    elevation_icon: ->
      anchor: new google.maps.Point(14,34)
      url: "img/elevation_markers/icon_#{@get('mode')}.png"

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

    nearestPolylineNode: (point)->
      if @polyline()?
        path_points = @polyline().getPath()
        min_distance = Infinity
        closest = null
        path_points.forEach (node, index)->
          if  (dist = google.maps.geometry.spherical.computeDistanceBetween(node, point)) < min_distance
            closest = node
            min_distance = dist
        path_points.getArray().indexOf(closest)

    preceedingWaypoint: (point)->
      preceeding_waypoint = null
      point_node = @nearestPolylineNode(point)
      @waypoints.each (waypoint, index)=>
        preceeding_waypoint = waypoint if @nearestPolylineNode(waypoint.getLatLng()) < point_node
      preceeding_waypoint

    showOverlays: (map)->
      @polyline()?.setMap(map)
      @ghostline()?.setMap(map)
      @waypoints.each (waypoint)->
        waypoint.getMarker().setMap(map)

    hideOverlays: ->
      @shadow_live?.setMap(null)
      @showOverlays(null)

    polyline: ->
      if @get("encoded_polyline")
        return @_polyline if @_polyline?
        @_polyline = new google.maps.Polyline
          map: App.map
          path: google.maps.geometry.encoding.decodePath(@get("encoded_polyline").polyline)
          strokeColor: "#2564a5"
          strokeWeight: 4
          strokeOpacity: 0.7
        return @_polyline

    ghostline: ->
      if @get("encoded_polyline")
        return @_ghostline if @_ghostline?
        @_ghostline = new google.maps.Polyline
          map: App.map
          path: google.maps.geometry.encoding.decodePath(@get("encoded_polyline").polyline)
          strokeWeight: 12
          strokeOpacity: 0.1
        google.maps.event.addListener @_ghostline, "mousemove", (e)=>
          @dragMarker().setPosition(e.latLng)
          @showDragMarker()
        google.maps.event.addListener @_ghostline, "mouseout",  (e)=>
          @hideDragMarker()

        return @_ghostline


    waypointMarkers: ->
      @waypoints.map (waypoint)=>
        marker = waypoint.getMarker()
        marker

    updateMap: ->
      if App.map?
        App.map.fitBounds(@steps.bounding_box())
        @showOverlays(App.map)


    dragWaypoint: ->
      @_drag_waypoint ||= new Waypoint(type: "live_drag")

    dragMarker: ->
      return @_drag_marker if @_drag_marker?

      @_drag_marker = @dragWaypoint().getMarker()
      @_drag_marker.setOptions
        map: App.map
        draggable: true
        visible: false

      google.maps.event.addListener @_drag_marker, "mouseover", (e)=> @showDragMarker()
      google.maps.event.addListener @_drag_marker, "mousedown", (e)=> @_drag_marker.set("live_drag", true)
      google.maps.event.addListener @_drag_marker, "mouseup", (e)=> @_drag_marker.set("live_drag", false)
      google.maps.event.addListener @_drag_marker, "dragstart", (e)=>
        console.log(@preceedingWaypoint(e.latLng))
        index = @waypoints.indexOf(@preceedingWaypoint(e.latLng))
        @waypoints.add @dragWaypoint(), at: index + 1

      @_drag_marker




    showDragMarker: ->
      @dragMarker().setOptions
        visible: true

    hideDragMarker: ->
      unless @dragMarker().get("live_drag")
        @dragMarker().setOptions
          visible: false


    liveDrag: =>
      live_waypoints = @waypoints.map (waypoint)->
        {
          x: waypoint.getMarker().getPosition().lng()
          y: waypoint.getMarker().getPosition().lat()
        }
      $.getJSON "http://staging.journeyplanner.org.nz/api/route/shadow.json", {waypoints: live_waypoints, mode: @get("mode")}, (result)=>
        @shadow_live?.setMap(null)
        if result.encoded_polyline?
          console.log(result)
          @shadow_live = new google.maps.Polyline
            map: App.map
            path:  google.maps.geometry.encoding.decodePath(result.encoded_polyline.polyline)
            strokeColor: "#2564a5"
            strokeWeight: 4
            strokeOpacity: 0.4


