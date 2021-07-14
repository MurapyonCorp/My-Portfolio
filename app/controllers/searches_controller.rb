class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    elsif @range == "Event"
      @events = Event.looks(params[:search], params[:word])
    else
      @tasks = Task.looks(params[:search], params[:word])
    end
  end
end
