module SeloRing
  ##
  # SeloRing::Server provides a friendly wrapper around Rinda::RingServer.
  #
  # = Usage
  #
  # == Starting a RingServer
  #
  # From the command line:
  #
  # selo_ring daemon start
  #
  # or from Ruby:
  #
  # SeloRing::Server.new.run

  class Server

    ##
    # Creates and starts a new SeloRing::Server.

    def initialize(opts={})
      uri, _   = opts.delete(:uri), opts.delete(:front)
      @ts      = Rinda::TupleSpace.new
      @verbose = opts[:verbose]

      DRb.start_service(uri, nil, opts) unless DRb.primary_server
    end

    ##
    # Start server

    def start
      activity_logging if @verbose
      puts "listening on #{DRb.uri}"
      Rinda::RingServer.new @ts
      DRb.thread.join
    end

    ##
    # Stop created server

    def stop
      DRb.stop_service
    end

    ##
    # Enables service registration and expiration logging.

    def activity_logging
      %w(write delete).each do |event|
        observer = @ts.notify(event, [:name, nil, DRbObject, nil])
        activity_output(observer)
      end
    end

    private

    ##
    # Prints observers output continuosly screen/log

    def activity_output(obs)
      Thread.start do
        obs.each do |event, tuple|
          puts "#{event} #{tuple[1]} #{tuple[3]} URI: #{tuple[2].__drburi} ref: #{tuple[2].__drbref}"
        end
      end
    end

  end # class Server
end # module SeloRing
