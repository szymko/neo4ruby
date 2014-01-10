require 'singleton'

class RedisConnection

  include Singleton

  DEFAULT_PREFIX = "search_engine"

  def self.set_experiment(exp_name)
    instance.set_experiment(exp_name)
  end

  def self.new_connection(opts = {})
    instance.new_connection(opts)
  end

  def self.experiment_prefix
    instance.experiment_prefix
  end

  def set_experiment(exp_name)
    @experiment_prefix = exp_name.to_s
  end

  def experiment_prefix
    @experiment_prefix ||=
                       (ENV['EXPERIMENT'] ? ENV['EXPERIMENT'] : DEFAULT_PREFIX)
  end

  def new_connection(opts)
    opts = Neo4rubyConfig[:redis].merge(opts)
    @redis ||= RedisProxy.new(opts, experiment_prefix)
  end

end