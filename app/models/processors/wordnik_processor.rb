require 'wordnik'

class WordnikProcessor

  class << self

    def process!(subject, unit)
      logger.info "[Processor] event=start processor=#{self.to_s} subject_id=#{subject.id} subject=#{subject.title} unit_id=#{unit.id} question=\"#{unit.question}\""
      result = answer = nil
      ms = Benchmark.ms do
        result = Wordnik.word.get_definitions(unit.question, :limit => 1)
        answer = result && !result.empty? ? result[0]['text'] : nil
        unit.update_attributes(answer: answer)
      end
      logger.info "[Processor] event=end processor=#{self.to_s} subject_id=#{subject.id} subject=#{subject.title} unit_id=#{unit.id} question=\"#{unit.question}\" answer=\"#{answer}\" execution=#{ms}ms"
    end

    def logger
      ActiveRecord::Base.logger
    end
  end
end