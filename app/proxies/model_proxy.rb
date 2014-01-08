require 'delegate'

class ModelProxy < SimpleDelegator

  def self.delegate_to_class(klass)
    class_eval <<-EVAL
      def self.method_missing(method_name, *attrs, &blk)
        if #{klass}.respond_to?(method_name)
           #{klass}.send(method_name, *attrs, &blk)
        else
          super
        end
      end
    EVAL
  end

  def self.wrap(collection)
    collection.map { |e| self.new(e) }
  end

end