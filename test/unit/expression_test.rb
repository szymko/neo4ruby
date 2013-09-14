require_relative '../test_helper'

class ExpressionTest < MiniTest::Unit::TestCase

  def setup
    Expression.delete_all
  end

  def test_it_creates_expression
    assert_equal Expression.all.to_a.count, 0

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

  def test_it_creates_incoming_sequence
    create_two_expressions

    @e1.create_sequence(@e2, dir: :incoming)
    assert_equal @e1.incoming(:sequence).to_a,  [@e2]
    assert_equal @e2.outgoing(:sequence).to_a,  [@e1]
  end

  def test_it_creates_outgoing_sequence
    2.times do |t|
      create_two_expressions

      t == 0 ? @e1.create_sequence(@e2, dir: :outgoing) : @e1.create_sequence(@e2)
      assert_equal @e1.outgoing(:sequence).to_a,  [@e2]
      assert_equal @e2.incoming(:sequence).to_a,  [@e1]

      Expression.delete_all
    end
  end

  def test_it_knows_preceding_expressions
    create_two_expressions

    @e1.create_sequence(@e2, dir: :incoming)
    assert_equal @e1.incoming(:sequence).to_a, @e1.preceding
  end

  def test_it_knows_following_expressions
     create_two_expressions

    @e1.create_sequence(@e2, dir: :incoming)
    assert_equal @e2.outgoing(:sequence).to_a, @e2.following
  end

  private

  def create_two_expressions
    @e1 = Expression.transaction_create(word: 'Citation')
    @e2 = Expression.transaction_create(word: 'needed')
  end
end