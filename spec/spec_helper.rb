require 'bundler/setup'

begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
end

require 'minitest/autorun'
require 'selo_ring'

module SeloRing
  class Server; attr_reader :ts end
end

module SeloRing::Tool
  class << self; attr_accessor :rf end
end
