class TwitterVerifiedUsersController < ApplicationController

def index
  @heroes = TwitterVerfiedUser.all
end

def show
	@hero = TwitterVerifiedUser.find(params[:id])
end

end