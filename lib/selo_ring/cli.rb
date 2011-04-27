module SeloRing
  require 'fileutils'
  require 'thor'

  class CLI < Thor
    default_task :list
    
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
      if options[:info] || options.empty?
        puts "Configuration load order"
        Configuration.path.each_index {|p| puts "#{p} - #{Configuration.path[p]}"}
        puts
        puts "Server:\n#{SeloRing.conf.server.to_hash}"
        puts "Daemon:\n#{SeloRing.conf.daemon.to_hash}"
      end

      case options[:copy]
      when '0'
        FileUtils.cp_r Configuration.path[2], Configuration.path[0]
        puts "#{Configuration.path[2]} copied to #{Configuration.path[0]}"
      when '1'
        FileUtils.cp_r Configuration.path[2], Configuration.path[1]
        puts "#{Configuration.path[2]} copied to #{Configuration.path[1]}"
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
        require 'selo_ring/server'
        Server.start(conf.server.to_hash)
      end
    end
  end
end
