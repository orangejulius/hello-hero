class HeroesController < ApplicationController
  def index
    @bids = Bid.find(:all, :order => 'amount DESC', :limit => 10)
  end

  def leaderboard
    @hero = TwitterVerifiedUser.find_by_name(params[:name])

    # Find intersection of hero's bids and user's bids,
    # grab (what should be) the only entry / aka first entry,
    # if it doesn't exist then create a new bid.
    # This is used to either allow the user to place a new bid for the first time,
    # or update their existing bid (but only increase it).
    @bid = (@hero.bids & current_user.bids).first || Bid.new

    unless @hero
      flash[:error] = "No one named #{params[:name]} was found..."
      redirect_to :action => :index
    end
  end
end
