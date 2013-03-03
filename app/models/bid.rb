class Bid < ActiveRecord::Base
  attr_accessible :amount, :twitter_verified_user, :user

  belongs_to :user
  belongs_to :twitter_verified_user
end
