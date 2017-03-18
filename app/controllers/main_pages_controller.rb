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
    user_id = json['event_data']['user_id']
    labels = json['event_data']['labels']

    if labels.include?(315555) then
      #5 minutes
      count = 1
    elsif labels.include?(1226937) then
      #15 minutes
      count = 4
    elsif labels.include?(1226938) then
      #30 minutes
      count = 9
    elsif labels.include?(1226939) then
      #60 minutes
      count = 18
    else
      count = 1
    end

    if labels.include?(1227043) then
      #Easy
      scale = 0.5
    elsif labels.include?(1227044) then
      #Normal
      scale = 1.0
    elsif labels.include?(1227158) then
      #Hard
      scale = 1.5
    else
      scale = 1.0
    end

    @counter = Counter.find_by_id(user_id)
    if @counter.nil? then
      @counter = Counter.create do |c|
        c.id = user_id
        c.count = count * scale
      end
    else
      @counter.count = @counter.count + count * scale
      @counter.save!
    end

    respond_to do |format|
      format.html { render json: @counter}
    end

  end

  def get_game_count
    user_id = params[:user_id]
    render json: {error: "resource not found"}, status: 400 and return unless user_id
    @counter = Counter.find_by_id(user_id)
    respond_to do |format|
      format.html { render json: @counter}
    end
  end

  def consume_game_count
    user_id = params[:user_id]
    consume_point = params[:point]
    render json: {error: "user id not found"}, status: 400 and return unless user_id
    render json: {error: "point not found"}, status: 400 and return unless consume_point
    @counter = Counter.find_by_id(user_id)
    render json: {error: "resource not found"}, status: 400 and return unless @counter
    @counter.count = @counter.count - consume_point.to_i
    @counter.save!
    respond_to do |format|
      format.html { render json: @counter}
    end
  end

end
