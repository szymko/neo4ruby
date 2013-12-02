class ArticleBuilder

  def initialize(strategies)
    @strat = strategies
  end

  def build(payload)
    res = payload
    @strat.each { |s| res = s.perform(res) }
    res
  end

end
