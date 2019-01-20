class CustomQuestionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_custom_question, only: [:show, :edit, :update, :destroy]
    before_action :check_mine, only: [:edit, :update, :destroy]

    def create
        @custom_question = CustomQuestion.create(author_id: current_user.id, content: params[:content])

        if !@custom_question.tag_string.nil?
            tag_array = @custom_question.tag_string.gsub("\r\n", '\n').split('\n')
            tag_array.each do |tag|
                new_tag = Tag.create(author_id: @custom_question.author.id, content: tag, target: @custom_question)
                @custom_question.tags << new_tag
            end
        end

        channels = []   # 선택된 채널들을 갖고 있다.
        channels = Channel.find(params[:c]) if params[:c]
        channels.each do |c|
            Entrance.create(channel: c, target: @custom_question)
        end

        redirect_to root_path
    end

    def repost
        @custom_question = CustomQuestion.create(author_id: current_user.id, content: CustomQuestion.find(params[:id]).content, reposted: true)

        # if !@custom_question.tag_string.nil?
        #     tag_array = @custom_question.tag_string.gsub("\r\n", '\n').split('\n')
        #     tag_array.each do |tag|
        #         new_tag = Tag.create(author_id: @custom_question.author.id, content: tag, target: @custom_question)
        #         @custom_question.tags << new_tag
        #     end
        # end

        channels = []   # 선택된 채널들을 갖고 있다.
        channels = Channel.find(params[:c]) if params[:c]
        channels.each do |c|
            Entrance.create(channel: c, target: @custom_question)
        end

        redirect_back(fallback_location: root_path)
    end

    def show
        @anonymous = @custom_question.author_id != current_user.id && !(current_user.friends.include? @custom_question.author)
    end

    def edit
    end

    def update
        if @custom_question.update(custom_question_params)
            @custom_question.tags.destroy_all

            if !@custom_question.tag_string.nil?
                tag_array = @custom_question.tag_string.gsub("\r\n", "\n").split("\n") 
                tag_array.each do |tag|
                    new_tag = Tag.create(author_id: @custom_question.author.id, content: tag, target: @custom_question)
                    @custom_question.tags << Tag.find(new_tag.id)
                end
            end
            redirect_to @custom_question
        else
            render 'edit'
        end
    end

    def destroy
        @custom_question.destroy 
    end

    private
        def set_custom_question
            @custom_question = CustomQuestion.find(params[:id])
        end

        def custom_question_params
            params.require(:custom_question).permit(:author_id, :content)
        end 

        def check_mine
            if @custom_question.author_id != current_user.id
                redirect_to root_url
            end
        end
    
end
