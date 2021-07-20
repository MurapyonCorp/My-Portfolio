class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Event"
      @events = Event.looks(params[:search], params[:word]).includes(:user).page(params[:page])
    else
      @tasks = Task.looks(params[:search], params[:word]).includes(:user).page(params[:page])
    end
  end
end
