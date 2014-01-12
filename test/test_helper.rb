require 'minitest/autorun'
require 'mocha/setup'
require 'tmpdir'

require_relative '../app/neo4ruby'
require_relative '../lib/server_manager'
require_relative './mock'

Neo4rubyConfig[:experiment] = "test"
Neo4rubyConfig[:logger][:enabled] = false

module TestHelper

  TEST_DB_PATH = File.join(Dir.tmpdir, "neo4ruby_test_db")

  def teardown_redis(key_pattern)
    conn = RedisConnection.new_connection
    conn.keys(key_pattern).each { |k| conn.del(k) }
  end

end