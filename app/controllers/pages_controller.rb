class PagesController < ApplicationController
  def index #home
    @heroes = TwitterVerifiedUser.limit(3)
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
  end

  def typeahead
  end
end
