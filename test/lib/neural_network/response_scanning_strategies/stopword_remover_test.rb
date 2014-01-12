require_relative '../../../test_helper'

class NeuralNetwork::ResponseScanningStrategies::StopwordRemoverTest < MiniTest::Unit::TestCase

  def setup
    @remover = NeuralNetwork::ResponseScanningStrategies::StopwordRemover.new
  end

  def test_it_removes_stopwords_from_response
    response = [ { word: "we" }, { word: "all" }, { word: "submarine" } ]
    query = ["water"]

    assert_equal [ { word: "submarine" } ], @remover.perform(query, response)
  end

  def test_it_keeps_stopwords_if_they_match_a_query
    response = [ { word: "we" }, { word: "all" }, { word: "submarine" } ]
    query = ["water", "we"]

    assert_equal [ { word: "we" }, { word: "submarine" } ],
                 @remover.perform(query, response)
  end

end