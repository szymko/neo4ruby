require_relative '../test_helper'

class Neo4rubyServerTest < MiniTest::Unit::TestCase

  include Mock::Rabbit

  def setup
    @processor = mock()
    @s = Neo4rubyServer.new(@processor)

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

  def test_it_shuts_down
    @s.open()
    @s.shutdown()
    refute @s.open?
  end

  def test_it_reopens
    @s.open()

    @s.expects(:shutdown).once

    @s.open(reopen: true)
    assert_equal @s.open?, true
  end
end