require 'json'

class PayloadProcessor

  def initialize(strategies)
    @strategies = strategies
  end

  def run(opts) #opts = { page: , experiment: , builder:  }
    payload = parse(opts[:page])

Neo4j::Transaction.run do
    opts[:builder].build(payload, opts)
end
    "OK"
  end

  def parse(page)
    raw = JSON(page)
    body = raw["body"]

    @strategies.each { |s| body = s.perform(body) }
    { url: raw["url"], body: body }
  end

end
