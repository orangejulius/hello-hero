class HeroesController < ApplicationController
  def index
  end

  def leaderboard
    @hero = TwitterVerifiedUser.find_by_name(params[:name])
    unless @hero
      flash[:error] = "No one named #{params[:name]} was found"
      redirect_to :action => :index
    end
  end
end
