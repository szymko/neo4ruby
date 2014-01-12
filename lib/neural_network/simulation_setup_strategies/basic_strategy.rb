module NeuralNetwork
  module SimulationSetupStrategies
    class BasicStrategy

      def initialize(initializer, opts = {})
        @initializer = initializer
      end

      def initialize_neurons(query, neuron_cache)
        used_neurons = {}

        query.each do |word|
          if neuron_cache[word]
            used_neurons[word] = initialize_exact(word, neuron_cache)
          else
            used_neurons[word] = initialize_similar(word, neuron_cache)
          end
        end

        used_neurons
      end

      def initialize_exact(word, neuron_cache)
        raise NotImplementedError
      end

      def initialize_optional(word, neuron_cache)
        raise NotImplementedError
      end

    end
  end
end