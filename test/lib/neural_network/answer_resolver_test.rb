require_relative '../../test_helper'

class NeuralNetwork::AnswerResolverTest < MiniTest::Unit::TestCase

  def setup
    @scanner = mock
  end

  def test_it_scans_simulation
    neurons, simulator, query = mock, mock, mock
    simulator.expects(:neurons).returns(neurons).times(3)
    @scanner.expects(:scan).with(neurons, query).returns(["nope"]).times(3)
    resolver = NeuralNetwork::AnswerResolver.new(@scanner)
    2.times { resolver.scan(simulator, query) }

    assert_equal [["nope"], ["nope"], ["nope"]], resolver.scan(simulator, query)
  end

  def test_it_gets_the_answer
    simulator = stub(:neurons)
    resolver = NeuralNetwork::AnswerResolver.new(@scanner, limit: 2)
    answers = [ { word: "yeah", exc: 1.0, urls: ["http://f.com", "http://b.ly"] },
                { word: "nope", exc: -0.3, urls: ["http://f.com"] },
                { word: "meh",  exc: 0.8, urls: ["http://b.ly", "http://a.net"] } ]
    @scanner.stubs(:scan).returns(answers)

    resolver.scan(simulator, simulator)
    assert_equal resolver.get_answer,
                 "http://b.ly" => { score: 1.8, words: ["yeah", "meh"] },
                 "http://a.net" => { score: 0.8, words: ["meh"] }
  end
end