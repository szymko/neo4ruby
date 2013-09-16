require_relative '../test_helper'

class ExpressionTest < MiniTest::Unit::TestCase

  def setup
    Expression.delete_all
    create_two_expressions
  end

  def test_it_creates_expression
    assert_changed_by(1) { Expression.transaction_create(word: 'Mariusz') }
  end

  def test_it_finds_existing_expression
    assert_changed_by(1) do
      2.times { Expression.find_or_create(word: 'Pszemek') }
    end
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

  def test_it_knows_preceding_expressions
    @expression1.create_sequence(@expression2, dir: :incoming)
    assert_equal @expression1.incoming(:sequence).to_a, @expression1.preceding
  end

  def test_it_knows_following_expressions
    @expression1.create_sequence(@expression2, dir: :outgoing)
    assert_equal @expression1.outgoing(:sequence).to_a, @expression1.following
  end

  def test_it_finds_linked_expression
    @expression1.create_sequence(@expression2, dir: :outgoing)
    @expression1.find_or_create_outgoing(@expression2)
    assert_equal 1, @expression1.following.count
  end

  def test_it_adds_urls
    url1 = "http://www.google.pl"
    url2 = "https://www.facebook.com/Mariusz#alol"

    @expression1.add_url(url1)
    assert_equal [url1], @expression1.urls

    @expression1.add_url(url2)
    assert_equal [url1, url2].sort, @expression1.urls.sort
  end

  def test_it_raises_error_on_invalid_urls
    invalid_url = "http/:aawef.aff"
    assert_raises(ArgumentError) { @expression1.add_url(invalid_url) }
  end

  def test_urls_arent_duplicated
    url = "http://example.com"
    2.times { @expression1.add_url(url) }

    assert_equal 1, @expression1.urls.count
  end

  def test_it_returns_expressions_from_given_experiment
    Expression.transaction_create(word: 'badly', experiment: 'E1')

    assert_equal 2, Expression.from_experiment('E1').length
    assert_equal 1, Expression.from_experiment('E2').length
    assert_equal 0, Expression.from_experiment('E3').length
  end

  private

  def create_two_expressions
    @expression1 = Expression.transaction_create(word: 'Citation', experiment: 'E1')
    @expression2 = Expression.transaction_create(word: 'needed', experiment: 'E2')
  end

  def assert_changed_by(numbr)
    current = Expression.count
    yield

    assert numbr, Expression.count - current
  end
end