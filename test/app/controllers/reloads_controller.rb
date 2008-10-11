class ReloadsController < ApplicationController  
  include Equipe::ContentRefresher
  refresh :show, :every => 5.seconds, :check => false
  
  def show
    @reload = Reload.find(params[:id])
    render :text => '<body></body>'
  end
end