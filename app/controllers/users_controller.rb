class UsersController < ApplicationController
    def friends
        #TODO : change User.find(1) to current_user after sign_in
        @friends = User.find(3).friends
    end
end
