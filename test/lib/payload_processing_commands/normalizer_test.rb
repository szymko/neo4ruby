require_relative '../../test_helper'

class PayloadProcessingCommands::NormalizerTest < MiniTest::Unit::TestCase

  def test_it_downcases_all_words_in_array
    payload = ["TEsT1", "tesT2"]
    n = PayloadProcessingCommands::Normalizer.new

    assert_equal(["test1", "test2"], n.perform(payload))
  end

  def test_it_changes_encoding
    payload = "test".encode(Encoding::ISO_8859_1)
    n = PayloadProcessingCommands::Normalizer.new

    assert_equal("UTF-8", n.perform(payload).encoding.to_s)
  end
end
