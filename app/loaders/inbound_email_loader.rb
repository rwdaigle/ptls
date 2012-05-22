class InboundEmailLoader

  class << self

    def load!(from, text)
      log({event: "email-import", from: from, text: text}) do
        Subject.add_vocabulary_word(text)
      end
    end
  end
end