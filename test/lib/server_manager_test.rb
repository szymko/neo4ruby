require_relative '../test_helper'

class ServerManagerTest < MiniTest::Unit::TestCase

  def setup
    @server_manager = ServerManager.new(payload_processor: mock(),
                                        graph_builder: mock())
    @server = mock()
    Neo4rubyServer.stubs(:new).returns(@server)
  end

  def test_it_starts_server
    custom_queue = "Kolejka Pszemka"
    mock_run()

    @server_manager.options[:queue] = custom_queue
    mock_run(custom_queue)
  end

  def test_it_stops_server
    mock_run()
    @server.expects(:shutdown).once

    [true, false].each do |server_state|
      @server.stubs(:open?).returns(server_state)
      @server_manager.stop()
    end
  end

  def mock_run(queue = ServerManager::DEFAULT_QUEUE)
    @server.expects(:open)
    @server.expects(:listen).with(queue)
    @server_manager.run()
  end
end