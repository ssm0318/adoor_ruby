class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    def new
    end 

    def create
    end

    
end
 