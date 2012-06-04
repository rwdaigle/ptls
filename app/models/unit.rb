class Unit < ActiveRecord::Base
  
  include Comparable
  
  validates_presence_of :question, :subject
  validates_uniqueness_of :question, :scope => :subject_id

  before_save :normalize_question, :set_processor_type
  
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

    def process!(unit_id, overwrite = false)
      find(unit_id).try(:process!, overwrite)
    end

  end
  
  def <=>(other)
    self.position <=> other.position
  end

  def empty?
    answer.blank?
  end

  def process!(overwrite = false)
    if overwrite || empty?
      with_processor do |processor_klass|
        processor_klass.process!(id)
      end
    end
  end

  def to_log
    { 'unit_id' => self.id, 'unit' => question }
  end

  def normalize_question
    self.question = question.strip.downcase if question
  end

  def set_processor_type
    self.processor_type = "Wordnik" unless processor_type
  end

  def with_processor(&block)
    processor_klass = resolve_processor_class
    yield processor_klass if processor_klass
  end

  private

  def resolve_processor_class
    if(processor_type)
      begin
        @resolved_processor_class ||= "#{processor_type}_processor".classify.constantize
      rescue
        # log({ 'status' => error, self, "message=\"Unable to resolve processor class '#{unit_processor_type}' #{$!}\"", "error=#{$!}")
      end
    end
  end
end
