module NeuralNetwork
  class ResponseScanner < BasicCommandUtilizer

    def initialize(commands, opts = {})
      @limit = opts[:scanning_limit] ||
                        Neo4rubyConfig[:search_engine][:response_scanning][:limit]
      super
    end

    def scan(neurons, query)
      best = neurons.sort { |n1, n2| n2.exc <=> n1.exc }

      res =  best.map { |n| { urls: n.urls, word: n.word, exc: n.exc } }
      apply_commands(res, query).first(@limit)
    end

  end
end