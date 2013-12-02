module PayloadProcessingStrategies

  class Normalizer < PayloadProcessingStrategies::BasicStrategy

    def concrete_perform(payload)
      payload.encode('utf-8').downcase
    end

  end

end
