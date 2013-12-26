module Shared
  module ModelUtility

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def destroy_all
        all.each do |el|
          transaction { el.del }
        end
      end

      def count
        all.to_a.count
      end

      def find_or_create(attrs)
        find(attrs).first || transaction_create(attrs)
      end

      def first
        all.to_a.first
      end

      def last
        all.to_a.last
      end

      def find_one(attrs)
        find(attrs).first
      end
    end
  end
end