class Sequence
  include Neo4j::RelationshipMixin
  include Shared::Neo4jTransaction

  property :strength
  index :strength

  def self.create(from_node, to_node)
    s = transaction { Sequence.create(:sequence, from_node, to_node) }
    s
  end

  def get_prop(prop)
    send(prop)
  end
end
