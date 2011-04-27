module SeloRing
  require 'rinda/ring'
  require 'rinda/tuplespace'
  require 'configuration'

  Configuration.path = %w(/etc/selo /usr/local/etc/selo) << \
  File.expand_path('../config', __FILE__)

  @conf = Configuration.for 'selo_ring_server'
  class << self; attr_reader :conf  end

  begin
    require 'drb/unix' if conf.server.uri =~ /^drbunix/
  rescue NoMethodError
  end

  autoload :Server, 'selo_ring/server'
  autoload :Tool,   'selo_ring/tool'
end
