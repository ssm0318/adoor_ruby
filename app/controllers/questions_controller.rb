class QuestionsController < ApplicationController
    before_action :authenticate_user!, except: [:index]

    def index
        @questions = Question.all
    end
end
