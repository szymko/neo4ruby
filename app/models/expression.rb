require 'uri'

class Expression

  include Neo4j::NodeMixin
  include Shared::Neo4jTransaction
  include Shared::ModelUtility

  rule(:all)

  property :word, index: :exact
  property :urls, index: :exact
  property :experiment, index: :exact
  property :count

  has_n(:sequence).to(Expression).relationship(Sequence)
  has_n(:sequence).from(Expression, :sequence).relationship(Sequence)


  # Usage
  # e3 = Neo4j::Transaction.run { Expression.create  }
  # e1 = Expression.find('word: weronika').first
  # s = Neo4j::Transaction.run { Sequence.create(:sequence, e1, e3) }
  # Neo4j::Transaction.run { s.strength = 0.3 }
  # Neo4j::Transaction.run { s.strength = 0.3 }
  # e3.incoming(:sequence).rels.first.props

  ## instance methods

  def preceding
    incoming(:sequence).to_a
  end

  def following
    outgoing(:sequence).to_a
  end

  def find_or_create_outgoing(expr)
    sequence_to(expr) || create_sequence(expr, dir: :outgoing)
  end

  def create_sequence(expr, opts = {})
    # pre 2.0 default opts style
    opts = { dir: :outgoing }.merge(opts)
    raise ArgumentError unless opts[:dir] == :outgoing || opts[:dir] == :incoming

    e1 = (opts[:dir] == :outgoing ? self : expr)
    e2 = (e1 == self ? expr : self)

    Sequence.transaction_create(e1, e2)
  end

  def add_url(url)
    urls = self.urls || []
    urls = (urls << url).uniq

    raise ArgumentError unless url =~ /^#{URI::regexp}$/

    set_prop(:urls, urls.uniq) unless urls == self.urls
  end

  def sequences
    self.rels(:outgoing, :sequence).to_a
  end

  def sequence_to(expr)
    rels.find { |s| s.end_node.word == expr.word && s.is_a?(Sequence) }
  end

  ## class methods

  # decorators for finding and creating expressions

  def self.transaction_create(attrs = {})
    transaction { Expression.create(attrs) }
  end

  def self.from_experiment(experiment_name)
    Expression.find(experiment: experiment_name).to_a
  end

  class << self
    alias :delete_all :destroy_all
  end
end
