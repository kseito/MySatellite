class CountersController < ApplicationController
  protect_from_forgery except: [:create, :update]

  def index
    @counters = Counter.all
    respond_to do |format|
      format.html { render json: @counters}
    end
  end
  
  def show
    @counter = Counter.find_by_id(params[:id])
    respond_to do |format|
      format.html { render json: @counter}
    end
  end
  
  def create
    (render_error(400, "missing counter param") unless params[:count]) and return
    @counter = Counter.create( count: params[:count])
    respond_to do |format|
      format.html { render json: @counter, status: 201}
    end
  end
  
  def update
    @counter = Counter.find_by_id(params[:id])
    render_error(404, "resource not found") and return unless @counter
    @counter.count = params[:count]
    @counter.save!
    respond_to do |format|
      format.html { render json: @counter}
    end
  end

end
