require 'bunny'

class Neo4rubyServer

  def initialize(payload_processor)
    @processor = payload_processor
  end

  def open
    @conn = Bunny.new
    @conn.start
    @ch = @conn.create_channel
  end

  def listen(queue_name, separator = ',')
    open

    @queue = @ch.queue(queue_name)
    @exchange = @ch.default_exchange

    @queue.subscribe(:block => true) do |delivery_info, properties, payload|
      article = payload.split(separator)
      r = processor.run(article)

      @exchange.publish(r.to_s, :routing_key => properties.reply_to, :correlation_id => properties.correlation_id)
    end
  end

  def shutdown
    @ch.close
    @conn.close
  end

end

# begin
#   server = Neo4rubyServer.new
#   server.listen("rpc_queue")
# rescue Interrupt => _
#   server.shutdown
# end