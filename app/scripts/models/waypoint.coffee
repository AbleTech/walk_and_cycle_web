class JourneyPlanner.Models.Waypoint extends Backbone.Model

  defaults: ->
    {"a":"", "x":"", "y":""}

  getMarker: ->
    @_marker ||= new google.maps.Marker({icon: @iconStyle(), title: @get("a"), position: @getLatLng()})

  index: ->
    @collection.indexOf(@)

  iconStyle: ->
    switch @get("type")
      when "start"
        {url: "/images/waypoint_markers/start.png", scaledSize: new google.maps.Size(52,27), anchor: new google.maps.Point(19,27)}
      when "via"
        {url: "/images/waypoint_markers/via.png", scaledSize: new google.maps.Size(40,27), anchor: new google.maps.Point(14,27)}
      when "end"
        {url: "/images/waypoint_markers/end.png", scaledSize: new google.maps.Size(41,27), anchor: new google.maps.Point(14,27)}
      else
        {}


  getLatLng: ->
    @_latlng ||= new google.maps.LatLng(@get("y"), @get("x"))


class JourneyPlanner.Collections.Waypoints extends Backbone.Collection
  model: JourneyPlanner.Models.Waypoint

