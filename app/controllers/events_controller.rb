class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event
    else
      redirect_back_or_to @event
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to events_path
    else
      redirect_to new_event_path
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  def event_params
    params.require(:event).permit(:name, :data, :capacity)
  end
end
=begin
class EventsController < ApplicationController
  def index
    @events = @location.events
  end

  def show
    @event = Event.find(params[:id])
    ensure_location_match
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to [@location, @event]
    else
      redirect_back_or_to [@location, @event]
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.location = @location

    if @event.save
      redirect_to [@location, @event]
    else
      redirect_to new_location_event_path
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to location_events_path
  end

  def ensure_location_match
    if @event.location != @location
      not_found
    end
  end

  def event_params
    params.require(:event).permit(:name, :date, :capacity)
  end
end
=end
