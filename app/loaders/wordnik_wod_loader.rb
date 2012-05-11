require 'wordnik'

class WordnikWODLoader

  class << self

    def load!(from = Date.today)
      subject = Subject.vocabulary
      if(subject)
        today = Date.today
        while(from <= today)
          load_wod(subject, from)
          from = from + 1.day
        end
      end
    end

    def load_wod(subject, day)
      result = question = nil
      log({event: "wod-import", day: day}) do

        result = Wordnik.words.get_word_of_the_day(date: day.strftime("%Y-%m-%d"))
        question = result && !result.empty? ? result['word'] : nil

        unit = subject.units.create(question: question)
        if(unit && unit.valid?)
          log({event: "wod-import-unit", day: day }, unit, { status: "success" })
        else
          log({event: "wod-import-unit", day: day }, unit, { status: "failure" }, { message: unit.errors.full_messages.join(", ") })
        end
      end
    end
  end
end