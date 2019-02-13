class AssignmentsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        question_assignments = current_user.received_assignments.where(target_type: 'Question').where.not(assigner_id: 1).order(created_at: :desc)
        @question_ids = question_assignments.pluck(:target_id).uniq
        @waiting_questions = []
        @answered_questions = []
        @question_ids.each do |q_id|
            if Answer.where(author: current_user, question: Question.find(q_id)).empty?
                @waiting_questions.push(Question.find(q_id))
            else
                @answered_questions.push(Question.find(q_id))
            end
        end
        custom_assignments = current_user.received_assignments.where(target_type: 'CustomQuestion').order(created_at: :desc)
        @custom_question_ids = custom_assignments.pluck(:target_id).uniq
    end

    def new
        html_content = render_to_string :partial => 'assignments/default', 
            :locals => { :question => Question.find(params[:question_id]) }

        render json: {
            html_content: html_content,
        }
    end

    def new_custom
        # FIXME: 수정아 사랑해
        html_content = render_to_string :partial => 'assignments/default_custom', 
        :locals => { :custom_question => CustomQuestion.find(CustomQuestion.find(params[:custom_question_id]).ancestor_id) }

        render json: {
            html_content: html_content,
        }
    end

    def create
        Assignment.create(target: Question.find(params[:question_id]), assigner_id: current_user.id, assignee_id: params[:assignee_id])

        render json: {
            assigned_user: User.find(params[:assignee_id])
        }
 
    end

    def create_custom
        # FIXME: 수정아 사랑해
        # 꼭 ancestor로 넣어줘야함! 그래야 같은 질문을 assign한 사람이 두명 이상일 때 그들 모두에게 noti가 잘 감. (요거 때문에 custom question 내용 수정 가능하게 하면 복잡해질듯ㅠ)
        ancestor = CustomQuestion.find(CustomQuestion.find(params[:custom_question_id]).ancestor_id)
        Assignment.create(target: ancestor, assigner_id: current_user.id, assignee_id: params[:assignee_id])

        render json: {
            assigned_user: User.find(params[:assignee_id])
        }
    end

    def destroy
        assignee_id = params[:assignee_id]
        question_id = params[:question_id]
        assigner_id = current_user.id
        assignment = Assignment.where(target: Question.find(question_id), assigner_id: assigner_id, assignee_id: assignee_id)
        assignment.destroy_all

        # flash[:success] = "#{User.find(assignment.assignee_id).email}님을 de-assign하셨습니다."

        render json: {
            assigned_user: User.find(assignee_id)
        }
    end

    def destroy_custom
        # FIXME: 수정아 사랑해
        assignee_id = params[:assignee_id]
        ancestor = CustomQuestion.find(CustomQuestion.find(params[:custom_question_id]).ancestor_id)
        assigner_id = current_user.id
        assignment = Assignment.where(target: ancestor, assigner_id: assigner_id, assignee_id: assignee_id)
        assignment.destroy_all

        # flash[:success] = "#{User.find(assignment.assignee_id).email}님을 de-assign하셨습니다."

        render json: {
            assigned_user: User.find(assignee_id)
        }
    end
end