class Expression

  include Neo4j::NodeMixin
  include Shared::Neo4jTransaction
  include Relations::ArticleExpression

  rule(:all)

  property :word
  index :word

  has_n(:sequence).to(Expression).relationship(Sequence)
  has_n(:sequence).from(Expression, :sequence).relationship(Sequence)


  # Usage
  # e3 = Neo4j::Transaction.run { Expression.create  }
  # e1 = Expression.find('word: weronika').first
  #  s = Neo4j::Transaction.run { Sequence.create(:sequence, e1, e3) }
  # Neo4j::Transaction.run { s.strength = 0.3 }
  # Neo4j::Transaction.run { s.strength = 0.3 }
  # e3.incoming(:sequence).rels.first.props

  # decorators for finding and creating expressions

  def self.find_or_create(attr_name, attr_val)
    e = Expression.find("#{attr_name}: attr_val").first
    e = transaction { Expression.create(attr_name.to_sym => attr_val) } unless e

    e
  end

end
