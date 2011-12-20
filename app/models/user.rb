require 'authentication/restful'
require 'ptls/learning'
require 'ptls/reviewing'

class User < ActiveRecord::Base
  
  include Authentication::Restful
  include Ptls::User::Learning
  include Ptls::User::Reviewing
  
  # Basic validations
  validates_numericality_of :daily_units, :integer_only => true, :less_than_or_equal_to => 100, :greater_than_or_equal_to => 1
  
  # Basic associations
  has_many :learnings
  has_many :reviews
  has_many :associations
  has_many :subjects, :foreign_key => :owner_id
  
  # Does this user own the given subject?
  def owns?(subject)
    subjects.include?(subject)
  end
end