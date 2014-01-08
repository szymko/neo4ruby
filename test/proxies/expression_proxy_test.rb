require_relative '../test_db'
require_relative '../model_helper'

MiniTest::Unit.runner = TestDb::Unit.new

class ExpressionProxyTest < MiniTest::Unit::TestCase

  include ModelHelper

  def setup
    @expression1 = ExpressionProxy.create(word: 'Citation')
    @expression2 = ExpressionProxy.create(word: 'needed')
  end

  def teardown
    @expression1.clear_cache
    @expression2.clear_cache
    ExpressionProxy.destroy_all
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

  def test_it_finds_sequence
    s1 = @expression1.create_sequence(@expression2, dir: :outgoing)
    s2 = @expression1.sequence_to(@expression2)
    assert_equal s1.getId, s2.getId
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

end