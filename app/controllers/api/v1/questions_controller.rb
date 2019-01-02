class Api::V1::QuestionsController < Api::V1::BaseController
    def show
      question = Question.find(params[:id])
      render(json: Api::V1::QuestionSerializer.new(question).to_json)
    end
  end