require 'json'

class PayloadProcessor

  def initialize(strategies = [])
    @strategies = strategies
  end

  def run(opts) #opts = { page: , experiment: , graph_builder:  }
    payload = parse(opts[:page])
    opts[:builder].build(payload, opts)
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
