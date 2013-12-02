#!/usr/bin/env ruby
require_relative './app/neo4ruby'

trap("INT"){ exit() }

begin
  manager = ServerManager.new
  manager.parse_command_line()
  manager.run()

rescue Exception => e

  unless e.is_a? SystemExit
    puts "#{e.message}: #{e.inspect}"
    puts e.backtrace
  end

ensure
  manager ||= nil
  manager.stop() if manager
end
