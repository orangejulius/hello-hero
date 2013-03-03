class BidsController < ApplicationController

  def create
    @bid = Bid.new(params["bid"])
    respond_to do |format|
      if @bid.save
        format.html { redirect_to( :back, :notice => 'Bid created.')}
        format.js
      else
        format.html { render( :new, :notice => 'Could not create new bid')}
      end
    end
  end

end