#= require models/waypoint
#= require_self

describe "JourneyPlanner.Models.Waypoint", ->
  beforeEach =>
    @model = new JourneyPlanner.Models.Waypoint({a: "Test Location, Mockville", y: -42, x: 179})
    @collection = new JourneyPlanner.Collections.Waypoints([@model])


  it "should be valid", => expect(@model.isValid()).toBe true

  it "should set attributes", =>
    expect(@model.get("a")).toBe("Test Location, Mockville")
    expect(@model.get("y")).toBe(-42)
    expect(@model.get("x")).toBe(179)

  describe ".index", =>
    it "should return index in collection", =>
      expect(@model.index()).toBe 0

  describe ".streetName", =>
    it "should return first part of a", =>
      expect(@model.streetName()).toBe "Test Location"
