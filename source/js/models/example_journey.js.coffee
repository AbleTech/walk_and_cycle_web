class JourneyPlanner.Models.ExampleJourney extends JourneyPlanner.Models.Journey

  initialize: ->
    @waypoints = new JourneyPlanner.Collections.Waypoints()
    @waypoints.reset(@get('waypoints'))

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

  queryString: ->
    query = "?mode=#{@get('mode')}"
    @waypoints.each (waypoint)->
      query += "&#{waypoint.queryStr()}"
    query

  showExample: =>
    JourneyPlanner.App.router.navigate @queryString(), {trigger: true, replace: true}

  highlight: =>
    @polyline().setOptions
      strokeColor: "#fa780f"
    @trigger "highlight"

  unhighlight: =>
    @polyline().setOptions
      strokeColor: "#2564a5"
    @trigger "unhighlight"


class JourneyPlanner.Collections.ExampleJourneys extends Backbone.Collection
  model: JourneyPlanner.Models.ExampleJourney
  mode: "walking"

  updateMode: (new_mode)->
    @mode = new_mode
    @resetOverlays()
    @trigger "update_mode"

  resetOverlays:(map=JourneyPlanner.App.map)->
    @forEach (model)=>
      if model.visible() then model.polyline().setMap(map) else model.polyline().setMap(null)

  showOverlays: (map)->
    @forEach (model)=>
      model.polyline().setMap(map) if model.visible()

  hideOverlays: ->
    @showOverlays(null)
