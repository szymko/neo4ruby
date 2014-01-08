class ExpressionProxy < ModelProxy

  include Shared::Properties

  register_props :word, :urls, :count

  delegate_to_class Expression

  def initialize(expr)
    @expression = expr
    @cache = {}
    super
    set_cache
  end

  def load_cache
    sequences
    sequence_word_map
    following
    preceding
  end

  def following
    present_cache(:following) do
      ExpressionProxy.wrap(@expression.outgoing(:sequence).to_a)
    end
  end

  def preceding
    present_cache(:preceding) do
      ExpressionProxy.wrap(@expression.incoming(:sequence).to_a)
    end
  end

  def sequences
    present_cache(:sequences) do
      SequenceProxy.wrap(@expression.sequences)
    end
  end

  def sequence_word_map
    present_cache(:sequence_word_map) do
      sequences.reduce({}) do |c, seq|
        c[seq.end_node.word] = seq
        c
      end
    end
  end

  def add_to_cache(key)
    @cache[key][:loaded] ? yield(send(key)) : send(key)
  end

  def set_cache
    @cache[:sequences] = { loaded: false,  }
    @cache[:sequence_word_map] = { loaded: false }
    @cache[:preceding] = { loaded: false }
    @cache[:following] = { loaded: false }
  end

  def clear_cache
    @cache = {}
    set_cache
  end

  def add_to_outgoing(s)
    add_to_cache(:sequences) { |seq| seq << s }
    add_to_cache(:sequence_word_map) { |swm| swm[s.end_node.word] = s }
    add_to_cache(:following) { |fol| fol << s.end_node }
  end

  def add_url(url)
    raise ArgumentError unless url =~ /^#{URI::regexp}$/

    local_urls = self.urls || []
    modified_urls = local_urls.dup
    (local_urls << url).uniq

    self.urls = local_urls.uniq unless local_urls == modified_urls
  end

  def create_sequence(*args)
    s = SequenceProxy.new(@expression.create_sequence(*args))
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
    wrap(Expression.all.to_a)
  end

  private

  def present_cache(key)
    if @cache[key][:loaded]
      @cache[key][:value]
    else
      @cache[key][:loaded] = true
      @cache[key][:value] = yield
    end
  end

end