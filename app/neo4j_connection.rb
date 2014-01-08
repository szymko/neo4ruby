require 'neo4j-wrapper'

module Neo4jConnection
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

Neo4j::Config[:storage_path] = Neo4jConnection.db_path