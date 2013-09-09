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

  def self.transaction_create(attrs = {})
    transaction { Expression.create(attrs) }
  end

  def self.destroy_all
    all.each do |el|
      transaction { el.del }
    end
  end

  class << self
    alias :delete_all :destroy_all
  end

  def self.find_or_create(attrs)
    e = Expression.find(attrs).first
    e ||= transaction_create(attrs)
    e
  end
end
