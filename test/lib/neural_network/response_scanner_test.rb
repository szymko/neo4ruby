require_relative '../../test_db'

MiniTest::Unit.runner = TestDb::Unit.new

class NeuralNetwork::ResponseScannerTest < MiniTest::Unit::TestCase

  class SimpleCommand
    def perform(response, query)
      response
    end
  end

  class ComplexCommand
    def perform(response, query)
      response.reverse
    end
  end

  def setup
    @n1 = NeuronProxy.new(ExpressionProxy.create(word: "the"))
    @n2 = NeuronProxy.new(ExpressionProxy.create(word: "doge"))
    @n3 = NeuronProxy.new(ExpressionProxy.create(word: "cate"))
  end

  def teardown
    ExpressionProxy.destroy_all
  end

  def test_it_retrieves_most_active_neurons
    @n1.exc = 1.0
    @n2.exc = 0.3
    @n3.exc = 0.7

    neurons = [@n1, @n2, @n3]
    s = SimpleCommand.new
    scanner = NeuralNetwork::ResponseScanner.new([s], scanning_limit: 2)

    assert_equal [neuron_to_hash(@n1), neuron_to_hash(@n3)],
                 scanner.scan(neurons, "")
  end

  def test_it_applies_commands
    @n1.exc = 1.0
    @n2.exc = 0.3
    @n3.exc = 0.7

    neurons = [@n1, @n2, @n3]
    s1 = SimpleCommand.new
    s2 = ComplexCommand.new
    scanner = NeuralNetwork::ResponseScanner.new([s1, s2], scanning_limit: 2)

    assert_equal [neuron_to_hash(@n2), neuron_to_hash(@n3)],
                 scanner.scan(neurons, "")
  end

  def neuron_to_hash(n)
    { urls: n.urls, word: n.word, exc: n.exc }
  end

end