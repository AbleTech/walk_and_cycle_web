define ["backbone"], (Backbone)->
  class Step extends Backbone.Model
    latlng: ->
      new google.maps.LatLng(@get('y'),@get('x'))
