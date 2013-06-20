class JourneyPlanner.Models.Journey extends Backbone.Model

  initialize: ->
    @waypoints = new JourneyPlanner.Collections.Waypoints()
    @steps     = new JourneyPlanner.Collections.Steps()
    @on "change", =>
      @waypoints.reset(@get('waypoints'))
      @steps.reset(@get('steps'))
      @updateMap()

  url: ->
    "http://www.journeyplanner.org.nz/api/route.json?callback=?&#{@params}"

  parse: (response,options)->
    if response.success and response.total > 0
      response.journeys[0]


  updateMap: ->
    JourneyPlanner.App.map?.fitBounds(@steps.bounding_box())
    @path_overlay?.setMap(null)
    if @waypoint_markers?
      _(@waypoint_markers).each (marker)-> marker.setMap(null)

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


