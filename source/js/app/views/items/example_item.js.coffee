define ["jquery", "marionette"], ($, Marionette)->
  class ExampleItem extends Marionette.ItemView
    tagName : "li"
    template: JST["app/templates/example_item"]
    events:
      "click a.journey_name": "showExample"
      "mouseover" : "hoverEnter"
      "mouseout" : "hoverExit"

    modelEvents:
      "highlight" : "highlight"
      "unhighlight":"unhighlight"

    hoverEnter: ->
      @model.highlight()
    hoverExit: ->
      @model.unhighlight()

    highlight: ->
      $(@el).addClass "highlight"

    unhighlight: ->
      $(@el).removeClass "highlight"

    showExample: (e)->
      e.preventDefault()
      @model.showExample()
      false



