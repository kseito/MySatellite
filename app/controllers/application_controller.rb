class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
#   protect_from_forgery with: :exception
  
  def index
    @counters = Counter.all
    respond_to do |format|
      format.json { render json: @counters}
    end
  end
  
  def show
    @counter = Counter.find_by_id(params[:id])
    respond_to do |format|
      format.json { render json: @counter}
    end
  end
  
  def create
    (render_error(400, "missing counter param") unless params[:count]) and return
    @counter = Counter.create( count: params[:count])
    respond_to do |format|
      format.json { render json: @counter, status: 201}
    end
  end
  
  def update
    @counter = Counter.find_by_id(params[:id])
    render_error(404, "resource not found") and return unless @counter
    @counter.count = params[:count]
    @counter.save!
    respond_to do |format|
      format.json { render json: @counter}
    end
  end
  
  def render_error(status, msg)
    render :text => msg, :status => status
  end
  
end
