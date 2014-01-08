require_relative '../test_helper'

class RedisProxyTest < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @opts = {}
    @key_prefix = "r_test"
    @r = RedisProxy.new(@opts, @key_prefix)

    teardown_redis("#{@key_prefix}::*")
  end

  def teardown
    teardown_redis("#{@key_prefix}::*")
  end

  def test_it_enables_hset
    assert_equal true, @r.hset("a", "b", 1)
  end

  def test_it_gets_inserted_hash
    @r.hset("a", "b", 7)
    assert_equal "7", @r.hget("a", "b")
  end

  def test_it_uses_namespaced_keys_for_hset
    @r.hset("e", "f", 7)
    rs = Redis.new(@opts)
    assert rs.keys("*").include?("#{@key_prefix}::e")
  end

  def test_it_delegates_methods_to_redis_client
    Redis.any_instance.expects(:set).returns("OK")
    assert_equal "OK", @r.set("a", "b")
  end

end