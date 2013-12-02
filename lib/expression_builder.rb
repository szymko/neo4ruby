require 'pry'
class ExpressionBuilder

  def initialize(opts)
    @klass = opts[:expression_class]
    @experiment_name = opts[:experiment]
    @assoc_engine = opts[:assoc_engine]
    @sequence_size = opts[:sequence_size] || 1
  end

  def insert(payload)
    payload[:body].each_cons(@sequence_size) do |sequence|
      graph = build_graph(sequence, payload[:url])

#binding.pry
      graph.uniq { |expr| expr.word }.each { |e| e.increment(:count) }
      bind_expressions(graph)
    end
  end

  private

  def build_graph(sequence, url)
    sequence.flatten.inject([]) do |graph, s|
      e = @klass.find_or_create(word: s, experiment: @experiment_name)
      e.add_url(url)
      graph << e
    end
  end

  def bind_expressions(graph_expr)
    graph_expr[0..-2].each_with_index do |e1, idx1|
      affected = []

      graph_expr[idx1 + 1 .. -1].each_with_index do |e2, idx2|
        affected << find_or_create_sequence(e1, e2)
        @assoc_engine.update_graph( expression: e1, sequence: affected.last,
                                    distance: idx2 + 1)
      end

      (e1.sequences - affected).each { |s| @assoc_engine.update_strength(e1, s) }
    end
  end

  def find_or_create_sequence(expr1, expr2)
    (expr1.sequences.find { |s|
      s.nodes.map(&:word).sort == [expr1, expr2].map(&:word).sort
    }) || Sequence.transaction_create(expr1, expr2)
  end
end
