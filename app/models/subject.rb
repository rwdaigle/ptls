require 'csv'
require 'processors/wordnik_processor'

class Subject < ActiveRecord::Base  
  
  validates_presence_of :title, :permalink
  has_many :units  # Ordering done by Unit.ordered scope
  has_many :reviews, :through => :units, :source => :reviews
  belongs_to :owner, :class_name => 'User'
  
  has_permalink :name

  class << self

    def seed(seed)
      connection.execute(sanitize_sql(["SELECT SETSEED(?)", seed]))
    end

    def process!(subject_id, overwrite=false)
      subject = self.find(subject_id)
      subject.process!(overwrite) if subject
    end

    def process_unit!(subject_id, unit_id, overwrite=false)
      subject = self.find(subject_id)
      subject.process_unit!(unit_id, overwrite) if subject
    end
  end

  def process!(overwrite = false)
    processor_klass = resolve_processor_class
    if processor_klass
      (overwrite ? units : units.empty).each do |unit|
        processor_klass.process!(self, unit)
      end
    end
  end

  def process_unit!(unit_id, overwrite = false)
    processor_klass = resolve_processor_class
    unit = Unit.find(unit_id)
    if processor_klass && unit
      processor_klass.process!(self, unit) if unit.answer.blank? || overwrite 
    end
  end
  
  # Override the param field to use in URIs
  def to_param; permalink; end
  
  # Use name as to_s
  def to_s; title; end

  private

  def resolve_processor_class
    if(unit_processor_type)
      begin
        @resolved_processor_class ||= "#{unit_processor_type}_processor".classify.constantize
      rescue
        logger.error "[Subject] event=error message=\"Unable to resolve processor class '#{unit_processor_type}' #{$!}\""
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