class TwitterVerifiedUsersController < ApplicationController

def show
	@hero = TwitterVerifiedUser.find(params[:id])
end

end