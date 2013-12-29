module PayloadProcessingStrategies

  class BasicStrategy

    def perform(payload)
      res = recursive_perform(payload)
      @callback ? self.send(@callback, res) : res
    end

    private

    def recursive_perform(payload)
      if payload.is_a? Array
        payload.map { |p| recursive_perform(p) }
      else
        concrete_perform(payload)
      end
    end

    def concrete_perform(payload)
      raise NotImplementedError
    end

  end

end
