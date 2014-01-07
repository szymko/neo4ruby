require 'logger'
require 'singleton'
require 'fileutils'

class Neo4rubyLogger

  include Singleton

  def log(options)
    opts = { level: 'info', msg: '' }.merge(options)
    build_logger() unless @logger
    @logger.send(opts[:level].to_sym) { opts[:msg] }
  end

  def self.log(*args)
    instance.log(*args) if Neo4rubyConfig[:logger][:enabled]
  end

  def self.log_exception(exc)
    log(level: :error, msg: [exc.to_s, exc.backtrace].join("\n"))
  end

  private

  def build_logger
    logger_path = File.join(PROJECT_ROOT, Neo4rubyConfig[:logger][:file])
    FileUtils.touch(logger_path)
    @logger = Logger.new(logger_path)
  end
end