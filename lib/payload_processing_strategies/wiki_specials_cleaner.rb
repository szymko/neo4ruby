module PayloadProcessingStrategies

  class WikiSpecialsCleaner < PayloadProcessingStrategies::BasicStrategy

    def concrete_perform(payload)
      payload.gsub(/\[edit\]/,'.').gsub(/\[[0-9]+\]/,'')
    end

  end
end