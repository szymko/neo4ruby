module Builders
  class ExpressionBuilder

    def initialize(opts = {})
      @expressions = ExpressionCollection.new
      @update_cache = opts[:update_cache]
    end

    def build(opts) # opts = { word: , url: }
      @expressions.refresh_cache if @update_cache
      #e = (Expression.find_one(word: opts[:word]) || expr_cache[opts[:word]] )
      e = @expressions.find(opts[:word])
      unless e
        e = @expressions.create(word: opts[:word])
      end

      e.add_url(opts[:url])
      e
    end

    def increment_word_count(expressions)
      expressions.uniq { |expr| expr.word }.each { |e| e.increment(:count) }
    end

    def bind(expr1, expr2)
      expr1.find_or_create_outgoing(expr2)
    end

    private

    def build_cache
      Expression.all.to_a.reduce({}) do |h, e|
        h[e.word] = e
        e.load_outgoing
        h
      end
    end

  end
end