class HighlightsController < ApplicationController
    before_action :authenticate_user!
    
    def user_highlights
        @user = User.find(params[:id])
        @highlights = @user.highlights
    end

    def destroy
        highlight = Highlight.find(params[:id])
        highlight.destroy

        redirect_to user_highlights_path(current_user.id)
    end

    # edit은 없어도 되겠지요..? 지우거나 새로 형광펜 하면 되니까
    # def edit
    #     set_highlight
    # end

    # def update
    #     set_highlight
    #     @highlight.update(highlight_params)
    #     redirect_to @highlight
    # end

    private
        # use highlight_params in create
        def highlight_params
            params.require(:highlight).permit(:content, :author_id, :answer_id)
        end
    
end
