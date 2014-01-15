class NeuronProxy < ModelProxy

  delegate_to_class ExpressionProxy

  attr_writer :exc, :prev_exc, :input_sum

  def exc
    @exc ||= 0
  end

  def reset
    @exc = 0
    @prev_exc = 0
    @input_sum = 0
  end

  def prev_exc
    @prev_exc ||= 0
  end

  def input_sum
    @input_sum ||= 0
  end

  def connections
    @conn ||= NeuronConnectionProxy.wrap(sequences)
  end

  def increment_sum_by(val)
    @input_sum = input_sum + val
  end

  def propagate_excitation
    build_connections unless @cached_connections
    @cached_connections.each { |c| c[:neuron].increment_sum_by(exc * c[:weight]) }
  end

  def build_connections(neuron_cache)
    @cached_connections = []
    connections.each do |c|
      @cached_connections << { neuron: neuron_cache[c.end_neuron.word],
                               weight: c.weight }
    end
  end

end