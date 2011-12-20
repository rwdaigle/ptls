require File.dirname(__FILE__) + '/../spec_helper'

describe Review do
  
  scenario :ryan_learns_italian, :ryan_learns_spanish  
  
  before do
    @user = users(:ryan)
    @subject = subjects(:italian)
  end
  
  describe "utility" do
    
    before do
      learn :ryan, :italian_wine
      @learning = learnings(:ryan_learns_italian_wine)
    end
    
    it "should be able to create the initial review for a learning" do
      r = Review.create_from(@learning)
      r.should be_valid
      r.should_not be_new_record
      r.scheduled_at.should == (@learning.created_at + 24.hours)
      r.interval.should == 1
      r.unit.should == @learning.unit
      r.user.should == @learning.user
    end
    
    it "should know not to create the initial review for a learning that's been deferred" do
      @learning.update_attribute(:deferred, true)
      r = Review.create_from(@learning)
      r.should be_nil
    end
  end
  
  describe "associations" do
    
    it "should know its associated subject" do
      reviews(:ryan_reviews_italian_bread).subject.should == subjects(:italian)
    end
  end
  
  describe "callbacks" do
    
    it "should know to create another review when one is promoted" do
      r = reviews(:ryan_reviews_italian_bread)
      r.update_attributes(:reviewed => true, :success => true)
      r.reviewed_at.should_not be_nil
      next_review = @user.reviews.for(@subject).find(:all, :conditions => {:unit_id => r.unit_id, :user_id => r.user_id, :interval => (r.interval * 2)})
      next_review.size.should == 1
      next_review.first.scheduled_at.to_s.should == (r.reviewed_at + (24.hours * 2 * r.interval)).to_s
    end
    
    it "should know to create another review when one is demoted" do
      r = reviews(:ryan_reviews_italian_bread)
      r.update_attributes(:reviewed => true, :success => false)
      r.reviewed_at.should_not be_nil
      next_review = @user.reviews.for(@subject).find(:all, :conditions => {:unit_id => r.unit_id, :user_id => r.user_id, :interval => 1})
      next_review.size.should == 2
      next_review.last.scheduled_at.to_s.should == (r.reviewed_at + (24.hours)).to_s
    end

    it "should know NOT to create another review for one that is already reviewed" do
      # Set up test by promoting one review
      (r = reviews(:ryan_reviews_italian_bread)).update_attributes(:reviewed => true, :success => true)
      
      # Then make sure further reviews don't update anything
      lambda {r.update_attributes(:started_at => 1.minute.ago)}.should_not change { @user.reload.reviews.count }
      lambda {r.update_attributes(:started_at => 1.minute.ago)}.should_not change { r.reload.reviewed_at }
    end
  end
end