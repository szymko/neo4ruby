module NeuralNetwork
  module ResponseScanningStrategies

    class StopwordRemover

      def initialize(opts = {})
        stopwords_path = opts[:stopwords_path] ||
                         Neo4rubyConfig[:search_engine][:response_scanning][:stopwords_file]
        @stopwords = File.read(stopwords_path).split("\n")
      end

      def perform(query, response)
        response.delete_if do |n|
          @stopwords.member?(n[:word]) && !query.member?(n[:word])
        end
      end

    end

  end
end