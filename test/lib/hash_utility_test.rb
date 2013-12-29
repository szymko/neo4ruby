require_relative '../test_helper'

class HashUtilityTest < MiniTest::Unit::TestCase

  def test_it_symbolizes_keys
    h = { :a => 1, 'b' => { 'c' => { 'd' => 1 }, [1, 2] => 2 } }
    assert_equal HashUtility.symbolize_keys(h), { :a => 1, :b => { :c => { :d => 1 }, [1, 2] => 2 } }
  end

end
