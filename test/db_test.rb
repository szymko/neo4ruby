require_relative 'test_helper'
require 'fileutils'

class DbTest
  class Unit < MiniTest::Unit

    def _run_suites(*args)
      begin
        setup_test_db
        super
      ensure
        teardown_test_db
      end
    end

    private

    def setup_test_db
      FileUtils.rm_rf(Neo4rubyConnection::TEST_DB_PATH)
      Dir.mkdir(Neo4rubyConnection::TEST_DB_PATH)
    end

    def teardown_test_db
      Neo4j.shutdown
      FileUtils.rm_rf Neo4rubyConnection::TEST_DB_PATH
    end
  end
end