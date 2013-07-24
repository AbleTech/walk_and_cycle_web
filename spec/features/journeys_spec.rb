require 'spec_helper'

describe "#index", type: :feature, js: true do
  describe "initial state" do
    before do
      visit "/"
    end

    xit { find("#examples").visible?.should be_true }
    it { find("#results").visible?.should be_false }

    it "should populate address fields" do
      fill_in "waypoint_0_a", with: "184 Willis"
      find(:xpath, "//ul[contains(@class,'af_list')][1]/li[1]").click
      find("#waypoint_0_a").value.should eq("184 Willis Street, Te Aro, Wellington 6011")
      find("#waypoint_0_x").value.should eq("174.773068233188")
      find("#waypoint_0_y").value.should eq("-41.2917018846201")
    end

    it "should submit form" do
      fill_in "waypoint_0_a", with: "184 Willis"
      find(:xpath, "//ul[contains(@class,'af_list')][1]/li[1]").click
      fill_in "waypoint_1_a", with: "260 Tinakori"
      find(:xpath, "//ul[contains(@class,'af_list')][2]/li[1]").click
      click_button "Get Directions"
      find("#results").visible?.should be_true
      find("#results").should have_content "184 Willis Street to 260 Tinakori Road"
    end
  end

  describe "url query" do
    before do
      visit "/?mode=walking&waypoints[0][a]=184+Willis+Street,+Te+Aro,+Wellington+6011&waypoints[0][x]=174.773068233188&waypoints[0][y]=-41.2917018846201&waypoints[1][a]=260+Tinakori+Road,+Thorndon,+Wellington+6011&waypoints[1][x]=174.771206217283&waypoints[1][y]=-41.2769081348662"
    end
    it { find("#examples").visible?.should be_false }
    it { find("#results").visible?.should be_true }
    it { find("#results").should have_content "184 Willis Street to 260 Tinakori Road" }
    it { find("#calories").should have_content "Calories burned: 151" }
    it { find("#health").should have_content "Monetary health savings per trip: $7.21" }
    it { find("#car_cost").should have_content "Vehicle cost savings per trip: $1.43" }
    it { find("#carbon").should have_content "Carbon emissions saved per trip: 0.4kg" }
  end
end
