require_relative 'test_helper'
require 'fileutils'

class TestDb
  class Unit < MiniTest::Unit

    include TestHelper

    def _run_suites(*args)
      setup_test_db
      res = super
      teardown_redis(Neo4rubyConfig[:experiment] + "::*")
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