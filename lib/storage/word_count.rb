require 'redis'

module Storage
  class WordCount

    def initialize(opts = {})
      @redis = Redis.new(opts)
    end

    def get(word)
      @redis.get(namespaced(word))
    end

    def increment(word)
      @redis.incr(namespaced(word))
    end

    def namespaced(word)
      "WordCount::" + word
    end

  end
end
