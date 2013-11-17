define ["backbone", "app/models/waypoint"], (Backbone, Waypoint)->
  class Waypoints extends Backbone.Collection
    model: Waypoint
