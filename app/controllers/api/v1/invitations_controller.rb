class Api::V1::InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:accept]

  def index
    @questions = []
    if (n = (7 - @questions.length)) > 0
      @questions = Question.published.sample(n) # 답변된 질문이 부족하면 공개된 질문 중 랜덤하게 take
    end

    # render :index, locals: { questions: @questions }
  end

  def link
    assigned_questions = [] # 선택된 question들을 갖고 있다 (최대 3개, 최소 0개)
    assigned_questions = Question.find(params[:q]) if params[:q]
    if Rails.env.production?
      @link = "https://adoor.app/invitations/#{current_user.id}"
    elsif Rails.env.development?
      @link = "localhost:3000/invitations/#{current_user.id}"
    end
    assigned_questions.each do |q|
      @link += '/' + q.id.to_s
    end
    @link += '/' + 'empty' if assigned_questions.empty?
    # now the link looks like ".../invitations/:user_id/:qid1/:qid2/:qid3" (qid's are optional)
    
    # render :link
    render json: {status: 'SUCCESS', message:'Created invitation link', data: @link}, status: :ok
  end

  def accept
    @new_friend = User.find(params[:id])
    @assigned_questions = []
    if params[:question_id1] != 'empty'
      @assigned_questions.push(Question.find(params[:question_id1])) # empty도 아니면서 question_id 가 하나도 없는 경우는 잘못된 링크이므로 이걸 걸러내기 위해
      @assigned_questions.push(Question.find(params[:question_id2])) if params[:question_id2]
      @assigned_questions.push(Question.find(params[:question_id3])) if params[:question_id3]

      if !user_signed_in?
      # session[:invitation] = request.referer
      elsif current_user.id == @new_friend.id
      elsif current_user.friends.include? @new_friend
        @assigned_questions.each do |q|
          Assignment.find_or_create_by(question_id: q.id, assigner_id: @new_friend.id, assignee_id: current_user.id)
        end
      else
        @assigned_questions.each do |q|
          # assigner가 admin인 assignment 만들기
          # 이 경우 noti는 생성이 안되지만, assignment는 생성됨. 즉, assignment 모아보는 페이지에서는 이 질문들이 보임!(그럴 예정)
          Assignment.find_or_create_by(question_id: q.id, assigner_id: 1, assignee_id: current_user.id)
        end
      end
    end

    # render :accept, locals: { new_friend: @new_friend, assigned_questions: @assigned_questions }

    # private

    # def authenticate_user
    #   user_token = request.headers['X-USER-TOKEN']
    #   if user_token
    #     @user = User.find_by_token(user_token)
    #     #Unauthorize if a user object is not returned
    #     if @user.nil?
    #       return unauthorize
    #     end
    #   else
    #     return unauthorize
    #   end
    # end

    # def unauthorize
    #   head status: :unauthorized
    #   return false
    # end
  end
end
