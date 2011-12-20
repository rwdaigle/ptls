# TODO: Make promote/demote first class methods for tighter
# callback scheduling of next reviews instead of just assuming
# such on updates
class Review < ActiveRecord::Base
  
  acts_as_timed
  
  # Basic associations
  belongs_to :user
  belongs_to :unit, :include => :subject
  
  # Named scopes
  # TODO: Fix need for 'clean' on for scope
  scope :for, lambda { |subject| {:conditions => "units.subject_id = #{subject.id}", :joins => "LEFT JOIN units ON units.id = unit_id"}}
  scope :today, lambda { { :conditions => ['scheduled_at <= ?', Time.zone.now.end_of_day], :order => 'reviews.created_at ASC' }}
  scope :reviewed_today, lambda { { :conditions => ['reviewed = ? and reviewed_at >= ? and reviewed_at <= ?', true, Time.zone.now.beginning_of_day, Time.zone.now.end_of_day], :order => 'reviews.created_at ASC, reviews.id ASC' }}
  scope :left, :conditions => { :reviewed => false }, :order => 'reviews.scheduled_at ASC'
  scope :reviewed, :conditions => { :reviewed => true }
  scope :successful, :conditions => { :success => true }
  scope :failed, :conditions => { :success => false }
  
  # Lifecycle callbacks
  before_update :update_reviewed_at
  before_update :schedule_next_review
  
  # Delegation
  delegate :subject, :to => :unit
  
  class << self
    
    # Create the initial review required for this learning
    def create_from(learning)
      create(:user_id => learning.user_id, :unit_id => learning.unit_id, :scheduled_at => (learning.created_at + 24.hours)) if
        not learning.deferred?
    end
        
    # Leave out any joined columns (useful when chaining "for")
    # TODO: eliminate need for this (on 'for' scope)
    def clean(scope = :all, opts = {})
      find(scope, {:select => 'reviews.*'}.merge(opts))
    end
  end
  
  # Get the next review to schedule after this one (but don't persist
  # it - leave that up to the caller)
  def next
    self.class.new(next_review_attrs)
  end    
  
  private
  
  # Was I just now reviewed for the first time?
  def just_reviewed?
    reviewed? and reviewed_changed?
  end
  
  # Schedule the next review.  Only create a new review if this review
  # was just now reviewed for the first time.  (Updates of any other
  # kind are not promotions/deletions)
  def schedule_next_review
    self.next.save! if just_reviewed?
  end
  
  # Stamp the reviewed_at timestamp field if in fact this review was reviewed
  def update_reviewed_at
    self.reviewed_at = Time.zone.now if just_reviewed?
  end
  
  # Get the next interval period given this review's success/failure
  def next_interval
    next_interval = success? ? interval * 2 : interval / 2
    next_interval < 1 ? 1 : next_interval
  end
  
  # Get the next review date give this review's success/failure
  def next_scheduled_at
    reviewed_at + (24.hours * next_interval)
  end
  
  # The properties that define the next review
  def next_review_attrs
    {:unit_id => unit_id, :user_id => user_id, :interval => next_interval, :scheduled_at => next_scheduled_at}
  end
end