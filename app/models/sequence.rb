class Sequence
  include Neo4j::RelationshipMixin
  include Shared::Neo4jTransaction

  property :strength
  index :strength

  def self.transaction_create(from_node, to_node)
    transaction { Sequence.create(:sequence, from_node, to_node) }
  end

  def get_prop(prop)
    send(prop)
  end
end
