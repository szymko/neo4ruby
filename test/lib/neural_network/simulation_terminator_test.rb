require_relative '../../test_helper'

class NeuralNetwork::SimulationTerminatorTest < MiniTest::Unit::TestCase

  def setup
    @simulator = mock
  end

  def test_it_doesnt_terminate_too_early
    n1 = stub(exc: 1.0)
    n2 = stub(exc: 0.7)
    @simulator.expects(:neurons).returns([n1, n2]).twice
    terminator = NeuralNetwork::SimulationTerminator.new

    2.times { assert !terminator.terminate?(@simulator) }
  end

  def test_it_doesnt_terminate_good_change_rate
    n1, n2 = mock, mock

    n1.stubs(:exc).returns(1.0, 1.0, 0.3)
    n2.stubs(:exc).returns(-0.3, -0.2, -0.6)

    @simulator.expects(:neurons).returns([n1, n2]).times(3)
    terminator = NeuralNetwork::SimulationTerminator.new(min_change_rate: 0.1)
    3.times { assert !terminator.terminate?(@simulator) }
  end

  def test_it_terminates_stale_change_rate
    n1, n2 = mock, mock

    n1.stubs(:exc).returns(1.0, 1.0, 1.0)
    n2.stubs(:exc).returns(-0.3, -0.2, -0.3)

    @simulator.expects(:neurons).returns([n1, n2]).times(3)
    terminator = NeuralNetwork::SimulationTerminator.new(min_change_rate: 0.5)
    2.times { terminator.terminate?(@simulator) }
    assert terminator.terminate?(@simulator)
  end

end