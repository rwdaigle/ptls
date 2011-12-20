require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  scenario :ryan_learns_italian, :ryan_learns_spanish
  
  before(:each) do
    @user = users(:ryan)
    @subject = subjects(:italian)
  end

  describe "learning" do
  
    it "should know what was learned today" do
      @user.learnings_for(@subject).collect(&:unit).sort.should == units(:italian_water, :italian_bread).sort
    end
  end

  describe "learning status" do
  
    it "should know how many units to learn each day" do
      @user.daily_units.should == 3
    end
  
    it "should know how many units they've learned for a particular subject" do
      @user.items_learned_count_for(@subject).should == 2
    end
  
    it "should know how many units are left to learn for a particular subject today" do
      @user.items_left_to_learn_for(@subject).should == 1
    end
  
    it "should know if there is anything left to learn today for a particular subject" do
      @user.learn?(@subject).should be_true  # Items left for today
    end
  
    it "should know the percent complete for a particular subject" do
      @user.percent_learned_for(@subject).should == (2 / 3.0 * 100)
    end
    
    it "should know the next unit to learn for a subject" do
      @user.next_unit_to_learn_for(@subject).should == units(:italian_wine)
    end
  end
  
  describe "daily learning" do
    
    scenario :users, :broken_sequence
    
    it "should be able to get the next unit to learn for a subject when nothing has been learned yet" do
      @user.next_unit_to_learn_for(@subject).should == units(:italian_water)      
    end
    
    it "should be able to get the next unit to learn for a subject" do
      learn :ryan, :italian_water
      @user.next_unit_to_learn_for(@subject).should == units(:italian_bread)
    end
    
    it "should be able to get the next unit to learn for a subject when the unit sequence has been broken" do
      learn :ryan, :italian_water
      learn :ryan, :italian_wine
      @user.next_unit_to_learn_for(@subject).should == units(:italian_bread)
    end
  end

  describe "reviewing" do
  
    before(:each) do
      @review = reviews(:ryan_reviews_italian_water)
    end
  
    it "should know how to get the next item to review today" do
      @review.update_attribute(:scheduled_at, (@review.scheduled_at - 24.hours))
      @user.review(@subject).should == reviews(:ryan_reviews_italian_water)
    end
  end

  describe "review shifting" do
  
    before(:each) do
      # Make all reviews appear 7 days behind
      @user = users(:ryan)
      @days = 8
      @user.reviews.left.each { |r| r.update_attribute(:scheduled_at, r.scheduled_at - @days.days) }
    end
    
    it "should know how many days behind a user's reviewing is" do
      @user.review_days_behind.should == (@days - 1)
    end
    
    it "should know how to shift the delayed reviews" do
      @user.shift_reviews
      @user.review_days_behind.should == 0
    end
  end

  describe "hints" do
    
    scenario :associations
  
    before(:each) do
      @unit = units(:italian_water)
    end
  
    it "should know how to get a unit hint" do
      @user.association_for(@unit).should == associations(:ryans_italian_water_hint)
    end
    
    it "should build a new hint when one doesn't exist" do
      a = @user.association_for(units(:italian_bread))
      a.should_not be_nil
      a.should be_new_record
      a.user.should == @user
      a.unit.should == units(:italian_bread)
    end
  end
  
  describe "subject ownership" do
    
    it "should know if it is the owner of a subject" do
      @user.owns?(@subject).should be_true
    end
    
    it "should know if it is not the owner of a subject" do
      users(:guest).owns?(@subject).should_not be_true
    end
  end
end