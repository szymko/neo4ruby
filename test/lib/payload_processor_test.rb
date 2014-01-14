require 'json'
require_relative '../test_helper'

class PayloadProcessorTest < MiniTest::Unit::TestCase

  def test_it_uses_delivered_commands
    payload = { url: "http://www.example.com", body: "Bonjour, \t ca va?" }
    c1, c2 = mock(), mock()
    setup_commands(c1, c2, payload[:body])
    p = PayloadProcessor.new([c1, c2])

    assert_equal payload, p.parse(payload.to_json)
  end

  def test_it_parses_page
    payload = { url: "http://www.example.com", body: "hello world" }
    builder = mock()
    opts = { page: payload.to_json, experiment: "test", builder: builder }
    c1 = setup_commands(mock, payload[:body]).first

    builder.expects(:build).with(payload, opts)
    p = PayloadProcessor.new([c1])
    assert_equal(true, p.run(opts))
  end

  def test_it_parses_payload_with_hash_in_body
    payload  = { url: "http://www.example.com", body: { some: "a", info: "b" } }

    c1 = mock()
    c1.expects(:perform).returns("A", "B").at_least_once
    p = PayloadProcessor.new([c1])
    assert_equal p.parse(payload.to_json),
                 { url: "http://www.example.com", body: { some: "A", info: "B" } }
  end

  def setup_commands(*commands, ret_val)
    commands.each { |c| c.expects(:perform).with(ret_val).returns(ret_val) }
  end

end
