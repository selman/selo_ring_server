require 'spec_helper'
require 'selo_ring/tool'

module SeloRing::Tool
  class << self; attr_accessor :rf end
end

describe SeloRing::Tool do
  before do
    @ts = MiniTest::Mock.new

    rf = Object.new
    rf.instance_variable_set(:@ts, @ts)
    def rf.lookup_ring; yield(@ts) end
    SeloRing::Tool.rf = rf

    DRb.start_service

    @obj = Object.new
    @tuple = [:name, :Test, DRbObject.new(@obj, DRb.uri), '']
    @services = { DRb.uri => [@tuple] }
  end

  it "should list all remote DRb services" do
    @ts.expect :__drburi, DRb.uri
    @ts.expect :read_all, [@tuple], [[:name, nil, DRbObject, nil]]

    SeloRing::Tool.list_services.must_equal @services
    @ts.verify
  end

  it "should print all remote DRb services" do
    expected = <<-EOF
Services on #{DRb.uri}
\t:Test, ""
\t\tURI: #{DRb.uri} ref: #{@obj.object_id}
EOF

    @ts.expect :__drburi, DRb.uri
    @ts.expect :read_all, [@tuple], [[:name, nil, DRbObject, nil]]

    out, err = capture_io do
      SeloRing::Tool.print_services
    end

    out.must_equal expected
    err.must_equal ""
    @ts.verify
  end
  
  after do
    DRb.stop_service
  end
end
