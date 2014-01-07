require 'uri'
require 'json'

class Expression

  include Neo4j::NodeMixin
  include Shared::Neo4jTransaction
  include Shared::ModelUtility
  # include Shared::Properties

  rule(:all)

  # property :word
  # property :urls
  # property :experiment
  # property :count

  has_n(:sequence).to(Expression).relationship(Sequence)
  has_n(:sequence).from(Expression, :sequence).relationship(Sequence)


  # Usage
  # e3 = Neo4j::Transaction.run { Expression.create  }
  # e1 = Expression.find('word: weronika').first
  # s = Neo4j::Transaction.run { Sequence.create(:sequence, e1, e3) }
  # Neo4j::Transaction.run { s.strength = 0.3 }
  # Neo4j::Transaction.run { s.strength = 0.3 }
  # e3.incoming(:sequence).rels.first.props

  #register_props :word, :urls, :count

  ## instance methods

  # def load_outgoing
  #   @loaded = true
  #   @out_seq = sequences
  #   @outgoing_word_map = @out_seq.reduce({}) { |h, s| h[s.end_node.word] = s; h }
  # end

  # def add_to_outgoing(s)
  #   load_outgoing unless @loaded
  #   @out_seq << s
  #   @outgoing_word_map[s.end_node.word] = s
  #   following
  #   @cached_following << s.end_node
  # end

  # def find_or_create_outgoing(expr)
  #   sequence_to(expr) || create_sequence(expr, dir: :outgoing)
  # end

  def create_sequence(expr, opts = {})
    opts = { dir: :outgoing }.merge(opts)
    raise ArgumentError unless opts[:dir] == :outgoing || opts[:dir] == :incoming

    e1 = (opts[:dir] == :outgoing ? self : expr)
    e2 = (e1 == self ? expr : self)

    Sequence.transaction_create(e1, e2)
  end

  # def add_url(url)
  #   raise ArgumentError unless url =~ /^#{URI::regexp}$/

  #   local_urls = self.urls || []
  #   modified_urls = local_urls.dup
  #   (local_urls << url).uniq

  #   self.urls = local_urls.uniq unless local_urls == modified_urls
  #   # set_prop(:urls, urls.uniq) unless urls == modified_urls
  # end

  def sequences
    self.rels(:outgoing, :sequence).to_a
  end

  # def sequence_to(expr)
  #   load_outgoing unless @loaded
  #   #rels.find { |s| s.end_node.word == expr.word && s.is_a?(Sequence) }
  #   @outgoing_word_map[expr.word]
  # end

  ## class methods

  # decorators for finding and creating expressions

  def self.transaction_create(attrs = {})
    transaction { Expression.create() }
  end

  class << self
    alias :delete_all :destroy_all
  end
end
