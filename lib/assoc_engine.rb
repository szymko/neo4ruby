class AssocEngine

  def update_graph(opts)
    update_delta(opts[:sequence], opts[:distance])
    update_strength(opts[:expression], opts[:sequence])
  end

  def update_strength(expression, sequence)
    delta = sequence.delta.to_f
    count = expression.count.to_f

    strength = (2 * delta)/(count + delta)
    sequence.set_prop(:strength, strength)
  end

  def update_delta(sequence, distance)
    sequence.increment(:delta, 1/(distance.to_f))
  end

end
