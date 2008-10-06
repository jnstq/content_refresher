class LambdasController < ApplicationController
  include Equipe::ContentRefresher
  refresh :publish_options_for_refresher, :every => 5.seconds, :pull_path => lambda { changed_post_path(@post) }, :refresh_path => lambda { post_path(@post) }
  
  def publish_options_for_refresher
    @post = Post.find(params[:id])
    @options_for_refresher = options_for_refresher
    head :ok
  end
  
  def model_object_variable_name
    "@post"
  end
  
end