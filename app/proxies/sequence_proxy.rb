class SequenceProxy < ModelProxy

  include Shared::Properties

  register_props :delta, :weight

  delegate_to_class Sequence

  def initialize(sequence)
    @sequence = sequence
    super
  end

  def end_node
    ExpressionProxy.new(@sequence.end_node)
  end

  def self.create(from_node, to_node, attrs = {})
    s = Sequence.transaction_create(from_node, to_node)
    s_proxy = self.new(s)
    attrs.each_pair { |atr, val| s_proxy.set_prop(atr, val)  }

    s_proxy
  end

end