require_relative '../../../test_db'

MiniTest::Unit.runner = TestDb::Unit.new

class NeuralNetwork::SimulationSetupStrategies::LevenshteinStrategyTest < MiniTest::Unit::TestCase

  def setup
    @initializer = mock()
  end

  def teardown
    Expression.destroy_all
  end

  def test_it_initializes_neurons_exactly_matching_query
    strat = NeuralNetwork::SimulationSetupStrategies::
            LevenshteinStrategy.new(@initializer)
    query = ["test", "query"]
    n1, n2 = mock(), mock()

    neuron_cache = { "test" => n1, "query" => n2 }
    @initializer.expects(:set_exc).returns(1.0).twice

    assert_equal strat.initialize_neurons(query, neuron_cache),
                 { "test" => n1, "query" => n2 }
  end

  def test_it_initializes_neurons_within_given_levenshtein_distance
    set_levenshtein_distance(1)
    strat = NeuralNetwork::SimulationSetupStrategies::
            LevenshteinStrategy.new(@initializer)

    query = ["test", "query"]
    n1, n2 = mock(), mock()
    neuron_cache = { "tes" => n1, "quari" => n2 }

    @initializer.expects(:set_exc).returns(1.0).with(n1)
    assert_equal strat.initialize_neurons(query, neuron_cache),
                 { "test" => n1, "query" => nil }
  end

  def test_it_finds_neurons_most_similar_to_query
    set_levenshtein_distance(2)
    strat = NeuralNetwork::SimulationSetupStrategies::
            LevenshteinStrategy.new(@initializer)

    query = ["test"]
    n1, n2 = mock(), mock()
    neuron_cache = { "tes" => n1, "tisg" => n2 }

    @initializer.expects(:set_exc).with(n1)
    strat.initialize_neurons(query, neuron_cache)
  end

  def test_it_doesnt_initialize_neurons_not_similar_to_query
    set_levenshtein_distance(1)
    strat = NeuralNetwork::SimulationSetupStrategies::
            LevenshteinStrategy.new(@initializer)

    query = ["a"]
    n = mock()
    neuron_cache = { "abc" => n }
    @initializer.expects(:set_exc).never
    assert_equal strat.initialize_neurons(query, neuron_cache),
                 { "a" => nil }
  end

  def test_it_sets_excitement_values
    init = NeuralNetwork::Initializers::SimpleInitializer.new(initial_exc: 0.9)
    n1 = NeuronProxy.new(ExpressionProxy.create(word: "test"))
    n2 = NeuronProxy.new(ExpressionProxy.create(word: "quer"))
    n3 = NeuronProxy.new(ExpressionProxy.create(word: "minitest"))

    strat = NeuralNetwork::SimulationSetupStrategies::
            LevenshteinStrategy.new(init)

    query = ["test", "query"]
    cache = { "test" => n1, "query" => n2 }
    assert_equal strat.initialize_neurons(query, cache),
                 { "test" => n1, "query" => n2 }
    assert_in_delta 0.9, n1.exc, 0.01
    assert_in_delta 0.9, n2.exc, 0.01
    assert_in_delta 0.0, n3.exc, 0.01
  end

  def set_levenshtein_distance(val)
    Neo4rubyConfig[:search_engine][:response_scanning][:levenshtein_max] = val
  end

end