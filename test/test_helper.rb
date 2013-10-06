require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'

require_relative '../app/neo4ruby'
require_relative '../lib/server_manager'
require_relative './mock'

module TestHelper
  class ProcesorPszemka; end
end