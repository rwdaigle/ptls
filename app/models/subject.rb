require 'csv'
require 'processors/wordnik_processor'

class Subject < ActiveRecord::Base  
  
  validates_presence_of :title, :permalink
  has_many :units  # Ordering done by Unit.ordered scope
  has_many :reviews, :through => :units, :source => :reviews
  belongs_to :owner, :class_name => 'User'
  
  has_permalink :name

  class << self

    def seedRandom(seed)
      connection.execute(sanitize_sql(["SELECT SETSEED(?)", seed]))
    end

    def process!(subject_id, overwrite=false)
      log("subject_id=#{subject_id}", "overwrite=#{overwrite}") do
        subject = self.find(subject_id)
        subject.process!(overwrite) if subject
      end
    end
  end

  def process!(overwrite = false)
    with_processor do |processor_klass|
      (overwrite ? units : units.empty).each do |unit|
        processor_klass.process!(self, unit)
      end
    end
  end

  def with_processor(&block)
    processor_klass = resolve_processor_class
    yield processor_klass if processor_klass
  end
  
  # Override the param field to use in URIs
  def to_param; permalink; end
  
  # Use name as to_s
  def to_s; title; end

  def to_log; "subject_id=#{self.id} subject=\"#{self}\""; end

  private

  def resolve_processor_class
    if(unit_processor_type)
      begin
        @resolved_processor_class ||= "#{unit_processor_type}_processor".classify.constantize
      rescue
        log("status=error", self, "message=\"Unable to resolve processor class '#{unit_processor_type}' #{$!}\"", "error=#{$!}")
      end
    end
  end

end

  # Old implementation
  #
  # # Import the question and answers from the given file into this
  # # subject
  # def import(file)
  #   CSV::Reader.parse(File.open(file)).each do |row|
  #     logger.info "Importing #{row[0]} -> #{row[1]}"
  #     units.find_or_create_by_question_and_answer(row[0], row[1])
  #   end
  # end