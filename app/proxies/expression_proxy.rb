require 'delegate'

class ExpressionProxy < SimpleDelegator

  include Shared::Properties

  register_props :word, :urls, :count

  def initialize(expr)
    @expression = expr
    super(@expression)
    @cache = {}
  end

  def following
    @cache[:following] ||=
      self.class.wrap(@expression.outgoing(:sequence).to_a)
  end

  def preceding
    @cache[:preceding] ||=
      self.class.wrap(@expressiong.incoming(:sequence).to_a)
  end

  def sequences
    @cache[:sequence] ||=
      SequenceProxy.wrap(@expression.sequences)
  end

  def sequence_word_map
    @cache[:sequence_word_map] ||= sequences.reduce({}) do |c, seq|
      c[seq.end_node.word] = seq
      c
    end
  end

  def clear_cache
    @cache = {}
  end

  def add_to_outgoing(s)
    sequences << s
    sequence_word_map[s.end_node.word] = s
    following << s.end_node
  end

  def add_url(url)
    raise ArgumentError unless url =~ /^#{URI::regexp}$/

    local_urls = self.urls || []
    modified_urls = local_urls.dup
    (local_urls << url).uniq

    self.urls = local_urls.uniq unless local_urls == modified_urls
  end

  def create_sequence(*args)
    s = SequenceProxy.new(@expression.create_sequence(args))
    add_to_outgoing(s)
    s
  end

  def sequence_to(expr)
    sequence_word_map[expr.word]
  end

  def find_or_create_outgoing(expr)
    sequence_to(expr) || create_sequence(expr, dir: :outgoing)
  end

  #class methods

  def self.create(attrs)
    e = Expression.transaction_create()
    e_proxy = self.new(e)
    attrs.each_pair { |atr, val| e_proxy.set_prop(atr, val)  }
    e_proxy
  end

  def self.all
    Expression.all.to_a
  end

  def self.wrap(collection)
    collection.map { |e| ExpressionProxy.new(e) }
  end

end