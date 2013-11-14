define ["marionette"], (Marionette)->
  class WeatherPanel extends Marionette.ItemView
    template: JST["app/templates/weather_panel"]

    modelEvents:
      "sync": "render"
