require 'wordnik'

class WordnikProcessor

  class << self

    def process!(unit_id)
      unit = Unit.find(unit_id)
      log({'action' => Event::PROCESS_WORDNIK}, unit) do

        # Go get it
        result = Wordnik.word.get_definitions(unit.question, :limit => 1)
        answer = result && !result.empty? ? result[0]['text'] : nil
        answer ? unit.update_attributes(answer: answer) : log({'action' => Event::PROCESS_WORDNIK_NOTFOUND}, unit)

        # Log errors
        unless unit.valid?
          log({'action' => Event::PROCESS_WORDNIK_UPDATE_FAILED}, unit, {'status' => 'error', 'message' => unit.errors.full_messages.join(', ')})
        end

      end if unit
    end

    def unprocessable
      Unit.empty.pluck(:question).select do |q|
        result = Wordnik.word.get_definitions(q, :limit => 1)
        answer = result && !result.empty? ? result[0]['text'] : nil
        !answer
      end
    end
  end
end