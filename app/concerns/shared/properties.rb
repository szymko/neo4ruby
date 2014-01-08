require 'json'

module Shared
  module Properties

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def register_props(*props)
        props.each do |prop|
          class_eval <<-EVAL
            def #{prop}
              get_prop(:#{prop})
            end

            def #{prop}=(val)
              set_prop(:#{prop}, val)
            end
          EVAL
        end
      end

    end

    def increment(property, by = 1)
      prop = send(property).to_f

      unless by == 0
        incr_prop = prop + by
        set_prop(property, incr_prop)
      end
    end

    def set_prop(prop, val)
      #transaction { send("#{prop}=", val) }
      val = JSON.generate("value" => val)
      redis.hset(prefix + self.getId.to_s, prop.to_s, val)
    end

    def get_prop(prop)
      val = redis.hget(prefix + self.getId.to_s, prop.to_s)
      res = (val && val.length > 2) ?  JSON.parse(val)["value"] : val

      res
    end

    def redis
      @redis_con ||= RedisConnection.new_connection
    end

    def prefix
      self.class.to_s[0].downcase
    end

  end
end