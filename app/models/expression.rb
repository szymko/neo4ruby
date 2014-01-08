require 'uri'

class Expression

  include Neo4j::NodeMixin
  include Shared::Neo4jTransaction
  include Shared::ModelUtility

  rule(:all)

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

  def create_sequence(expr, opts = {})
    opts = { dir: :outgoing }.merge(opts)
    raise ArgumentError unless opts[:dir] == :outgoing || opts[:dir] == :incoming

    e1 = (opts[:dir] == :outgoing ? self : expr)
    e2 = (e1 == self ? expr : self)

    Sequence.transaction_create(e1, e2)
  end

  def sequences(direction = :outgoing)
    self.rels(direction, :sequence).to_a
  end


  ## class methods

  # decorators for finding and creating expressions

  def self.transaction_create(attrs = {})
    transaction { Expression.create() }
  end

  class << self
    alias :delete_all :destroy_all
  end
end
