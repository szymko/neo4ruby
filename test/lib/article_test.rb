require_relative '../test_helper'

class ArticleTest < MiniTest::Unit::TestCase
  def setup
    @url = 'htttp://en.wikipedia.org/'
    @feed = ['Citation', 'needed']
  end

  def test_it_creates_sequence_feed
    @article = Article.new

    @article.sequence_feed(@feed, @url)

    assert_equal @feed, @article.word_ary
    assert_equal @url, @article.url
    assert_equal @feed, @article.chain.map(&:word)
  end
end