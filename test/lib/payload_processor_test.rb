require 'json'
require_relative '../test_helper'

class PayloadProcessorTest < MiniTest::Unit::TestCase

  def test_it_uses_delivered_strategies
    payload = { url: "http://www.example.com", body: "Bonjour, \t ca va?" }
    s1, s2 = mock(), mock()
    setup_strategies(s1, s2, payload[:body])
    p = PayloadProcessor.new([s1, s2])

    assert_equal payload, p.parse(payload.to_json)
  end

  def test_it_parses_page
    payload = { url: "http://www.example.com", body: "hello world" }
    builder = mock()
    opts = { page: payload.to_json, experiment: "test", builder: builder }
    s1 = setup_strategies(mock, payload[:body]).first

    builder.expects(:build).with(payload, opts)
    p = PayloadProcessor.new([s1])
    assert_equal("OK", p.run(opts))
  end

  def test_it_parses_payload_with_hash_in_body
    payload  = { url: "http://www.example.com", body: { some: "a", info: "b" } }

    s1 = mock()
    s1.expects(:perform).returns("A", "B").at_least_once
    p = PayloadProcessor.new([s1])
    assert_equal p.parse(payload.to_json),
                 { url: "http://www.example.com", body: { some: "A", info: "B" } }
  end

  def setup_strategies(*strategies, ret_val)
    strategies.each { |s| s.expects(:perform).with(ret_val).returns(ret_val) }
  end

end
