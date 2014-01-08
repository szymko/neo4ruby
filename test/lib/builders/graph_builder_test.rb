require_relative '../../test_helper'
require_relative '../../test_db'

MiniTest::Unit.runner = TestDb::Unit.new

class Builders::GraphBuilderTest < MiniTest::Unit::TestCase

  def teardown
    Expression.destroy_all
  end

  class SimpleConverter

    def convert(payload)
      payload[:body]
    end

  end

  def test_it_builds_graph
    builder = mock
    builder.expects(:build).times(4)
    builder.expects(:increment_word_count).times(4)

    engine = mock
    engine.expects(:bind_nodes).times(4)

    converter = mock
    converter.expects(:convert).times(1).returns(["a", "b", "c", "d"])

    payload = { url: "http://www.example.com/", body: ["a", "b", "c", "d"] }

    gb = Builders::GraphBuilder.new(expression_builder: builder,
                                    assoc_engine: engine,
                                    payload_converter: converter)
    gb.build(payload, experiment: "e1")

  end

  # complex integration test based on
  # "Sztuczne systemy skojarzeniowe i asocjacyjna sztuczna inteligencja", page 232
  def test_on_example_from_book
    ExpressionProxy.delete_all
    engine = AssocEngine.new
    expr_builder = Builders::ExpressionBuilder.new
    converter = SimpleConverter.new

    opts = { experiment: "ASDF", sequence_size: 1 }
    payload = { url: "http://www.example.com/", body: [["e1", "e2", "e3"],
                ["e4", "e5", "e2", "e6"], ["e7", "e5", "e2", "e8"],
                ["e7", "e9", "e8"], ["e4", "e2" ,"e3"]] }

    gb = Builders::GraphBuilder.new(expression_builder: expr_builder,
                                    assoc_engine: engine,
                                    payload_converter: converter)
    gb.build(payload, opts)

    e = ExpressionCollection.new
    delta = 0.01

    assert_in_delta 1.00, weight_between(e, "e1", "e2"), delta
    assert_in_delta 0.66, weight_between(e, "e1", "e3"), delta
    assert_in_delta 0.66, weight_between(e, "e2", "e3"), delta
    assert_in_delta 0.40, weight_between(e, "e2", "e6"), delta
    assert_in_delta 0.40, weight_between(e, "e2", "e8"), delta
  end

  def weight_between(collection, word1, word2)
    collection.find(word1).sequence_to(collection.find(word2)).weight
  end
end