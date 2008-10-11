require File.dirname(__FILE__) + '/../spec_helper'

describe ReloadsController do
  integrate_views
  before(:each) do
    Reload.stub!(:find).and_return(Reload.new)
  end
  it "should add reload content" do
    get :show, :id => 1
    response.body.should match(/reloadContentLoop/)
  end
end
