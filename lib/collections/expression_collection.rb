class ExpressionCollection

  def initialize
    cache
  end

  def find(word)
    cache[word.to_s]
  end

  def refresh_cache
    @expr_cache = nil
    cache
  end

  def cache
    @expr_cache ||= ExpressionProxy.all.reduce({}) do |h, e|
      h[e.word] = e
      e.load_cache
      h
    end
  end

  def create(attrs)
    e = ExpressionProxy.create(attrs)
    add_to_cache(e)
    e.load_cache
    e
  end

  def add_to_cache(*exprs)
    exprs.flatten.each do |e|
      ep = (e.is_a? ExpressionProxy) ? e : ExpressionProxy.new(e)
      cache[ep.word] = ep
    end
  end

  def find_or_create(word)
    find(word) || create(word: word)
  end

  def save_properties
    cache.values.each do |e|
      e.save_properties
      e.sequences.each{ |s| s.save_properties }
    end
  end

end