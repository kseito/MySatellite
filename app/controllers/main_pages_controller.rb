require 'json'

class MainPagesController < ApplicationController
  protect_from_forgery except: [:calc_count, :get_count]

  def home
  end

  def help
  end

  def about
  end
  
  def calc_count
    
    json = JSON.parse(request.body.read)
    priority = json['event_data']['priority']
    case priority
    when 4 then
      count = 12
    when 3 then
      count = 4
    when 2 then
      count = 2
    else
      count = 1
    end
    
    @counter = Counter.find_by_id(FIXED_ID)
    if @counter.nil? then
      @counter = Counter.create do |c|
        c.id = FIXED_ID
        c.count = count
      end
    else
      @counter.count = @counter.count + count
      @counter.save!
    end
    
    respond_to do |format|
      format.html { render json: @counter}
    end
    
  end
  
  def get_game_count
    @counter = Counter.find_by_id(FIXED_ID)
    respond_to do |format|
      format.html { render json: @counter}
    end
  end
  
  def consume_game_count
    @counter = Counter.find_by_id(FIXED_ID)
    render_error(404, "resource not found") and return unless @counter
    @counter.count = @counter.count - 4
    @counter.save!
    respond_to do |format|
      format.html { render json: @counter}
    end
  end
  
end
