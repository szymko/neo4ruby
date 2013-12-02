module PayloadProcessingStrategies

  class BasicStrategy

    def perform(payload)
      if payload.is_a? Array
        payload.map { |p| perform(p) }
      else
        concrete_perform(payload)
      end
    end

    private

    def concrete_perform(payload)
      raise NotImplementedError
    end

  end

end
