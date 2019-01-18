require 'csv'

namespace :user_stats do
    desc "Rake task to update user stats CSV files"
    task update: :environment do
        puts "#{Time.now} Updating files..."

        row_names = ["Answers", "Assignments", "Comments", "Drawers", "Friendships", "Likes", "Posts", "Queries", "Replies", "Tags", "Users", "User_Queries"]
        # 모델 이름이랑 헷갈릴까봐 array 이름 첫 글자는 소문자로 한 것이니 바꾸지 말 것!
        answers, assignments, comments, drawers, friendships, likes, posts, queries, replies, tags, users, user_queries = v = Array.new(row_names.length) { [] }
        for i in 0..11
            v[i][0] = row_names[i] # label first column 
        end           

        ###########################################################################################################

        daily_header = ["",]   # column header for tracking daily stats (first col is empty)
        for x in 1..30
            bd = (DateTime.now - x.days).beginning_of_day
            ed = (DateTime.now - x.days).end_of_day
            daily_header.push(ed.strftime("%b %d")) # 오늘 데이터는 제외 (21시에 업데이트가 되므로)
            answers.push(Answer.where(created_at: bd .. ed).length) 
            assignments.push(Assignment.where(created_at: bd .. ed).length)
            comments.push(Comment.where(created_at: bd .. ed).length)
            drawers.push(Drawer.where(created_at: bd .. ed).length)
            friendships.push(Friendship.where(created_at: bd .. ed).length)
            likes.push(Like.where(created_at: bd .. ed).length)
            posts.push(Post.where(created_at: bd .. ed).length)
            queries.push(Query.where(created_at: bd .. ed).length)
            replies.push(Reply.where(created_at: bd .. ed).length)
            tags.push(Tag.where(created_at: bd .. ed).length)
            users.push(Drawer.where(created_at: bd .. ed).length)
            user_queries.push(Drawer.where(created_at: bd .. ed).length)
        end

        # 각 기능의 일별 사용도가 담긴 CSV
        CSV.open("lib/user_stats/daily_general_stats.csv", "wb") do |csv|
            csv << daily_header
            csv << answers
            csv << assignments
            csv << comments
            csv << drawers
            csv << friendships
            csv << likes
            csv << posts
            csv << queries
            csv << replies
            csv << tags
            csv << users
            csv << user_queries
        end

        ###########################################################################################################

        weekly_header = ["",]   # column header for tracking weekly stats (first col is empty)
        for x in 1..12 # 12 weeks
            bw = (DateTime.now - x.weeks).beginning_of_week # 일요일이 되기 전까지는 주별 데이터 업데이트하지 않음
            ew = (DateTime.now - x.weeks).end_of_week 
            weekly_header.push(ew.strftime("~%b %d"))
            answers.push(Answer.where(created_at: bw .. ew).length)
            assignments.push(Assignment.where(created_at: bw .. ew).length)
            comments.push(Comment.where(created_at: bw .. ew).length)
            drawers.push(Drawer.where(created_at: bw .. ew).length)
            friendships.push(Friendship.where(created_at: bw .. ew).length)
            likes.push(Like.where(created_at: bw .. ew).length)
            posts.push(Post.where(created_at: bw .. ew).length)
            queries.push(Query.where(created_at: bw .. ew).length)
            replies.push(Reply.where(created_at: bw .. ew).length)
            tags.push(Tag.where(created_at: bw .. ew).length)
            users.push(Drawer.where(created_at: bw .. ew).length)
            user_queries.push(Drawer.where(created_at: bw .. ew).length)
        end

        # 각 기능의 주별 사용도가 담긴 CSV
        CSV.open("lib/user_stats/weekly_general_stats.csv", "wb") do |csv|
            csv << weekly_header
            csv << answers
            csv << assignments
            csv << comments
            csv << drawers
            csv << friendships
            csv << likes
            csv << posts
            csv << queries
            csv << replies
            csv << tags
            csv << users
            csv << user_queries
        end

        ###########################################################################################################

        monthly_header = ["",]   # column header for tracking monthly stats (first col is empty)
        for x in 1..12 # 12 months
            bm = (DateTime.now - x.months).beginning_of_month # 새로운 달이 시작되기 전까지는 월별 데이터 업데이트하지 않음
            em = (DateTime.now - x.months).end_of_month
            monthly_header.push(em.strftime("%b %Y")) # 오늘 데이터는 제외 (21시에 업데이트가 되므로)
            answers.push(Answer.where(created_at: bm .. em).length)
            assignments.push(Assignment.where(created_at: bm .. em).length)
            comments.push(Comment.where(created_at: bm .. em).length)
            drawers.push(Drawer.where(created_at: bm .. em).length)
            friendships.push(Friendship.where(created_at: bm .. em).length)
            likes.push(Like.where(created_at: bm .. em).length)
            posts.push(Post.where(created_at: bm .. em).length)
            queries.push(Query.where(created_at: bm .. em).length)
            replies.push(Reply.where(created_at: bm .. em).length)
            tags.push(Tag.where(created_at: bm .. em).length)
            users.push(Drawer.where(created_at: bm .. em).length)
            user_queries.push(Drawer.where(created_at: bm .. em).length)
        end  
         
        # 각 기능의 월별 사용도가 담긴 CSV
        CSV.open("lib/user_stats/monthly_general_stats.csv", "wb") do |csv|
            csv << monthly_header
            csv << answers
            csv << assignments
            csv << comments
            csv << drawers
            csv << friendships
            csv << likes
            csv << posts
            csv << queries
            csv << replies
            csv << tags
            csv << users
            csv << user_queries
        end

        ###########################################################################################################
        
        # questions = Question.where.not(selected_date: nil)

        # v = Array.new(questions.length) { [] }

        # i = 0
        # questions.each do |question|
        #     v[i][0] = question.content # label first column 
        #     i += 1
        # end

        # for x in 1..12 # 12 weeks
        #     bw = (DateTime.now - x.weeks).beginning_of_week # 일요일이 되기 전까지는 주별 데이터 업데이트하지 않음
        #     ew = (DateTime.now - x.weeks).end_of_week 
        #     weekly_header.push(ew.strftime("~%b %d"))
        # end

        # CSV.open("lib/user_stats/question_stats.csv", "wb") do |csv|
        #     questions.each do |question|
        #         csv << weekly_header
        #         csv << [question.answers.length]     
        #     end       
        # end
          
        ###########################################################################################################

        # StatsMailer.send_stats.deliver_now
        puts "#{Time.now} - Success!"
    end
  end
   