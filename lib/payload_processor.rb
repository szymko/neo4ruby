require 'json'

class PayloadProcessor
  def run(page)
    parsed = JSON(page)
    article = Article.new("system test")
    word_ary = parsed["body"].split(/\s+|[.,:"\/\[\]\(\)-]/).reject { |e| e == "" }

    article.sequence_feed(word_ary, parsed["url"])
    "OK"
  end
end
