define ["backbone", "app/models/step"], (Backbone, Step)->
  class Steps extends Backbone.Collection
    model: Step

    bounding_box: ->
      bounds = new google.maps.LatLngBounds()
      @each (step)->
        bounds.extend(step.latlng())
      bounds
