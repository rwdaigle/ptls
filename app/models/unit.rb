class Unit < ActiveRecord::Base
  
  include Comparable
  
  validates_presence_of :question, :subject
  validates_uniqueness_of :question, :scope => :subject_id

  before_save :normalize_question
  
  belongs_to :subject
  has_many :learnings, :dependent => :delete_all
  has_many :reviews, :dependent => :delete_all
  has_many :associations, :dependent => :delete_all
  
  acts_as_list :scope => :subject
  
  # Get the units that have not yet been learned by this user.
  # Replaces old named scope which used inefficient "IN" condition
  # scope :not_learned_by, lambda { |user| {:conditions => ["units.id not in (select unit_id from learnings where learnings.user_id = ?)", user.id]}}
  scope :not_learned_by, lambda { |user|
    { :joins => "LEFT JOIN learnings ON units.id = learnings.unit_id AND learnings.user_id = #{user.id}",
      :conditions => "learnings.unit_id IS NULL",
      :order => 'units.position' }
  }
  
  scope :learned_by, lambda { |user|
    { :joins => "LEFT JOIN learnings ON units.id = learnings.unit_id AND learnings.deferred = false AND learnings.user_id = #{user.id}",
      :conditions => "learnings.unit_id IS NOT NULL" }
  }
  
  scope :empty, :conditions => ["answer IS NULL OR answer = ''"]
  
  # Get units in random order in a repeateable way (must do SETSEED(seed) first)
  scope :random, { :order => "RANDOM()" }
  scope :ordered, { :order => 'units.position' }

  class << self

    # Leave out any joined columns (useful when chaining "for")
    # TODO: Find some way to patternize this
    def clean(scope = :all, opts = {})
      find(scope, {:select => 'units.*'}.merge(opts))
    end    

    def process!(unit_id, overwrite=false)
      unit = self.find(unit_id)
      unit.process!(overwrite) if unit
    end

  end
  
  def <=>(other)
    self.position <=> other.position
  end

  def process!(overwrite = false)
    log(subject, self, { 'overwrite' => overwrite }) do
      if answer.blank? || overwrite
        subject.with_processor do |processor_klass|
          processor_klass.process!(self, unit)
        end
      end
    end
  end

  def to_log
    { 'unit_id' => self.id, 'unit' => question }
  end

  def normalize_question
    self.question = question.strip.downcase if question
  end
end
