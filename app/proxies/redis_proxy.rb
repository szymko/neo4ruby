require 'redis'
require 'delegate'

class RedisProxy < SimpleDelegator

  def initialize(opts, key_prefix = "")
    @key_prefix = key_prefix
    @opts = opts
    super(redis)
  end

  def hset(key, prop, val)
    redis.hset(namespace(key), prop, val)
  end

  def hget(key, prop)
    redis.hget(namespace(key), prop)
  end

  private

  def namespace(key)
    "#{@key_prefix}::#{key}"
  end

  def redis
    @redis_conn ||= Redis.new(@opts)
  end

end