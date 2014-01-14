module Utilities
  module HashUtility

    def self.symbolize_keys(h)
      res = {}

      h.each_pair do |k, v|
        key = (k.respond_to?(:to_sym) ? k.to_sym : k )
        res[key] = ((v.kind_of? Hash) ? symbolize_keys(v) : v)
      end

      res
    end

  end
end