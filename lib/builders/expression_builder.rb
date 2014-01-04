module Builders
  class ExpressionBuilder

    def initialize
      @expr_cache = []
    end

    def build(opts) # opts = { word: , url: }
      e = (Expression.find_one(word: opts[:word]) || @expr_cache.find { |e| e.word == opts[:word] })
      unless e
        e = Expression.transaction_create(word: opts[:word])
        @expr_cache << e
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

    def clear_expr_cache
      @expr_cache = []
    end

  end
end