module NeuralNetwork
  class Manager

    def initialize(opts)
      @simulator = opts[:simulator]
      @resolver = opts[:resolver]
      @terminator = opts[:terminator]
    end

    def answer_query(query)
      reset
      @simulator.startup(query)
      @simulator.run do |sim_state|
        @resolver.scan(sim_state, query)
        @terminator.terminate?(sim_state)
      end

      @resolver.get_answer
    end

    def reset
      @simulator.reset
      @resolver.reset
      @terminator.reset
    end

  end
end