require 'text'

module NeuralNetwork
  module SimulationSetupStrategies
    class LevenshteinStrategy < NeuralNetwork::SimulationSetupStrategies::BasicStrategy

      def initialize(initializer, opts = {})
        @max_distance = opts[:max_distance] ||
                        Neo4rubyConfig[:search_engine][:response_scanning][:levenshtein_max]
        super
      end

      private

      def initialize_exact(word, neuron_cache)
        @initializer.set_exc(neuron_cache[word])
        neuron_cache[word]
      end

      def initialize_similar(word, neuron_cache)
        similar = find_similar(neuron_cache.keys, word)
        @initializer.set_exc(neuron_cache[similar]) if similar
        neuron_cache[similar]
      end

      def find_similar(set, word)
        best = nil
        best_distance = @max_distance + 1

        set.each do |s|
          distance = Text::Levenshtein.distance(word, s)
          if distance <= @max_distance && distance < best_distance
            best = s
            best_distance = distance
          end
        end

        best
      end

    end
  end
end