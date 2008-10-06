require File.dirname(__FILE__) + '/../spec_helper'

describe LambdasController do
  before do
    @post = Post.create(:title => 'Lorem ipsum', :body => 'Dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
  end
  it "should accept lambda for pull_path" do
    get :publish_options_for_refresher, :id => @post.id
    assigns[:options_for_refresher][:pull_path].should eql('/posts/1/changed')
  end
  it "should accept lambda for refresh_path" do
    get :publish_options_for_refresher, :id => @post.id
    puts assigns[:options_for_refresher][:refresh_path]
    assigns[:options_for_refresher][:refresh_path].should eql('/posts/1')
  end
end
