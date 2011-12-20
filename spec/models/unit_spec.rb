require File.dirname(__FILE__) + '/../spec_helper'

describe Unit do

  scenario :ryan_learns_italian, :ryan_learns_spanish
  
  before do
    @user = users(:ryan)
    @subject = subjects(:italian)
  end

  describe "queries" do
  
    it "should know what a user has not yet learned" do
      @subject.units.not_learned_by(@user).ordered.should == [units(:italian_wine)]
    end

    it "should know what a user has already learned" do
      @subject.units.learned_by(@user).ordered.should == units(:italian_water, :italian_bread)
    end
  end
end