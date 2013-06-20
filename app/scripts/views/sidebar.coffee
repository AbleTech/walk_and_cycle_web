class JourneyPlanner.Views.StepItem extends Marionette.ItemView
  tagName: "li"
  template: "#step-item"

class JourneyPlanner.Views.Sidebar extends Marionette.CompositeView
  itemView: JourneyPlanner.Views.StepItem
  itemViewContainer: "ol"
  template: "#journey-sidebar"
