module Builders
  class ExpressionBuilder

    def initialize(opts = {})
      @update_cache = opts[:update_cache]
    end

    def build(opts) # opts = { word: , url: }
      @expressions ||= ExpressionCollection.new
      @expressions.refresh_cache if @update_cache
      e = @expressions.find_or_create(opts[:word])

      e.add_url(opts[:url])
      e
    end

    def increment_word_count(expressions)
      expressions.uniq { |expr| expr.word }.each { |e| e.increment(:count) }
    end

    def bind(expr1, expr2)
      expr1.find_or_create_outgoing(expr2)
    end

  end
end