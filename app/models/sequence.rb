class Sequence
  include Neo4j::RelationshipMixin
  include Shared::Neo4jTransaction

  # properties from book graph representation
  property :delta
  property :weight
  index :weight

  def self.transaction_create(from_node, to_node, attrs = {})
    transaction { Sequence.create(:sequence, from_node, to_node, attrs) }
  end

end