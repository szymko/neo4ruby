require_relative '../../test_db'
require_relative '../../model_helper'

MiniTest::Unit.runner = TestDb::Unit.new

class Builders::ExpressionBuilderTest < MiniTest::Unit::TestCase

  include ModelHelper
  include TestHelper

  def setup
    @expr_params = { word: 'e1', url: 'http://www.example.com' }
    @expr_builder = Builders::ExpressionBuilder.new(update_cache: true)
  end

  def teardown
    teardown_redis(Neo4rubyConfig[:experiment] + "::*")
    ExpressionProxy.destroy_all
  end

  def test_it_creates_nonexistent_expression
    assert_changed(model: ExpressionProxy, by: 1){
      @expr_builder.build(@expr_params)
    }
  end

  def test_it_finds_existent_expression
    expression = ExpressionProxy.create(@expr_params)
    assert_equal expression.getId, @expr_builder.build(@expr_params).getId
  end

  def test_it_creates_sequence
    expr1 = ExpressionProxy.create(@expr_params)
    expr2 = ExpressionProxy.create(@expr_params.merge(word: 'e2'))

    @expr_builder.bind(expr1, expr2)
    assert_equal expr1.following.first.getId, expr2.getId
  end

  def test_it_finds_existing_sequence
    expr1 = ExpressionProxy.create(@expr_params)
    expr2 = ExpressionProxy.create(@expr_params.merge(word: 'e2'))
    s = SequenceProxy.create(expr1, expr2)

    assert_equal @expr_builder.bind(expr1, expr2).getId, s.getId
  end

  def test_it_increments_word_count
    expr1 = ExpressionProxy.create(@expr_params)
    expr2 = ExpressionProxy.create(@expr_params.merge(word: 'e2'))

    @expr_builder.increment_word_count([expr1, expr2])
    assert_equal 1, expr1.count.to_f
  end
end