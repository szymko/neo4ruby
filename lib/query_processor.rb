class QueryProcessor

  def initialize(strategies)
    @strategies = strategies
  end

  def run(query)
    @strategies.reduce(query) { |r, s| r = s.perform(r)  }
  end

end