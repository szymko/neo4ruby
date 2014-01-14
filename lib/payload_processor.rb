require 'json'

class PayloadProcessor < BasicCommandUtilizer

  def run(opts) #opts = { page: , builder:  }
    payload = parse(opts[:page])
    opts[:builder].build(payload, opts)
    true
  end

  def parse(page)
    raw = Utilities::HashUtility.symbolize_keys(JSON(page))
    body = process_body(raw[:body])

    { url: raw[:url], body: body }
  end

  private

  def process_body(body)
    if body.kind_of? Hash
      res = {}
      body.each_pair { |k, v| res[k] = apply_commands(v) }
    else
      res = apply_commands(body)
    end

    res
  end

end
