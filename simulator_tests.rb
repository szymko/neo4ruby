@s = NeuralNetwork::Simulator.new
@sum = []

@sample = @s.neurons.sample(5)
@sample.each { |n| n.exc = 1.0 }

10.times do
  @s.step
  @sum << @s.neurons.reduce(0) { |num, e| num += e.exc }
end