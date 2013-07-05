class JourneyPlanner.Views.DetailsContent extends Marionette.ItemView
  className: "tab-content"
  template: JST['templates/details_content']

  events:
    "keyup #weight" : "calculateCalories"
    "change #weight" : "calculateCalories"

  modelEvents:
    "change": "render"

  onRender: ->
    if @model.get("elevation")
      @graph = new ElevationGraph($("#elevation_graph", @el)[0])
      @graph.updateData(@model.get("elevation"), @model.get("total_distance"))

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
      "$" + _.numberFormat(@model.health_cost(), 2)

    healthCostYear: =>
      "$" + _.numberFormat(@model.health_cost()*@yearMultiplier, 2)

    carCost: =>
      "$" + _.numberFormat(@model.car_cost(), 2)

    carCostYear: =>
      "$" + _.numberFormat(@model.car_cost()*@yearMultiplier, 2)

    carbonSaving: =>
      _.sprintf("%.1fkg", @model.carbon_saving())

    carbonSavingYear: =>
      _.sprintf("%.1fkg", @model.carbon_saving()*@yearMultiplier)




