require 'singleton'

class RedisConnection

  include Singleton

  attr_reader :experiment_prefix

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

  def new_connection(opts)
    opts = Neo4rubyConfig[:redis].merge(opts)
    RedisProxy.new(opts, @experiment_prefix)
  end

end