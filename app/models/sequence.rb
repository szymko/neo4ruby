class Sequence
  include Neo4j::RelationshipMixin
  include Shared::Neo4jTransaction
  include Shared::Properties

  # properties from book graph representation
  # property :delta
  # property :weight
  #index :weight

  # register_props :delta, :weight

  def self.transaction_create(from_node, to_node)
    transaction { Sequence.create(:sequence, from_node, to_node) }
    # attrs.each_pair { |k, v| s.set_prop(k, v) }
    # s
  end

end