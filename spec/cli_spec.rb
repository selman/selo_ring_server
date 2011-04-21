require 'spec_helper'
require 'selo_ring/cli'

require 'tempfile'

describe SeloRing::CLI do

  describe "when with(out) list" do
    before do
      @ts = MiniTest::Mock.new

      rf = Object.new
      rf.instance_variable_set(:@ts, @ts)
      def rf.lookup_ring; yield(@ts) end
      SeloRing::Tool.rf = rf

      DRb.start_service

      @tuple = [:name, :Test, DRbObject.new(self), 'Test Service']
      @services = { DRb.uri => [@tuple] }
    end

    it "should list avaliable ring servers and their services" do
      expected = <<-EOF
Services on #{DRb.uri}
\t:Test, "Test Service"
\t\tURI: #{DRb.uri} ref: #{self.object_id}
EOF

      @ts.expect :__drburi, DRb.uri
      @ts.expect :read_all, [@tuple], [[:name, nil, DRbObject, nil]]

      #with list parameter
      out, _ = capture_io do
        SeloRing::CLI.start %w(list)
      end

      out.must_equal expected

      #without parameter
      out, _ = capture_io do
        SeloRing::CLI.start []
      end

      out.must_equal expected
      @ts.verify
    end

    after do
      DRb.stop_service
    end
  end

  describe "when config" do
    before do
      Configuration.path[0] = Configuration.path[1] = Dir.tmpdir
    end

    it "should print config information with(out) info" do
      expected =
        /Configuration load order.*Server:.*Daemon:.*/m

      out, _ = capture_io do
        SeloRing::CLI.start %w(config)
      end

      out.must_match expected
    end

    it "should copy default config to default config directories with copy=0" do
      capture_io do
        SeloRing::CLI.start %w(config -c 0)
      end

      test("e", "#{Dir.tmpdir}/config/selo_ring_server.rb").must_equal true
    end

    it "should copy default config to default config directories with copy=1" do
      capture_io do
        SeloRing::CLI.start %w(config -c 1)
      end

      test("e", "#{Dir.tmpdir}/config/selo_ring_server.rb").must_equal true
    end

    it "should copy default config to default config directories with copy=3" do
      out,err = capture_io do
        SeloRing::CLI.start %w(config -c 2)
      end

      test("e", "#{Dir.tmpdir}/config/selo_ring_server.rb").must_equal false

      err.must_match "Wrong path"
      out.must_equal ""
    end

    after do
      FileUtils.rm_rf "#{Dir.tmpdir}/config"
    end
  end

  describe "when daemon" do
    it "should send daemons parameters to daemon" do
      expected =
        /.*start\b.*stop\b.*restart\b.*reload\b.*run\b.*zap\b.*status\b.*/m

      out, _ = capture_io do
        SeloRing::CLI.start %w(daemon)
      end

      out.must_match expected
    end
  end
end
