require 'json'

module Shared
  module Properties

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def register_cached_properties(*props)
        props.each do |prop|
          class_eval <<-EVAL
            def #{prop}
              @cached_#{prop} ||= load_property(:#{prop})
            end

            def #{prop}= (val)
              @cached_#{prop} = val
            end
          EVAL
        end

        class_eval <<-EVAL
          def cached_properties
            #{props}
          end
        EVAL
      end

      def register_properties(*props)
        props.each do |prop|

          class_eval <<-EVAL
            def #{prop}
              @#{prop} ||= load_property(:#{prop})
            end

            def #{prop}= (val)
              @#{prop} = val
              save_property(:#{prop})
              @#{prop}
            end
          EVAL

        end

        class_eval <<-EVAL
          def properties
            #{props}
          end
        EVAL
      end

    end

    def increment(property, by = 1)
      prop = send(property).to_f

      unless by == 0
        incr_prop = prop + by
        set_prop(property, incr_prop)
      end
    end

    def get_property(prop)
      send(prop)
    end

    def set_property(prop, val)
      send("#{prop}=", val)
    end

    def load_property(prop)
      val = redis.hget(prefix + self.getId.to_s, prop.to_s)
      res = (val && val.length > 2) ?  JSON.parse(val)["value"] : val

      res
    end

    def save_property(p)
      val = JSON.generate("value" => get_property(p))
      redis.hset(prefix + self.getId.to_s, p.to_s, val)
    end

    def save_properties
      cached_properties.each { |p| save_property(p) }
    end

    def redis
      @redis_con ||= RedisConnection.new_connection
    end

    def prefix
      self.class.to_s[0].downcase
    end

  end
end