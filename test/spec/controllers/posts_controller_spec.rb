require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController do
  integrate_views
  it "should include content refresher" do
    PostsController.included_modules.should include(Equipe::ContentRefresher)
  end

  describe "save options" do

    before(:each) do
      @settings = PostsController.read_inheritable_attribute(:content_refresher).first
    end

    it "should save action name and options" do
      @settings.should have_key(:show)
    end

    it "should have options for updating frequency" do
      @settings[:show][:every].should eql(5000)
    end

  end
  
  describe "after filter" do

    before(:each) do
      @post = Post.create(:title => 'Lorem ipsum', :body => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod')
      @valid_options_for_refresher = {:id => @post.id, :updated_at => @post.updated_at, :every => 5, :pull_path => "/posts/#{@post.id}/changed.js", :refresh_path => "/posts/#{@post.id}.js"}
    end

    it "should post once after filter" do
      Post.should_receive(:find).once.and_return(@post)
      get :show, :id => @post.id
    end

    it "should execute after filter" do
      controller.should_receive(:add_javascript_for_refresher)
      get :show, :id => @post.id
    end

    it "should return the instance variable" do
      post = @post; controller.instance_eval { @post = post }
      controller.model_object_variable.should eql(post)
    end
    
    it "should return the model class" do
      controller.model_class.should eql(Post)      
    end

    describe "options for refresher" do

      it "should set option for pull path" do
        get :publish_options_for_refresher, :id => @post.id
        assigns[:options_for_refresher][:pull_path].should match(/changed/)
      end
      
      it "should set option for push path" do
        get :publish_options_for_refresher, :id => @post.id
        assigns[:options_for_refresher][:refresh_path].should match(/posts/)
      end

    end

    describe "response body" do

      it "should add javascript the response body" do
        get :show, :id => @post.id
        response.body.should match(/var\s+checkContentRefresherOptions/)
      end

      it "should only call if the action is setuped for refreshing" do
        get :edit, :id => @post.id
        response.body.should_not match(/checkContentRefresherOptions/)
      end
    end
    
    describe "actions" do
      it "should find the post" do
        Post.should_receive(:find).and_return(@post)
        get :changed, :id => @post.id
      end
      it "should return json" do
        Post.stub!(:find).and_return(@post)
        get :changed, :id => @post.id
        response.body.should eql({:id => @post.id, :updated_at => @post.updated_at}.to_json)
      end
    end      

  end
end
