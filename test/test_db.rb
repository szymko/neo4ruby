require_relative 'test_helper'
require 'fileutils'

RedisConnection.set_experiment(TestHelper::REDIS_TEST_PREFIX)

class TestDb
  class Unit < MiniTest::Unit

    include TestHelper

    def _run_suites(*args)
      setup_test_db
      res = super
      teardown_redis(TestHelper::REDIS_TEST_PREFIX + "*")
      teardown_test_db

      res
    end

    private

    def setup_test_db
      FileUtils.rm_rf(TestHelper::TEST_DB_PATH)
      Dir.mkdir(TestHelper::TEST_DB_PATH)
      Neo4jConnection.change_db_path(TestHelper::TEST_DB_PATH)
    end

    def teardown_test_db
      Neo4j.shutdown
      FileUtils.rm_rf(TestHelper::TEST_DB_PATH)
    end
  end
end