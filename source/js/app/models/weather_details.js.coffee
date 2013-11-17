define ["underscore", "backbone"], (_, Backbone)->
  class WeatherDetails extends Backbone.Model
    defaults:
      city:{}
      list:[]
    url: ->
      "http://api.openweathermap.org/data/2.5/forecast/daily?lat=#{@get("lat")}&lon=#{@get("lng")}&units=metric&cnt=6&callback=?"
