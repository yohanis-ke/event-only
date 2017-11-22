class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
    @events = @location.events
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])

    @location.name = params[:location][:name]
    @location.city = params[:location][:city]
    @location.description = params[:location][:description]
    @location.image = params[:location][:image]

    if @location.save
      redirect_to @location
    else
      redirect_to @location
    end
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new
    @location.name = params[:location][:name]
    @location.city = params[:location][:city]
    @location.description = params[:location][:description]
    @location.image = params[:location][:image]

    if @location.save
      redirect_to locations_path
    else
      redirect_to new_location_path
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to locations_path
  end

end
