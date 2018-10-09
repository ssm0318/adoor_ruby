class QuestionsController < ApplicationController
    
    def today
        
        @questions = Question.where(selected_date: (Date.today ))

    end

end
