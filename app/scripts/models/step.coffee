class JourneyPlanner.Models.Step extends Backbone.Model
  latlng: ->
    new google.maps.LatLng(@get('y'),@get('x'))


class JourneyPlanner.Collections.Steps extends Backbone.Collection
  model: JourneyPlanner.Models.Step

  bounding_box: ->
    bounds = new google.maps.LatLngBounds()
    @each (step)->
      bounds.extend(step.latlng())
    bounds


