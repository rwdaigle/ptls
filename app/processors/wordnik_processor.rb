require 'wordnik'

class WordnikProcessor

  class << self

    def process!(unit_id)
      unit = Unit.find(unit_id)
      log({'action' => "wordnik-process"}, unit) do
        result = Wordnik.word.get_definitions(unit.question, :limit => 1)
        answer = result && !result.empty? ? result[0]['text'] : nil
        unit.update_attributes(answer: answer)
      end if unit
    end
  end
end