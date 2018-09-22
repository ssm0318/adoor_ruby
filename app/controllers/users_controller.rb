class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def friends
        @friends = current_user.friends
    end
end
