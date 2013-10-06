require_relative '../test_helper'

PROCESSOR_LIST = [PayloadProcessor, TestHelper::ProcesorPszemka]

class ServerManagerTest < MiniTest::Unit::TestCase

  def setup
    @server_manager = ServerManager.new
    @server_manager.options[:silent] = true
    @server = mock()
    Neo4rubyServer.stubs(:new).returns(@server)
  end

  def test_it_presents_processor_list
    @server_manager.expects(:puts).with("Available payload processors:\n#{PROCESSOR_LIST.join("\n")}")
    @server_manager.present_processor_list()
  end

  def test_it_selects_default_payload_processor
    @server_manager.select_payload_processor()
    assert_instance_of DEFAULT_PROCESSOR, @server_manager.processor
  end

  def test_it_selects_payload_processor_according_to_options
    @server_manager.options[:processor] = "TestHelper::ProcesorPszemka"
    @server_manager.select_payload_processor()

    assert_instance_of TestHelper::ProcesorPszemka, @server_manager.processor
  end

  def test_it_falls_back_to_default_processor
    @server_manager.options[:processor] = "SecretAndHidden"
    @server_manager.select_payload_processor()

    assert_instance_of DEFAULT_PROCESSOR, @server_manager.processor
  end

  def test_it_starts_server
    custom_queue = "Kolejka Pszemka"
    mock_start_server()

    @server_manager.options[:queue] = custom_queue
    mock_start_server(custom_queue)
  end

  def test_it_stops_server
    mock_start_server()
    @server.expects(:shutdown).once

    [true, false].each do |server_state|
      @server.stubs(:open?).returns(server_state)
      @server_manager.stop()
    end
  end

  def test_it_runs_according_to_the_options
    @server_manager.options[:list] = true
    @server_manager.expects(:present_processor_list).once
    @server_manager.run()

    @server_manager.options[:list] = false
    @server_manager.expects(:select_payload_processor).once
    @server_manager.expects(:start_server).once
    @server_manager.run()
  end

  def mock_start_server(queue = ServerManager::DEFAULT_QUEUE)
    @server.expects(:open)
    @server.expects(:listen).with(queue)
    @server_manager.start_server()
  end
end