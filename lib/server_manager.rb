require 'set'
require 'optparse'

class ServerManager

  DEFAULT_QUEUE = "neo4ruby"

  # TODO Rewrite puts for logger!

  attr_reader :options, :processor, :server

  AVAILABLE_OPTIONS = [
    OptionEntry.new(:queue, ["-q", "--queue NAME", "Set queue name"]),
    OptionEntry.new(:processor, ["-p", "--processor PAYLOAD_PROCESSOR", "Choose payload processor"]),
    OptionEntry.new(:list, ["-l", "--list_processors", "List available payload processors"]),
    OptionEntry.new(:silent, ["-s", "--silent", "Suppress output"])
  ].to_set

  def initialize
    @options = {}
  end

  def parse_command_line
    OptionParser.new do |opts|
      opts.banner = "Usage: start.rb [options]"

      AVAILABLE_OPTIONS.each do |opts_entry|
        opts.on(*opts_entry.desc) { |o| @options[opts_entry.name] = o }
      end

    end.parse!
  end

  def run
    if @options[:list]
      present_processor_list()
    else
      select_payload_processor()
      start_server()
    end
  end

  def present_processor_list
    puts "Available payload processors:\n#{PROCESSOR_LIST.join("\n")}"
  end

  def select_payload_processor
    if @options[:processor]
      requested_processor = (PROCESSOR_LIST.find { |p| p.to_s == @options[:processor] }) || DEFAULT_PROCESSOR
      puts "Using default processor." if (requested_processor == DEFAULT_PROCESSOR) && !@options[:silent]

      @processor = requested_processor.new
    else
      @processor = DEFAULT_PROCESSOR.new
    end
  end

  def start_server
    @server = Neo4rubyServer.new(@processor)
    @server.open
    @queue = options[:queue] || DEFAULT_QUEUE

    puts "Listening for queue: #{@queue}..." unless @options[:silent]
    @server.listen(@queue)
  end

  def stop
    if @server && @server.open?
      puts "Shutting down the server for: #{@queue}." unless @options[:silent]
      @server.shutdown
    end
  end
end