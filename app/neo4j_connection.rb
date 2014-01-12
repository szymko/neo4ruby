require 'neo4j-wrapper'

module Neo4jConnection

  def self.change_db_path(path)
    Neo4j.shutdown
    Neo4j::Config[:storage_path] = path
    Neo4j.start
  end

  def self.db_path
    "db/" + (ENV['EXPERIMENT'] || Neo4rubyConfig[:experiment])
  end

end

Neo4j::Config[:storage_path] = Neo4jConnection.db_path