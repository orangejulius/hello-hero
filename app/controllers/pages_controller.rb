class PagesController < ApplicationController
  def index #home
    @heroes = TwitterVerifiedUser.where("data != ''").order('followers_count DESC').limit(100).sample(3)
  end

  def about
  end

  def faq
  end

  def terms
  end

  def privacy
  end

  def contact
  end
  
  def make_a_dream_come_true
  end
end
