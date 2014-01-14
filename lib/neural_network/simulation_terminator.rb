module NeuralNetwork

  class SimulationTerminator

    def initialize(opts = {})
      @min_change_rate = opts[:min_change_rate] ||
                         Neo4rubyConfig[:search_engine][:simulation][:min_change_rate]
      @activity_history = []
    end

    def terminate?(simulator)
      activity = compute_activity(simulator.neurons)
      @activity_history << activity

      if @activity_history.length < 3
        false
      else
        # naive, very! but hopefully will work most of the time
        # maybe compute rate change of every neuron? but very costly
        @activity_history.shift(1) if @activity_history.length > 3
        compute_change_rate < @min_change_rate
      end
    end

    private

    def compute_activity(neurons)
      neurons.reduce(0) { |s, n| s += n.exc }
    end

    def compute_change_rate
      ((@activity_history[0] - @activity_history[2]).to_f /
        @activity_history[0]).abs
    end

  end

end