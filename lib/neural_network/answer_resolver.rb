module NeuralNetwork
  class AnswerResolver

    def initialize(scanner, opts = {})
      @limit = opts[:limit] ||
               Neo4rubyConfig[:search_engine][:answer_resolving][:limit]
      @scanner = scanner
      @answers = []
    end

    def scan(simulator, query)
      @answers << @scanner.scan(simulator.neurons, query)
    end


    def get_answer
      @rating = {}

      @answers.each { |it| it.each { |neuron| add_to_rating(neuron) } }

      res = @rating.sort { |p1, p2| p2[1][:score] <=> p1[1][:score] }.first(@limit)
      res.reduce({}) { |h, e| h[e[0]] = e[1]; h }
    end

    private

    def add_to_rating(neuron)
      neuron[:urls].each do |u|
        @rating[u] ||= {}

        @rating[u][:score] =
          (@rating[u][:score] ? @rating[u][:score] + neuron[:exc] : neuron[:exc])

        @rating[u][:words] =
          (@rating[u][:words] ? @rating[u][:words] << neuron[:word] : [neuron[:word]] )
      end
    end

  end
end