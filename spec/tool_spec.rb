require 'spec_helper'
require 'selo_ring/tool'

describe SeloRing::Tool do
  before do
    @ts = MiniTest::Mock.new
    set_lookup_ring(@ts)

    DRb.start_service
    @tuple = [:name, :Test, DRbObject.new(self), 'Test Service']
  end

  it "should list all remote DRb services" do
    expected = { DRb.uri => [@tuple] }
    check_list_services do
      SeloRing::Tool.list_services.must_equal expected
    end
  end

  it "should print all remote DRb services" do
    expected = <<-EOF
Services on #{DRb.uri}
\t:Test, "Test Service"
\t\tURI: #{DRb.uri} ref: #{self.object_id}
EOF
    check_list_services do
      out, err = capture_io do
        SeloRing::Tool.print_services
      end

      out.must_equal expected
      err.must_equal ""
    end
  end

  after do
    DRb.stop_service
  end

  def check_list_services
    @ts.expect :__drburi, DRb.uri
    @ts.expect :read_all, [@tuple], [[:name, nil, DRbObject, nil]]

    yield if block_given?

    @ts.verify
  end
end
