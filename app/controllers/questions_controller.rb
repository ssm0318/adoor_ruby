class QuestionsController < ApplicationController
    
    def today
        # start_id = (Date.today-Date.parse("2018-01-01")).to_i % (Question.where(author_id: 1).count/5) * 5 + 1

        # @questions = []

        # i=0
        # while i < 5 do
        #     if start_id < Question.all.count
        #         @questions.push(Question.where(author_id: 1)[start_id])
        #         start_id += 1
        #     end
        #     i += 1
        # end 
        @questions = Question.where(selected_date: Date.today)

    end

end
