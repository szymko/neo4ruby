module PayloadConvertingStrategies

  class ObligatoryOptionalConverter

    def convert(payload)
      if payload[:body].is_a? String
        payload[:body]
      else
        payload[:body][:obligatory] +
        payload[:body][:optional].first(Neo4rubyConfig[:payload][:optional_limit])
      end
    end

  end

end