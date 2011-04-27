module SeloRing
  require 'thor'

  class CLI < Thor
    include Thor::Actions

    default_task :list
    source_root File.expand_path('../', Configuration.path[2])

    desc "list", "List avaliable ring servers and their services"
    def list
      Tool.print_services
    end

    desc "config", "Write config"
    method_option "info", :type => :boolean, :aliases => '-i', :banner =>
      "Server and Daemon config options"
    method_option "copy", :type => :string, :aliases => '-c', :banner =>
      "Copy default config to specified [0,1] location"
    def config
      conf = SeloRing.conf

      if options[:info] || options.empty?
        puts "Configuration load order"
        Configuration.path.each_index {|p| puts "#{p} - #{Configuration.path[p]}"}
        puts
        puts "Server:\n#{conf.server.to_hash}"
        puts "Daemon:\n#{conf.daemon.to_hash}"
      end

      case options[:copy]
      when '0'
        directory "config", Configuration.path[0], :verbose => true
      when '1'
        directory "config", Configuration.path[1], :verbose => true
     else
        warn "Wrong path run for info:\n\tselo_ring_server config"
      end if options[:copy]
    end

    desc "daemon", "Run as daemon"
    def daemon(*dargs)
      conf = SeloRing.conf
      opts = conf.daemon.to_hash.merge({
                                         :ARGV => dargs,
                                         :stop_proc => proc { Server.stop }
                                       })

      require 'daemons'
      Daemons.run_proc("selo_ring_server", opts) do
        Server.start(conf.server.to_hash)
      end
    end
  end
end
