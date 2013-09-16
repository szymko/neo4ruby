require 'neo4j-wrapper'

project_root = File.dirname(File.absolute_path(__FILE__))
require_relative './concerns/shared/neo4j_transaction'

require_relative './models/sequence'
require_relative './models/expression'

require_relative '../lib/article'
require_relative '../lib/neo4ruby_server'
require_relative '../lib/payload_processor'