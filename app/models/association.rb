class Association < ActiveRecord::Base
  
  # Basic validations
  validates_uniqueness_of :unit_id, :scope => :user_id
  validates_presence_of :body
  
  # Basic (AR) associations
  belongs_to :user
  belongs_to :unit
  
  # Basic named scopes
  scope :for, lambda { |unit| { :conditions => { :unit_id => unit.id }} }
end