module PayloadProcessingCommands

  class WikiSpecialsCleaner < PayloadProcessingCommands::BasicCommand

    def concrete_perform(payload)
      payload.gsub(/\[edit\]/,'.').gsub(/\[[0-9]+\]/,'')
    end

  end
end