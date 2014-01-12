module NeuralNetwork
  class Simulator

    attr_reader :steps, :neurons, :cache

    def initialize(init_strategy, opts = {})
      start_set = NeuronProxy.wrap(opts[:expression_set] || ExpressionProxy.all)
      @neurons = build_network(start_set)
      @steps = 0

      @alpha = opts[:alpha] || Neo4rubyConfig[:search_engine][:simulation][:alpha]
      @beta = opts[:beta] || Neo4rubyConfig[:search_engine][:simulation][:beta]
      @theta = opts[:theta] || Neo4rubyConfig[:search_engine][:simulation][:theta]

      @init_strategy = init_strategy
    end

    def startup(query)
      @init_strategy.initialize_neurons(query, @cache)
    end

    def run
      go_on = true
      while(go_on)
        step
        go_on = yield(self)
      end
    end

    def step
      clear_sum
      propagate_excitation
      set_excitation
      @steps += 1
    end

    def set_excitation
      @neurons.each do |n|
        n.prev_exc = n.exc
        n.exc = excitation_formula(n.input_sum, n.prev_exc)
      end
    end

    def propagate_excitation
      @neurons.each { |n| n.propagate_excitation }
    end

    def clear_sum
      @neurons.each { |n| n.input_sum = 0 }
    end

    def excitation_formula(input_sum, prev_exc)
      input_sum +
      if prev_exc < 0
        @alpha * prev_exc + ((@alpha - 1) * @beta * prev_exc**2)/@theta
      elsif (prev_exc >= 0) && (prev_exc < @theta)
        @alpha * prev_exc + ((1 - @alpha) * @beta * prev_exc**2)/@theta
      else
        - @beta * @theta
      end
    end

    def build_network(start_set)
      @cache = start_set.reduce({}) { |c, n| c[n.word] = n; c }
      start_set.each { |n| n.build_connections(@cache) }
    end

  end
end