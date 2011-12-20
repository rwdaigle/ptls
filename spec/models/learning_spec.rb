require File.dirname(__FILE__) + '/../spec_helper'

describe Learning do

  scenario :ryan_learns_italian, :ryan_learns_spanish

  describe "callbacks" do
  
    it "should schedule a review for the next day when created" do
      (l = Learning.create(:user => users(:ryan), :unit => units(:italian_wine))).should_not be_new_record
      review = Review.find(:first, :conditions => {:user_id => users(:ryan).id, :unit_id => units(:italian_wine).id})
      review.should_not be_nil
      review.scheduled_at.to_s.should == (l.created_at + 24.hours).to_s
      review.interval.should == 1
      review.should_not be_success
    end
  end

  describe "associations" do

    it "should know its associated subject" do
      learnings(:ryan_learns_italian_bread).subject.should == subjects(:italian)
    end
  end
  
  describe "timing" do
    
    it "should know how track how much time was spent for the initial learning" do
      l = Learning.new(:started_at => 1.minute.ago)
      l.should_not be_valid
      l.time_spent.should be_close(1, 60)
    end

    it "should know how track how much time was spent for learning reviews" do
      l = learnings(:ryan_learns_italian_bread)
      l.started_at = 1.minute.ago
      l.should be_valid
      l.time_spent.should be_close(1, 75)
    end
  end
end