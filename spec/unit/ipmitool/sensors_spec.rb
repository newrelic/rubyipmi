require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe :Sensors do

  before :each do
    data = nil
    provider = "ipmitool"
    user = "ipmiuser"
    pass = "impipass"
    host = "ipmihost"
    @conn = Rubyipmi.connect(user, pass, host, provider, true)
    @sensors = @conn.sensors
    File.open('spec/fixtures/ipmitool/sensor.txt','r') do |file|
      data = file.read
    end
    @sensors.stub(:getsensors).and_return(data)
  end

  it "can return a list of sensors" do
   @sensors.list.should_not be_nil
  end

  it "should return a count of sensors" do
    @sensors.count.should eq(63)
  end

  it "should return a list of fan names" do
    @sensors.fanlist.count.should eq(17)
  end

  it 'should return a list of temp names' do
    @sensors.templist.count.should.should eq(14)
  end

  it 'should return a list of sensor names as an array' do
    @sensors.names.should be_an_instance_of(Array)
    @sensors.names.count.should eq(63)
  end


end

