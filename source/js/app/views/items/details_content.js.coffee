define ["jquery", "underscore", "marionette", "lib/elevation_graph", "app/views/items/weather_panel", "underscore.string"], ($, _, Marionette, ElevationGraph, WeatherPanel) ->
  class DetailsContent extends Marionette.ItemView
    className: "tab-content"
    template: JST['app/templates/details_content']

    events:
      "keyup #weight" : "calculateCalories"
      "change #weight" : "calculateCalories"

    modelEvents:
      "sync": "render"
      "change:pace": "calculateCalories"

    onRender: ->
      $(".details_panel a:first").tab("show")
      if @model.get("elevation")
        @graph = new ElevationGraph($("#elevation_graph", @el)[0], @model)
      # @weather_panel = new Marionette.Region(el: $("#weather", @el))
      # @weather_panel.show new WeatherPanel({model: @model.weather_details()})

    calculateCalories: ->
      weight = parseFloat($("#weight", @el).val())
      $.cookie("jp_weight",weight) unless weight == NaN
      $(".calorie_result", @el).html @model.calculate_calories(weight)

    yearMultiplier: 2*3*52

    templateHelpers: ->
      initialWeight: =>
        $.cookie("jp_weight") || 70

      initialCalories: =>
        weight = $.cookie("jp_weight") || 70
        @model.calculate_calories(weight)

      healthCost: =>
        "$" + _.str.numberFormat(@model.health_cost(), 2)

      healthCostYear: =>
        "$" + _.str.numberFormat(@model.health_cost()*@yearMultiplier, 2)

      carCost: =>
        "$" + _.str.numberFormat(@model.car_cost(), 2)

      carCostYear: =>
        "$" + _.str.numberFormat(@model.car_cost()*@yearMultiplier, 2)

      carbonSaving: =>
        _.str.sprintf("%.1fkg", @model.carbon_saving())

      carbonSavingYear: =>
        _.str.sprintf("%.1fkg", @model.carbon_saving()*@yearMultiplier)




