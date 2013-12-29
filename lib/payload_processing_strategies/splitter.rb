module PayloadProcessingStrategies

  class Splitter < PayloadProcessingStrategies::BasicStrategy

    def initialize(opts)
      @type = opts[:type]
      @word_utility = opts[:word_utility]
      @rule = choose_rule(opts[:type], opts[:rule])
    end

    def concrete_perform(payload)
      res = payload.scan(@rule).map { |s| s.is_a?(Array) ? s.first : s }.flatten
      use_word_utility? ? additional_processing(res) : res
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

    def additional_processing(payload)
      @callback = :flatten_result
      @utility ||= WordProcessingUtility.new
      res = @utility.delete_short_words(payload, Neo4RubyConfig[:payload][:min_word_length])
      @utility.split_long_sentences(res, Neo4RubyConfig[:payload][:max_sentence_length])
    end

    def flatten_result(res)
      res.flatten(1)
    end

    def use_word_utility?
      (@type == :word && @word_utility)
    end

  end

end