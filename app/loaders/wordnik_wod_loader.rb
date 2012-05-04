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
      log(subject, "day=\"#{day}\"") do
        result = Wordnik.words.get_word_of_the_day(date: day.strftime("%Y-%m-%d"))
        question = result && !result.empty? ? result['word'] : nil
        existing_question = subject.units.where(question: question).first
        subject.units.create(question: question) unless existing_question
      end
    end
  end
end