require_relative '../test_helper'

class RedisConnectionTest < MiniTest::Unit::TestCase

  def teardown
    RedisConnection.set_experiment(Neo4rubyConfig[:experiment])
  end

  def test_it_sets_experiment_name
    RedisConnection.set_experiment("test2")
    assert_equal "test2", RedisConnection.experiment_prefix
  end

  def test_it_returns_redis_connection_proxy
    assert_kind_of RedisProxy, RedisConnection.new_connection
  end

end