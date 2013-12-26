require 'neo4j-wrapper'
require 'tmpdir'

module Neo4jConnection
  TEST_DB_PATH =  File.join(Dir.tmpdir, "neo4ruby_test_db")
  DB_PATH = 'db'
end

Neo4j::Config[:storage_path] = (ENV['NEO4RUBY_ENV'] == 'test' ?
                                Neo4jConnection::TEST_DB_PATH :
                                Neo4jConnection::DB_PATH)