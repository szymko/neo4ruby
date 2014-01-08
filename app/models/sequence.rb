class Sequence
  include Neo4j::RelationshipMixin
  include Shared::Neo4jTransaction

  def self.transaction_create(from_node, to_node)
    transaction { Sequence.create(:sequence, from_node, to_node) }
  end

end