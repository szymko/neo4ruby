require_relative '../../test_helper'

class PayloadProcessingCommands::WikiSpecialsCleanerTest < MiniTest::Unit::TestCase

  def setup
    @cleaner = PayloadProcessingCommands::WikiSpecialsCleaner.new
  end

  def test_it_replaces_edit_links_with_dots
    payload = "[edit]Competitive record[edit]FIFA World Cup[edit]"
    assert_equal ".Competitive record.FIFA World Cup.", @cleaner.perform(payload)
  end

  def test_it_removes_annotations
    payload = "[4]In the 1954 World Cup,"
    assert_equal "In the 1954 World Cup,", @cleaner.perform(payload)
  end

end