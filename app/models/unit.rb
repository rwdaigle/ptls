class Unit < ActiveRecord::Base
  
  include Comparable
  
  validates_presence_of :question, :subject
  validates_uniqueness_of :question, :scope => :subject_id
  
  belongs_to :subject
  has_many :learnings, :dependent => :delete_all
  has_many :reviews, :dependent => :delete_all
  has_many :associations, :dependent => :delete_all
  
  acts_as_list :scope => :subject
  
  # Get the units that have not yet been learned by this user.
  # Replaces old named scope which used inefficient "IN" condition
  # named_scope :not_learned_by, lambda { |user| {:conditions => ["units.id not in (select unit_id from learnings where learnings.user_id = ?)", user.id]}}
  named_scope :not_learned_by, lambda { |user|
    { :joins => "LEFT JOIN learnings ON units.id = learnings.unit_id AND learnings.user_id = #{user.id}",
      :conditions => "learnings.unit_id IS NULL",
      :order => 'units.position' }
  }
  
  named_scope :learned_by, lambda { |user|
    { :joins => "LEFT JOIN learnings ON units.id = learnings.unit_id AND learnings.deferred = 0 AND learnings.user_id = #{user.id}",
      :conditions => "learnings.unit_id IS NOT NULL" }
  }
  
  named_scope :empty, :conditions => ["answer IS NULL OR answer = ''"]
  
  # Get units in random order in a repeateable way (hence the seed)
  named_scope :random, lambda { |seed| { :order => "RAND(#{seed || 1})" } }
  named_scope :ordered, { :order => 'units.position' }

  class << self

    # Leave out any joined columns (useful when chaining "for")
    # TODO: Find some way to patternize this
    def clean(scope = :all, opts = {})
      find(scope, {:select => 'units.*'}.merge(opts))
    end
  end
  
  def <=>(other)
    self.position <=> other.position
  end
end
