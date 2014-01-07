module Shared
  module Neo4jTransaction

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def transaction(&block)
        Neo4j::Transaction.run(&block) if block_given?
      end
    end

    def transaction(&block)
      Neo4j::Transaction.run(&block) if block_given?
    end

  end
end
