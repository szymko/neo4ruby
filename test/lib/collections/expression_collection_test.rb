require_relative '../../test_db'
require_relative '../../model_helper'

MiniTest::Unit.runner = TestDb::Unit.new

class ExpressionCollectionTest < MiniTest::Unit::TestCase

  include ModelHelper

  def setup
    @expr1 = ExpressionProxy.create(word: "citation")
    @expr2 = ExpressionProxy.create(word: "needed")
    @c = ExpressionCollection.new
  end

  def teardown
    ExpressionProxy.destroy_all
  end

  def test_it_load_expressions_into_memory
    assert_equal @c.cache, { "citation" => @expr1, "needed" => @expr2 }
  end

  def test_it_finds_expression_by_word
    assert_equal @expr2, @c.find("needed")
  end

  def test_it_creates_expression
    assert_changed(model: ExpressionProxy, by: 1) {
      @c.create(word: "badly")
    }
  end

  def test_it_adds_new_expression_to_cache
    @c.create(word: "nope")
    assert @c.find("nope")
  end

  def test_it_refreshes_cache
    ExpressionProxy.create(word: "wat")
    assert_nil @c.find("wat")

    @c.refresh_cache
    assert @c.find("wat")
  end

  def test_it_adds_to_cache
    e = ExpressionProxy.create(word: "qwerty")
    @c.add_to_cache(e)

    assert @c.find("qwerty")
  end

  def test_it_finds_existing_expression_in_find_or_create
    assert @c.find_or_create("citation"), @expr1
  end

  def test_it_creates_nonexisting_expressiong_in_find_or_create
    assert_changed(model: ExpressionProxy, by: 1) {
      @c.find_or_create("waat")
    }
  end

end