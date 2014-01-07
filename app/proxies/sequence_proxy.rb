require 'delegate'

class SequenceProxy < SimpleDelegator

  include Shared::Properties

  register_props :delta, :weight

  def self.create(from_node, to_node, attrs = {})
    s = Sequence.transaction_create(from_node, to_node)
    s_proxy = self.new(s)
    attrs.each_pair { |atr, val| s_proxy.set_prop(atr, val)  }

    s_proxy
  end

  def self.wrap(collection)
    collection.map { |s| SequenceProxy.new(s) }
  end

end