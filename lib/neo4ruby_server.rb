require 'bunny'

class Neo4rubyServer

  attr_accessor :processor

  def initialize(payload_processor)
    @processor = payload_processor
  end

  def open(opts = {})
    shutdown() if opts[:reopen]

    @conn = Bunny.new
    @conn.start
    @ch = @conn.create_channel
  end

  def listen(queue_name, separator = ',')
    open(reopen: true) unless open?

    @queue = @ch.queue(queue_name)
    @exchange = @ch.default_exchange

    @queue.subscribe(:block => true) do |delivery_info, properties, payload|
      article = payload.split(separator)
      r = processor.run(article)

      @exchange.publish(r.to_s, :routing_key => properties.reply_to, :correlation_id => properties.correlation_id)
    end
  end

  def shutdown
    @ch.close if can_close?(@ch)
    @conn.close if can_close?(@conn)
  end

  def open?
    @conn && @conn.open? && @ch && @ch.open?
  end

  private

  def can_close?(bunny_obj)
    !! bunny_obj && bunny_obj.open?
  end

end
