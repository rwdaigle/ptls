class Subject < ActiveRecord::Base  
  
  validates_presence_of :title, :permalink
  has_many :units  # Ordering done by Unit.ordered scope
  has_many :reviews, :through => :units, :source => :reviews
  belongs_to :owner, :class_name => 'User'
  
  has_permalink :title

  class << self

    def vocabulary
      self.find(ENV['VOCABULARY_SUBJECT_ID'].to_i) if ENV['VOCABULARY_SUBJECT_ID']
    end

    def add_vocabulary_word(word)
      subject = vocabulary
      unit = subject.units.create(question: word)
      if(unit && unit.valid?)
        log({'action' => Event::UNIT_ADD }, unit)
      else
        log({'action' => Event::UNIT_ADD }, unit, { 'status' => 'error', 'message' => unit.errors.full_messages.join(", ") })
      end
    end

    def seedRandom(seed)
      connection.execute(sanitize_sql(["SELECT SETSEED(?)", seed]))
    end

    def process!(subject_id, overwrite=false)
      subject = self.find(subject_id)
      subject.process!(overwrite) if subject
    end
  end

  def process!(overwrite = false)
    (overwrite ? units.processable : units.processable.empty).each do |unit|
      unit.process!(overwrite)
    end
  end
  
  # Override the param field to use in URIs
  def to_param; permalink; end
  
  # Use name as to_s
  def to_s; title; end

  def to_log
    { 'subject_id' => self.id, 'subject_title' => self.title }
  end

end