class BidsController < ApplicationController
  def create
    @bid = Bid.new(params["bid"])
    respond_to do |format|
      if @bid.save
        flash[:success] = "Your bid of #{view_context.number_to_currency(@bid.amount)} was successfully created!"
        format.html { redirect_to(:back) }
        format.js
      else
        flash[:error] = "There was a problem submitting your bid."
        format.html { redirect_to(:back) }
      end
    end
  end

  def update
    @bid = Bid.find(params['id'])
    new_amount = params['bid']['amount'].to_d || 0.0

    # This should never happen.
    if @bid.nil?
      flash[:error] = "You must have a bid to update it!"
      redirect_to(:back) and return
    end

    if @bid.amount >= new_amount
      flash[:error] = "Your new bid must be higher than your current bid of #{view_context.number_to_currency(@bid.amount)}."
      redirect_to(:back) and return
    end

    @bid.amount = new_amount
    if @bid.save!
      flash[:success] = "Your bid has been updated to #{view_context.number_to_currency(params['bid']['amount'])}!"
    else
      flash[:error] = 'There was an error updating your bid.'
    end

    redirect_to(:back)
  end
end
