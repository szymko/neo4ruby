require 'yaml'
require_relative 'utilities/hash_utility'
PROJECT_ROOT = File.join(File.dirname(File.absolute_path(__FILE__)), "/..")
Neo4rubyConfig = Utilities::HashUtility.symbolize_keys(YAML.load_file(PROJECT_ROOT + "/config/config.yml"))

require_relative 'proxies/redis_proxy'
require_relative 'redis_connection'
require_relative 'neo4j_connection'

Dir.glob(PROJECT_ROOT + "/lib/**/*.rb").each { |f| require f }
Dir.glob(PROJECT_ROOT + "/app/concerns/**/*.rb").each { |f| require f }

require_relative 'models/sequence'
require_relative 'models/expression'
require_relative 'proxies/model_proxy'
require_relative 'proxies/expression_proxy'
require_relative 'proxies/sequence_proxy'
require_relative 'proxies/neuron_connection_proxy'
require_relative 'proxies/neuron_proxy'
