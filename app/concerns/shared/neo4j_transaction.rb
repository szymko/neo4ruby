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

    def set_prop(prop, val)
      transaction { send("#{prop}=", val) }
    end

    def get_prop(prop)
      send(prop)
    end

    def increment(property, by = 1)
      prop = self.send(property).to_f

      unless by == 0
        incr_prop = prop + by
        set_prop(property, incr_prop)
      end
    end
  end
end
