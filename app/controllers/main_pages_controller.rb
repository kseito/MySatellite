class MainPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end
  
  def calc_count
    @counter = Counter.find_by_id(1)
    render_error(404, "resource not found") and return unless @counter
    @counter.count = 6
    @counter.save!
    respond_to do |format|
      format.html { render json: @counter}
    end
  end
end
