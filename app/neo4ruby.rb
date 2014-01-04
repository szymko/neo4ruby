require_relative 'neo4j_connection'

PROJECT_ROOT = File.join(File.dirname(File.absolute_path(__FILE__)), '/..')

Dir.glob(PROJECT_ROOT + "/lib/**/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/app/concerns/**/*.rb").each { |f| require f }

require_relative 'models/sequence'
require_relative 'models/expression'

Neo4rubyConfig = HashUtility.symbolize_keys(YAML.load_file(PROJECT_ROOT + "/config/config.yml"))