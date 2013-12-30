require 'neo4j-wrapper'
require 'tmpdir'

module Neo4jConnection
  TEST_DB_PATH =  File.join(Dir.tmpdir, "neo4ruby_test_db")
  DEFAULT_PATH = 'db/search_engine'

  def self.change_db_path(path)
    Neo4j.shutdown
    Neo4j::Config[:storage_path] = path
    Neo4j.start
  end

  def self.db_path
    ENV['EXPERIMENT'] ? ('db/' + ENV['EXPERIMENT']) : DEFAULT_PATH
  end

end

Neo4j::Config[:storage_path] = (ENV['NEO4RUBY_ENV'] == 'test' ?
                                Neo4jConnection::TEST_DB_PATH :
                                Neo4jConnection.db_path)