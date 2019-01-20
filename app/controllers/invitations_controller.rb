class InvitationsController < ApplicationController
    before_action :authenticate_user!, except: [:accept]

    def index
        @questions = []
        if (n = (7 - @questions.length)) > 0
            @questions = Question.where.not(selected_date: nil).sample(n) # 답변된 질문이 부족하면 공개된 질문 중 랜덤하게 take
        end
        render 'index' 
    end 

    def link
        assigned_questions = []   # 선택된 question들을 갖고 있다 (최대 3개, 최소 0개)
        assigned_questions = Question.find(params[:q]) if params[:q]
        #FIXME: 이 부분은 deploy할 때 링크 꼭 바꿔줘야 함!! ---> https://adoor.app/....
        if Rails.env.production?
            @link = "adoor.app/invitation/#{current_user.id}"
        elsif Rails.env.development?
            @link = "localhost:3000/invitation/#{current_user.id}"
        end
        assigned_questions.each do |q|
            @link += "/" + q.id.to_s
        end
        if assigned_questions.empty?
            @link += "/" + "empty"
        end
        # now the link looks like ".../invitation/:user_id/:qid1/:qid2/:qid3" (qid's are optional)
        render 'link'
    end

    def accept
        @new_friend = User.find(params[:id])
        @assigned_questions = []
        if params[:question_id1] != "empty"
            @assigned_questions.push(Question.find(params[:question_id1])) # empty도 아니면서 question_id 가 하나도 없는 경우는 잘못된 링크이므로 이걸 걸러내기 위해
            @assigned_questions.push(Question.find(params[:question_id2])) if params[:question_id2]
            @assigned_questions.push(Question.find(params[:question_id3])) if params[:question_id3]

            if !user_signed_in?
                #session[:invitation] = request.referer
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
        render 'accept'
    end
end
