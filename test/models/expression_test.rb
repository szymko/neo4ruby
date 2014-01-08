require_relative '../test_db'
require_relative '../model_helper'

MiniTest::Unit.runner = TestDb::Unit.new

class ExpressionTest < MiniTest::Unit::TestCase

  include ModelHelper

  def setup
    @expression1 = Expression.transaction_create
    @expression2 = Expression.transaction_create
  end

  def teardown
    Expression.destroy_all
  end

  def test_it_creates_expression
    assert_changed_by(1) { Expression.transaction_create(word: 'Mariusz') }
  end

  def test_it_destroys_all
    assert_changed_by(Expression.count) { Expression.destroy_all }
  end

  def test_it_creates_incoming_sequence
    @expression1.create_sequence(@expression2, dir: :incoming)
    assert_equal @expression1.incoming(:sequence).to_a,  [@expression2]
    assert_equal @expression2.outgoing(:sequence).to_a,  [@expression1]
  end

  def test_it_creates_outgoing_sequence
    @expression1.create_sequence(@expression2, dir: :outgoing)
    assert_equal @expression1.outgoing(:sequence).to_a,  [@expression2]
    assert_equal @expression2.incoming(:sequence).to_a,  [@expression1]
  end

  def test_it_creates_outgoing_sequence_by_default
    @expression1.create_sequence(@expression2)
    assert_equal @expression1.outgoing(:sequence).to_a,  [@expression2]
    assert_equal @expression2.incoming(:sequence).to_a,  [@expression1]
  end

  private

  def assert_changed_by(amount, &block)
    assert_changed(model: Expression, by: amount, &block)
  end

end