#= require models/journey
#= require models/waypoint
#= require models/step
#= require_self

describe "JourneyPlanner.Models.Journey", ->
  describe "empty journey", =>
    beforeEach =>
      @model = new JourneyPlanner.Models.Journey()
      @model.waypoints = new JourneyPlanner.Collections.Waypoints([{},{}])

    it "should be invalid", => expect(@model.isValid()).toBe false

  describe "example journey", =>
    beforeEach =>
      @model = new JourneyPlanner.Models.Journey({example: 50})

    it "should be valid", => expect(@model.isValid()).toBe true
