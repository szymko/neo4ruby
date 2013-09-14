class Article

  attr_accessor :chain, :word_ary, :url

  def sequence_feed(word_ary, url)
    @word_ary = word_ary
    @url = url

    @chain = create_representation(word_ary, url)
    @chain.each_cons(2) { |exprs| exprs[0].find_or_create_outgoing(exprs[1]) }

    @chain
  end

  def adjust_weights(associative_engine)
    @chain.each { |expr| associative_engine.adjust_wieghts(expr) }
  end

  def self.find
  end

  private

  def create_representation(word_ary, url)
    word_ary.inject([]) do |chain, expr|
      e = Expression.find_or_create(word: expr)
      e.add_url(url)
      chain << e
    end
  end
end