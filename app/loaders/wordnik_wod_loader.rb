require 'wordnik'

class WordnikWODLoader

  class << self

    def load!(from = Date.today)
      today = Date.today
      while(from <= today)
        load_wod(from)
        from = from + 1.day
      end
    end

    def load_wod(day)
      result = question = nil
      log({'action' => Event::IMPORT_WOD_WORDNIK, 'day' => day.to_s}) do
        result = Wordnik.words.get_word_of_the_day(date: day.strftime("%Y-%m-%d"))
        word = result && !result.empty? ? result['word'] : nil
        Subject.add_vocabulary_word(word)
      end
    end
  end
end