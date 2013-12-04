class ExpressionBuilder

  def build(opts) # opts = { word: , url: , experiment: }
    e = Expression.find_or_create(word: opts[:word],
                                  experiment: opts[:experiment])
    e.add_url(opts[:url])
  end

  def increment_word_count(expressions)
    expressions.uniq { |expr| expr.word }.each { |e| e.increment(:count) }
  end

  def bind(expr1, expr2)
    (expr1.sequences.find { |s|
      s.nodes.map(&:word).sort == [expr1, expr2].map(&:word).sort
    }) || Sequence.transaction_create(expr1, expr2)
  end

end
