require 'text'

module PayloadProcessingCommands

  class Stemmer

    def concrete_perform(payload)
      Text::PorterStemming.stem(payload)
    end

  end

end
