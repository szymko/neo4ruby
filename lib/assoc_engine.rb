class AssocEngine

  def bind_nodes(nodes, edge_builder)
    nodes[0 .. -2].each_with_index do |e1, idx1|
      changed = []
      nodes[idx1 + 1 .. -1].each_with_index do |e2, idx2|
        changed << edge_builder.bind(e1, e2)
        update_delta(changed.last, idx2 + 1)
        update_weight(e1, changed.last)
      end

      (e1.sequences - changed).each { |s| update_weight(e1, s) }
    end
  end

  def update_weight(expression, sequence)
    delta = sequence.delta.to_f
    count = expression.count.to_f

    weight = (2 * delta)/(count + delta)
    sequence.set_prop(:weight, weight)
  end

  def update_delta(sequence, distance)
    sequence.increment(:delta, 1/(distance.to_f))
  end

end
