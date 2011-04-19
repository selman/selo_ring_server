module SeloRing
  ##
  # Miscellaneous tools for general usage.

  module Tool

    ##
    # Return a collection of all remote DRb services.
    # Format:
    # { Rinda::RingServer.__drburi => [ registration_tuple, ... ],
    # ... }

    def self.list_services
      DRb.start_service unless DRb.primary_server

      services = {}
      @rf ||= Rinda::RingFinger.new

      @rf.lookup_ring do |ts|
        services[ts.__drburi] = ts.read_all [:name, nil, DRbObject, nil]
      end
      services
    end

    ##
    # Print all available services on all available Rinda::RingServers to
    # stdout.

    def self.print_services
      out = []
      list_services.each do |ring_server, services|
        out << "Services on #{ring_server}"

        values = services.sort_by { |s| [s[2].__drburi, -s[2].__drbref] }

        values.each do |s|
          out << "\t%p, %p\n\t\tURI: %s ref: %d" %
            [s[1], s[3], s[2].__drburi, s[2].__drbref]
          out << nil
        end
      end

      puts out.join("\n")
    end

  end # module Tool
end # module SeloRing
