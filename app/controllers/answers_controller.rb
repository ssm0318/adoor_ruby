class AnswersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_answer, only: [:show, :edit, :update, :destroy]
    before_action :check_mine, only: [:edit, :update, :destroy]

    def new
        unless ajax_request?
            redirect_to root_url
        else
            @question = Question.find(params[:id])
            @answer = Answer.new

            html_content = render_to_string :partial => 'answers/form', :locals => { :answer => @answer, :@question => @question }
            render :json => { 
                html_content: "#{html_content}",
            }
        end
    end
    
    def create 
        @answer = Answer.new(answer_params)
        @answer.save

        if !@answer.tag_string.nil?
            tag_array = @answer.tag_string.gsub("\r\n", '\n').split('\n')
            tag_array.each do |tag|
                new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
                @answer.tags << new_tag
            end
        end

        channels = []   # 선택된 채널들을 갖고 있다.
        channels = Channel.find(params[:c]) if params[:c]
        channels.each do |c|
            Entrance.create(channel: c, target: @answer)
        end
       
        render :json => {

        }
    end

    def show
        @anonymous = @answer.author_id != current_user.id && !(current_user.friends.include? @answer.author)
    end

    def edit
        unless ajax_request?
            redirect_to root_url
        else
        html_content = render_to_string :partial => 'answers/form', :locals => { :answer => @answer, :@question => @answer.question }
        render :json => { 
            html_content: "#{html_content}",
        }
        end
    end

def update
        if @answer.update(answer_params)
            @answer.tags.destroy_all

            if !@answer.tag_string.nil?
                tag_array = @answer.tag_string.gsub("\r\n", "\n").split("\n") 
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: @answer.author.id, content: tag, target: @answer)
                    @answer.tags << Tag.find(new_tag.id)
                end
            end

            Entrance.where(target: @answer).destroy_all
            channels = []   # 선택된 채널들을 갖고 있다.
            channels = Channel.find(params[:c]) if params[:c]
            channels.each do |c|
                Entrance.create(channel: c, target: @answer)
            end

            channel_names = ""
            channels.each do |channel|
                channel_names += channel.name + " "
            end

            render :json => {
                id: @answer.id,
                channels: channel_names
            }
        else
            render 'edit'
        end
    end

    def destroy
        @answer.destroy 
    end

    private
        def set_answer
            @answer = Answer.find(params[:id])
        end

        def answer_params
            params.require(:answer).permit(:author_id, :question_id, :content, :tag_string)
        end 

        def check_mine
            if @answer.author_id != current_user.id
                redirect_to root_url
            end
        end

        def ajax_request?
            (defined? request) && request.xhr?
        end
end
