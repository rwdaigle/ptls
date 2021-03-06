class InboundEmailLoader

  class << self

    def load!(from, text)
      log_context({'user' => 'ryan', 'user_id' => 1}) do
        log({'action' => Event::IMPORT_EMAIL, 'from' => from, 'text' => text}) do
          Subject.add_vocabulary_word(text)
        end
      end
    end
  end
end