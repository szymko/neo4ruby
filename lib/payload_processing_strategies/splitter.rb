module PayloadProcessingStrategies

  class Splitter < PayloadProcessingStrategies::BasicStrategy
 
    def initialize(opts)
      @rule = choose_rule(opts[:type], opts[:rule])
    end

    def concrete_perform(payload)
      payload.scan(@rule)
    end

    private

    def choose_rule(name, custom_rule)
      case name
      when :word
        /[^\s\.\?\!,:;"'\/\[\]\(\)-]+/
      when :sentence
        /[^.!?\s][^.!?]*(?:[.!?](?!['"]?\s|$)[^.!?]*)*[.!?]?['"]?(?=\s|$)/
      when :url
        /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/
      else
        custom_rule
      end
    end

  end

end
