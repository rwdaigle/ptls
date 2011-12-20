# TODO: update to use utility_scopes
class Learning < ActiveRecord::Base
  
  # Is timed
  acts_as_timed
  
  validates_presence_of :unit_id, :user_id
  validates_uniqueness_of :unit_id, :scope => :user_id
  
  belongs_to :user
  belongs_to :unit, :include => :subject
  
  # Delegation
  delegate :subject, :to => :unit
  
  # Named scopes
  scope :for, lambda { |subject| {:conditions => "units.subject_id = #{subject.id}", :joins => "LEFT JOIN units ON units.id = unit_id"}}
  scope :today, lambda { {:conditions => ['learnings.created_at > ? and learnings.created_at < ?', Time.zone.now.beginning_of_day, Time.zone.now.end_of_day]} }
  scope :not_deferred, :conditions => {:deferred => false }  
  scope :recent, :order => 'learnings.created_at DESC, learnings.id DESC'    
end