require 'json'

class PayloadProcessor

  def initialize(strategies = [])
    @strategies = strategies
  end

  def run(opts) #opts = { page: ..., expression_class:, experiment:, assoc_engine:  }
    payload = parse(opts[:page])
    builder = ExpressionBuilder.new(opts)
    builder.insert(payload)
    "OK"
  end

  def parse(page)
    raw = JSON(page)
    { url: raw["url"], body: parse_body(raw["body"]) }
  end

  def parse_body(body)
    res = body
    @strategies.each { |s| res = s.perform(res) }
    res
  end
end
