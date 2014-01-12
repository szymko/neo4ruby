require 'json'

class PayloadProcessor

  def initialize(strategies)
    @strategies = strategies
  end

  def run(opts) #opts = { page: , builder:  }
    payload = parse(opts[:page])
    opts[:builder].build(payload, opts)
    true
  end

  def parse(page)
    raw = HashUtility.symbolize_keys(JSON(page))
    body = process_body(raw[:body])

    { url: raw[:url], body: body }
  end

  private

  def process_body(body)
    if body.kind_of? Hash
      res = {}
      body.each_pair { |k, v| res[k] = @strategies.reduce(v) { |r, s| r = s.perform(r) } }
    else
      res = @strategies.reduce(body) { |r, s| r = s.perform(r) }
    end

    res
  end

end
