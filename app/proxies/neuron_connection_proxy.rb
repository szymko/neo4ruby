class NeuronConnectionProxy < ModelProxy

  delegate_to_class SequenceProxy

  def end_neuron
    @end_node ||= NeuronProxy.new(end_node)
  end

end