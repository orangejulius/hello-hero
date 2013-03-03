class PagesController < ApplicationController
  def index #home
    @heroes = TwitterVerifiedUser.order('followers_count DESC').limit(100).sample(3)
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
  end
end
