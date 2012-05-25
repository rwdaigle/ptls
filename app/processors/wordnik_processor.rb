require 'wordnik'

class WordnikProcessor

  class << self

    def process!(subject, unit)
      result = answer = nil
      log(subject, unit, { 'answer' => answer }) do
        result = Wordnik.word.get_definitions(unit.question, :limit => 1)
        answer = result && !result.empty? ? result[0]['text'] : nil
        unit.update_attributes(answer: answer)
      end
    end
  end
end