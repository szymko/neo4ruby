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
end
