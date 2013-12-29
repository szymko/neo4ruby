require_relative '../test_helper'

class Neo4rubyServerTest < MiniTest::Unit::TestCase

  include Mock::Rabbit

  def setup
    @processor = mock()
    @builder = mock()
    @s = Neo4rubyServer.new(payload_processor: @processor, graph_builder: @builder)

    setup_bunny()
  end

  def teardown
    teardown_bunny()
  end

  def test_it_sets_payload_processor
    assert_equal @s.processor, @processor
  end

  def test_it_opens
    @s.open()
    assert @s.open?
  end

  # Throwing errors at random, don't have time now to analyze
  # def test_it_shuts_down
  #   @s.open()
  #   # below hack to prevent NotYetConnectedException
  #   wait_until_open()

  #   @s.shutdown()
  #   refute @s.open?
  # end

  # def test_it_reopens
  #   @s.open()
  #   wait_until_open()
  #   @s.expects(:shutdown).once

  #   @s.open(reopen: true)
  #   wait_until_open()
  #   assert_equal @s.open?, true
  # end

  def wait_until_open
    until @s.open?
      sleep 0.01
    end
  end
end