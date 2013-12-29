require_relative '../../test_helper'

class PayloadProcessingStrategies::SplitterTest < MiniTest::Unit::TestCase

  def test_it_finds_all_words_in_sentence
    s = PayloadProcessingStrategies::Splitter.new(type: :word)
    payload = 'Some, funny, : []( "sentence"'
    assert_equal(["Some", "funny", "sentence"], s.perform(payload))
  end

  def test_it_finds_sentences
    s = PayloadProcessingStrategies::Splitter.new(type: :sentence)
    payload = 'First sentence... Second, sentence? Third! "Fourth."'

    assert_equal(['First sentence...', 'Second, sentence?', 'Third!', '"Fourth."'],
                 s.perform(payload))
  end

  def test_it_find_urls
    s = PayloadProcessingStrategies::Splitter.new(type: :url)
    payload = '"http://www.example.com" aeawf costam'

    assert_equal(['http://www.example.com'], s.perform(payload))
  end

  def test_it_uses_custom_rules
    s = PayloadProcessingStrategies::Splitter.new(type: :custom, rule: /(\d+)/)
    payload = "111aaa2222"

    assert_equal(['111', '2222'], s.perform(payload))
  end

  def test_it_uses_word_processing_utility
    s = PayloadProcessingStrategies::Splitter.new(type: :word, word_utility: true)
    Neo4RubyConfig[:payload][:max_sentence_length] = 4
    Neo4RubyConfig[:payload][:min_word_length] = 2
    payload = ["a1 a2 a3 a4 a5 a6 a7 a8 a9 a s", "a1 a2"]
    assert_equal [["a1", "a2", "a3", "a4"], ["a5", "a6", "a7", "a8"], ["a9"], ["a1", "a2"]], s.perform(payload)
  end

end