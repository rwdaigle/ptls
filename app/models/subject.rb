require 'csv'

class Subject < ActiveRecord::Base  
  
  validates_presence_of :name, :from, :permalink, :to
  has_many :units  # Ordering done by Unit.ordered scope
  has_many :reviews, :through => :units, :source => :reviews
  belongs_to :owner, :class_name => 'User'
  
  has_permalink :name

  class << self
    def seed(seed)
      connection.execute(sanitize_sql(["SELECT SETSEED(?)", seed]))
    end
  end
  
  # Import the question and answers from the given file into this
  # subject
  def import(file)
    CSV::Reader.parse(File.open(file)).each do |row|
      RAILS_DEFAULT_LOGGER.info "Importing #{row[0]} -> #{row[1]}"
      units.find_or_create_by_question_and_answer(row[0], row[1])
    end
  end
  
  # Auto translate this subject's units using the Google language API
  # Force overwrite of existing answers by passing in <tt>true</tt>
  # to overwrite argument.
  def translate(overwrite = false)
    (overwrite ? units : units.empty).each do |unit|
      if (answer = Translation.translate(unit.question, :from => from, :to => to))
        RAILS_DEFAULT_LOGGER.info "Translating #{unit.question} -> #{answer}"
        unit.update_attribute(:answer, answer)
      end
    end
  end
  
  # Override the param field to use in URIs
  def to_param; permalink; end
  
  # Use name as to_s
  def to_s; title; end
end
