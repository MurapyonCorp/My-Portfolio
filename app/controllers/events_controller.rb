class EventsController < ApplicationController
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      redirect_to request.referer
    else
      @events = Event.all
      render :index
    end
  end

  def index
    @events = Event.all
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @user = @event.user
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def event_params
    params.require(:event).permit(:title, :body, :location, :start_date, :end_date)
  end
end
