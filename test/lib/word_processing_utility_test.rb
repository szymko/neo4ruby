require_relative '../test_helper'

class WordProcessingUtilityTest < MiniTest::Unit::TestCase

  def setup
    @utility = WordProcessingUtility.new
  end

  def test_it_deletes_short_words
    payload = ["costam", "a", "bc"]

    assert_equal ["costam", "bc"], @utility.delete_short_words(payload)
  end

  def test_it_deletes_words_no_longer_than_given_number
    payload = ["costam", "a", "bc"]

    assert_equal ["costam"], @utility.delete_short_words(payload, 3)
  end

  def test_it_splits_long_sentences
    payload = Array.new(10, "a")
    assert_equal [Array.new(7,"a"), Array.new(3,"a")], @utility.split_long_sentences(payload)
  end

  def test_it_splits_sentences_of_given_length
    payload = Array.new(10, "a")
    assert_equal [Array.new(5,"a"), Array.new(5,"a")], @utility.split_long_sentences(payload,5)
  end

end