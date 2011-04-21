require 'spec_helper'
require 'selo_ring/server'

describe SeloRing::Server do
  before do
    @rs = SeloRing::Server.new
  end

  it "should start server with activity logging" do
    out, err = capture_io do
      @rs.activity_logging
      @rs.ts.write [:name, :Test, DRbObject.new(self), ''], 0
      sleep 0.1 # need to wait
    end

    expected = <<-EOF
write Test  URI: #{DRb.uri} ref: #{self.object_id}
delete Test  URI: #{DRb.uri} ref: #{self.object_id}
EOF

    out.must_equal expected
    err.must_equal ""
  end

  after do
    @rs.stop
  end
end
