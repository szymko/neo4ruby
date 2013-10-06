module Mock
  module Rabbit
    def setup_bunny
      @connection = Bunny.new
      @connection.start()
      @channel = @connection.create_channel()

      Bunny.stubs(:new).returns(@connection)
      @connection.stubs(:start)
      @connection.stubs(:create_channel).returns(@channel)
    end

    def teardown_bunny
      @channel.close() if can_close?(@channel)
      @connection.close() if can_close?(@connection)
    end

    def can_close?(bunny_object)
      bunny_object && bunny_object.open?
    end

  end
end