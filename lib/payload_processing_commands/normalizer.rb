module PayloadProcessingCommands

  class Normalizer < PayloadProcessingCommands::BasicCommand

    def concrete_perform(payload)
      payload.encode('utf-8').downcase
    end

  end

end
