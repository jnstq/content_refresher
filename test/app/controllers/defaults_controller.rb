class DefaultsController < ApplicationController
  include Equipe::ContentRefresher
  refresh :show
  def changed
  end  
  def show
  end
end