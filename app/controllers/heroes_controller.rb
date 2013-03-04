class HeroesController < ApplicationController
  def index
    @bids = Bid.find(:all, :order => 'amount DESC', :limit => 10)
  end

  def leaderboard
    @hero = TwitterVerifiedUser.find_by_name(params[:name])

    if @hero.nil?
      redirect_to root_path, :notice => "Sorry... #{params[:name]} isn't a person in our system at this time. <a href='mailto:hi@hellohero.co'>Contact us</a> to add them!" and return
    end

    if current_user.nil?
      @bid = Bid.new
    else
      # Find intersection of hero's bids and user's bids,
      # grab (what should be) the only entry / aka first entry,
      # if it doesn't exist then create a new bid.
      # This is used to either allow the user to place a new bid for the first time,
      # or update their existing bid (but only increase it).
      @bid = (@hero.bids & current_user.bids).first || Bid.new
    end
  end
end
