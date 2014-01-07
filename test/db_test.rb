require_relative 'test_helper'
require 'fileutils'

RedisConnection.set_experiment("test")

class DbTest
  class Unit < MiniTest::Unit

    def _run_suites(*args)
      setup_test_db
      res = super
      teardown_redis
      teardown_test_db

      res
    end

    private

    def setup_test_db
      FileUtils.rm_rf(Neo4jConnection::TEST_DB_PATH)
      Dir.mkdir(Neo4jConnection::TEST_DB_PATH)
    end

    def teardown_test_db
      Neo4j.shutdown
      FileUtils.rm_rf(Neo4jConnection::TEST_DB_PATH)
    end

    def teardown_redis
      conn = RedisConnection.new_connection
      conn.keys("test::*").each { |k| conn.del(k) }
    end
  end
end