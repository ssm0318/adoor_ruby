class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:friends]

    def friends
        #TODO : change User.find(1) to current_user after sign_in
        @friends = current_user.friends
    end
end
