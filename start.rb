#!/usr/bin/env ruby
require 'optparse'

require_relative './app/neo4ruby'
# run

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: neo4ruby.rb [options]"

  opts.on("-q", "--queue NAME", "Set queue name") do |o|
    options[:queue] = o
  end

  opts.on("-d", "--debug", "Start server in a debug mode") do |o|
    options[:debug] = o
  end
end.parse!

loop do
  begin
    p options
    raise Interrupt
    payload_processor = PayloadProcessor.new

    server = Neo4rubyServer.new(payload_processor)
    server.listen(options[:queue] || "neo4ruby")
  rescue Interrupt => _
    # server.shutdown
    break
  end
end