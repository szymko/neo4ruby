require_relative '../test_helper'

class ExpressionTest < MiniTest::Unit::TestCase

  def setup
    Expression.delete_all
  end

  def test_it_creates_expression
    Expression.transaction_create(word: 'Mariusz')
    assert_equal Expression.all.to_a.count, 1
  end

  def test_it_finds_existing_expression
    assert_equal Expression.all.to_a.count, 0

    2.times do
      Expression.find_or_create(word: 'Pszemek')
      assert_equal Expression.all.to_a.count, 1
    end
  end

  def test_it_destroys_expression_after_cases
    assert_equal Expression.all.to_a.count, 0
  end

end