define ["marionette"], (Marionette)->
  class StepItem extends Marionette.ItemView
    tagName: "li"
    template: JST["app/templates/step_item"]

