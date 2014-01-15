module SimulationStartup

  def start_simulation
    Neo4rubyLogger.log(level: :info, msg: "Loading neural network...")

    initializer = NeuralNetwork::Initializers::
                  SimpleInitializer.new
    terminator = NeuralNetwork::SimulationTerminator.new
    scanning_comm = NeuralNetwork::ResponseScanningCommands::
                    StopwordRemover.new

    startup_strat = NeuralNetwork::SimulationSetupStrategies::
                    LevenshteinStrategy.new(initializer)
    simulator = NeuralNetwork::Simulator.new(startup_strat)
    scanner = NeuralNetwork::ResponseScanner.new([scanning_comm])
    resolver = NeuralNetwork::AnswerResolver.new(scanner)

    manager = NeuralNetwork::Manager.new(simulator: simulator, resolver: resolver,
                               terminator: terminator)

    Neo4rubyLogger.log(level: :info, msg: "Neural network loaded.")
    manager
  end

  def start_query_processor
    commands = [PayloadProcessingCommands::Splitter.new(type: :word)]
    QueryProcessor.new(commands)
  end
end