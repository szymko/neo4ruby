module NeuralNetwork
  class ResponseScanner

    def initialize(strategies, opts = {})
      @limit = opts[:scanning_limit] ||
                        Neo4rubyConfig[:search_engine][:response_scanning][:limit]
      @strategies = strategies
    end

    def scan(query, simulator)
      best = simulator.neurons.sort { |n1, n2| n2.exc <=> n1.exc }.
                               limit(@limit)

      res =  best.map { |n| { urls: n.urls, word: n.word, exc: n.exc } }
      @strategies.reduce(res) { |r, s| r = s.perform(query, r) }.first(@limit)
    end

  end
end