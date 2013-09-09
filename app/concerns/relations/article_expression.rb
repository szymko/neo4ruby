module Relations
  module ArticleExpression

    def preceding
      incoming(:sequence)
    end

    def following
      outgoing(:sequence)
    end

    def find_or_create_outgoing(expr)
      rels.find{ |s| s.end_node.word == expr.word } || Sequence.create(self, expr)
    end
  end
end