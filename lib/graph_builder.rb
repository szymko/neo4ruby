class GraphBuilder

  def initialize(opts)
    @expression_builder = opts[:expression_builder]
    @assoc_engine = opts[:assoc_engine]
  end

  def build(payload, opts) #payload = { url:, body: }, opts = { experiment:, sequence_size: }
    sequence_size = opts[:sequence_size] || 1

    payload[:body].each_slice(sequence_size) do |sequence|
      graph_part = build_graph(sequence, url: payload[:url],
                                experiment: opts[:experiment])

      @expression_builder.increment_word_count(graph_part)
      @assoc_engine.bind_nodes(graph_part, @expression_builder)
    end
  end

  private

  def build_graph(sequence, opts)
    sequence.flatten.inject([]) do |graph, word|
      graph <<  @expression_builder.build(word: word, url: opts[:url],
                                          experiment: opts[:experiment])
    end
  end

end
