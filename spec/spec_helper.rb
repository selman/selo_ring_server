require 'simplecov'
SimpleCov.start

$testing = true

require 'minitest/autorun'
require 'selo_ring'

module SeloRing
  class Server; attr_reader :ts end
end

module SeloRing::Tool
  class << self; attr_accessor :rf end
end
