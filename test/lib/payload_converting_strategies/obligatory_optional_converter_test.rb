require_relative '../../test_helper'

class PayloadConvertingStrategies::ObligatoryOptionalConverterTest < MiniTest::Unit::TestCase

  def setup
    @payload = { body: { obligatory: ["It's obligatory 1", "It's obligatory 2"], optional: ["It's optional 1", "It's optional 2"] } }
    @strategy = PayloadConvertingStrategies::ObligatoryOptionalConverter.new
  end

  def test_it_joins_obligatory_and_optional_section
    Neo4rubyConfig[:payload][:optional_limit] = 2
    assert_equal ["It's obligatory 1", "It's obligatory 2", "It's optional 1", "It's optional 2"], @strategy.convert(@payload)
  end

  def test_it_limits_optional_according_to_config
    Neo4rubyConfig[:payload][:optional_limit] = 1
    assert_equal ["It's obligatory 1", "It's obligatory 2", "It's optional 1"], @strategy.convert(@payload)

  end

end