require 'set'
require 'optparse'

class ServerManager

  DEFAULT_QUEUE = "neo4ruby"
  DEFAULT_EXPERIMENT = "search_engine"

  # TODO Rewrite puts for logger!

  attr_reader :options, :processor, :server, :experiment

  AVAILABLE_OPTIONS = [
    OptionEntry.new(:queue, ["-q", "--queue NAME", "Set queue name"]),
    OptionEntry.new(:experiment, ["-e", "--experiment NAME", "Set experiment name"]),
    OptionEntry.new(:silent, ["-s", "--silent", "Suppress output"])
  ].to_set

  def initialize(opts) #opts = { payload_processor:, graph_builder:, start_db: }
    @processor = opts[:payload_processor]
    @graph_builder = opts[:graph_builder]
    @options = { start_db: opts[:start_db] }
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
    @queue = @options[:queue] || DEFAULT_QUEUE
    @experiment = @options[:experiment] || DEFAULT_EXPERIMENT

    @server = Neo4rubyServer.new(payload_processor: @processor, graph_builder: @graph_builder)

    start_db(@experiment) if @options[:start_db]
    @server.open

    Neo4rubyLogger.log(level: :info, msg: start_msg) unless @options[:silent]
    @server.listen(@queue)
  end

  def stop
    if @server && @server.open?
      Neo4rubyLogger.log(level: :info, msg: stop_msg) unless @options[:silent]
      @server.shutdown
    end
  end

  private

  def start_db(experiment)
    path = "db/#{experiment}"
    Neo4jConnection.change_db_path(path)
  end

  def start_msg
    "Listening for: queue #{@queue}, experiment: #{@experiment}..."
  end

  def stop_msg
    "Shutting down the server for: queue #{@queue}, experiment: #{@experiment}."
  end
end