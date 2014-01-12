module NeuralNetwork
  module Initializers
    class SimpleInitializer

      def initialize(opts = {})
        @initial_exc = opts[:initial_exc] ||
                       Neo4rubyConfig[:simulation][:initial_exc]
      end

      def set_exc(neuron)
        neuron.exc = @initial_exc
      end

    end
  end
end