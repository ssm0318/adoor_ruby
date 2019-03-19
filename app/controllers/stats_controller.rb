class StatsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def daily
    end

    def monthly
    end

    private

    def check_admin
      redirect_to root_url unless current_user.has_role? :admin
    end
end
