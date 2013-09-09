module Article
  def self.sequence_feed(article)
    chain = article.inject { |chain, expr| chain << Expression.find_or_create(expr) }

    chain.each_cons(2) do |exprs|
      s = exprs[0].find_or_create_outgoing(exprs[1])
      yield s
    end

    chain
  end
end