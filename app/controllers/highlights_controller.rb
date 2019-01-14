class HighlightsController < ApplicationController
    # before_action :authenticate_user!
    
    # def user_highlights
    #     @user = User.find(params[:id])
    #     @highlights = @user.highlights
    # end

    # def destroy
    #     highlight = Highlight.find(params[:id])
    #     highlight.destroy

    #     redirect_to user_highlights_path(current_user.id)
    # end

    # private
    #     # use highlight_params in create
    #     def highlight_params
    #         params.require(:highlight).permit(:content, :author_id, :target_id)
    #     end
    
end
