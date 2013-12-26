require_relative '../test_helper'

MiniTest::Unit.runner = DbTest::Unit.new

class GraphBuilderTest < MiniTest::Unit::TestCase

  def teardown
    Expression.destroy_all
  end

  def test_it_builds_graph
    builder = mock
    builder.expects(:build).times(4)
    builder.expects(:increment_word_count).times(4)

    engine = mock
    engine.expects(:bind_nodes).times(4)

    payload = { url: 'http://www.example.com/', body: ['a', 'b', 'c', 'd'] }

    gb = GraphBuilder.new(expression_builder: builder, assoc_engine: engine)
    gb.build(payload, experiment: 'e1')

  end

  # complex integration test based on
  # "Sztuczne systemy skojarzeniowe i asocjacyjna sztuczna inteligencja", page 232
  def test_on_example_from_book
    Expression.delete_all
    engine = AssocEngine.new
    expr_builder = ExpressionBuilder.new

    opts = { experiment: "ASDF", sequence_size: 1 }
    payload = { url: "http://www.example.com/", body: [["e1", "e2", "e3"],
                ["e4", "e5", "e2", "e6"], ["e7", "e5", "e2", "e8"],
                ["e7", "e9", "e8"], ["e4", "e2" ,"e3"]] }

    gb = GraphBuilder.new(expression_builder: expr_builder, assoc_engine: engine)
    gb.build(payload, opts)

    e = []
    10.times { |t| e << Expression.find_one(word: "e#{t+1}") }
    delta = 0.01

    assert_in_delta 1.00, e[0].sequence_to(e[1]).weight, delta
    assert_in_delta 0.66, e[0].sequence_to(e[2]).weight, delta
    assert_in_delta 0.66, e[1].sequence_to(e[2]).weight, delta
    assert_in_delta 0.40, e[1].sequence_to(e[5]).weight, delta
    assert_in_delta 0.40, e[1].sequence_to(e[7]).weight, delta
  end
end