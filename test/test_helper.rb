require 'minitest/autorun'
require 'mocha/setup'

require_relative '../app/neo4ruby'
require_relative '../lib/server_manager'
require_relative './mock'

module TestHelper

  def assert_changed_by(numbr)
    current = Expression.count
    yield

    assert numbr, (current - Expression.count).abs
  end
end