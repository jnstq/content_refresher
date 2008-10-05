require File.dirname(__FILE__) + '/../spec_helper'

describe DefaultsController, "defaults value" do

  before(:each) do
    @settings = DefaultsController.read_inheritable_attribute(:content_refresher).first
  end

  it "should have default value for update frequency" do
    @settings[:show][:every].should eql(30000)
  end

  it "should have default value for error tag id" do
    @settings[:show][:error_tag_id].should eql("lost_connection_to_server")
  end

end
