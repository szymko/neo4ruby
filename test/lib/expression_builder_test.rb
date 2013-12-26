require_relative '../db_test'
require_relative '../model_helper'

MiniTest::Unit.runner = DbTest::Unit.new

class ExpressionBuilderTest < MiniTest::Unit::TestCase

  include ModelHelper

  def setup
    @expr_params = { url: 'http://en.wikipedia.org/',
                     experiment: 'Dexters Lab, here I come!',
                     word: 'e1'
                   }
    @expr_builder = ExpressionBuilder.new
  end

  def teardown
    Expression.destroy_all
  end

  def test_it_creates_nonexistent_expression
    assert_changed(model: Expression, by: 1){
      @expr_builder.build(@expr_params)
    }
  end

  def test_it_finds_existent_expression
    expression = Expression.transaction_create(@expr_params)
    assert_equal expression.getId, @expr_builder.build(@expr_params).getId
  end

  def test_it_creates_sequence
    expr1 = Expression.transaction_create(@expr_params)
    expr2 = Expression.transaction_create(@expr_params.merge(word: 'e2'))

    @expr_builder.bind(expr1, expr2)
    assert_equal expr1.following.first.getId, expr2.getId
  end

  def test_it_finds_existing_sequence
    expr1 = Expression.transaction_create(@expr_params)
    expr2 = Expression.transaction_create(@expr_params.merge(word: 'e2'))
    s = Sequence.transaction_create(expr1, expr2)

    assert_equal @expr_builder.bind(expr1, expr2).getId, s.getId
  end

  def test_it_increments_word_count
    expr1 = Expression.transaction_create(@expr_params)
    expr2 = Expression.transaction_create(@expr_params.merge(word: 'e2'))

    @expr_builder.increment_word_count([expr1, expr2])
    assert_equal 1, expr1.count
  end
end