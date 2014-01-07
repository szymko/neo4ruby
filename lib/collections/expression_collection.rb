class ExpressionCollection

  def find(word)
    cache[word.to_s]
  end

  def refresh_cache
    @expr_cache = nil
    cache
  end

  def cache
    @expr_cache ||= ExpressionProxy.all.reduce({}) do |h, e|
      h[e.get_prop(by_attr)] = ExpressionProxy.new(e)
      h
    end
  end

  def create(attrs)
    add_to_cache(ExpressionProxy.create(attrs))
  end

  def add_to_cache(*exprs)
    exprs.flatten.each do |e|
      cache[e.word] = (e.is_a? ExpressionProxy) ? e : ExpressionProxy.new(e)
    end
  end

end