require 'csv'

namespace :user_stats do
    desc "Rake task to update user stats CSV files"
    task update: :environment do
        puts "#{Time.now} Updating files..."

        ##############################################################################

        puts "updating daily stats.............."

        row_names = ["User", "Answer", "Post", "Custom_Question", "Channel", "Comment", "Reply", 
            "Like", "Drawer", "tags", "Friendship", "Assignment", "Query", "User_Query"]
        users, answers, posts, custom_questions, channels, comments, replies, 
            likes, drawers, tags, friendships, assignments, queries, user_queries = v = Array.new(row_names.length) { [] }
        for i in 0..13 # label first column 
            v[i][0] = row_names[i]
        end           

        daily_header = ["",]  # column header (dates) for tracking weekly stats (first col is empty)
        for x in 1..30
            bd = (DateTime.now - x.days).beginning_of_day # 보고 당일은 제외
            ed = (DateTime.now - x.days).end_of_day
            daily_header.push(ed.strftime("%b_%d")) 
            users.push(User.where(created_at: bd .. ed).length)
            answers.push(Answer.where(created_at: bd .. ed).length) 
            posts.push(Post.where(created_at: bd .. ed).length)
            custom_questions.push(CustomQuestion.where(created_at: bd .. ed).length)
            channels.push(Channel.where(created_at: bd .. ed).length)
            comments.push(Comment.where(created_at: bd .. ed).length)
            replies.push(Reply.where(created_at: bd .. ed).length)
            likes.push(Like.where(created_at: bd .. ed).length)
            drawers.push(Drawer.where(created_at: bd .. ed).length)
            tags.push(Tag.where(created_at: bd .. ed).length)
            friendships.push(Friendship.where(created_at: bd .. ed).length)
            assignments.push(Assignment.where(created_at: bd .. ed).length)
            queries.push(Query.where(created_at: bd .. ed).length)
            user_queries.push(UserQuery.where(created_at: bd .. ed).length)
        end

        # 각 기능의 일별 사용도가 담긴 CSV
        CSV.open("lib/user_stats/daily_general_stats.csv", "wb") do |csv|
            csv << daily_header
            csv << users
            csv << answers
            csv << posts
            csv << custom_questions
            csv << channels
            csv << comments
            csv << replies
            csv << likes
            csv << drawers
            csv << tags
            csv << friendships
            csv << assignments
            csv << queries
            csv << user_queries
        end

        ##############################################################################

        puts "updating weekly stats.............."

        row_names = ["User", "Answer", "Post", "Custom_Question", "Channel", "Comment", "Reply", 
            "Like", "Drawer", "tags", "Friendship", "Assignment", "Query", "User_Query"]
        users, answers, posts, custom_questions, channels, comments, replies, 
            likes, drawers, tags, friendships, assignments, queries, user_queries = v = Array.new(row_names.length) { [] }
        for i in 0..13 # label first column 
            v[i][0] = row_names[i]
        end 

        weekly_header = ["",]   # column header (dates) for tracking weekly stats (first col is empty)
        for x in 1..12 # 12 weeks
            bw = (DateTime.now - x.weeks).beginning_of_week # 일요일이 되기 전까지는 주별 데이터 업데이트하지 않음
            ew = (DateTime.now - x.weeks).end_of_week 
            weekly_header.push(ew.strftime("~%b_%d"))
            users.push(User.where(created_at: bw .. ew).length)
            answers.push(Answer.where(created_at: bw .. ew).length) 
            posts.push(Post.where(created_at: bw .. ew).length)
            custom_questions.push(CustomQuestion.where(created_at: bw .. ew).length)
            channels.push(Channel.where(created_at: bw .. ew).length)
            comments.push(Comment.where(created_at: bw .. ew).length)
            replies.push(Reply.where(created_at: bw .. ew).length)
            likes.push(Like.where(created_at: bw .. ew).length)
            drawers.push(Drawer.where(created_at: bw .. ew).length)
            tags.push(Tag.where(created_at: bw .. ew).length)
            friendships.push(Friendship.where(created_at: bw .. ew).length)
            assignments.push(Assignment.where(created_at: bw .. ew).length)
            queries.push(Query.where(created_at: bw .. ew).length)
            user_queries.push(UserQuery.where(created_at: bw .. ew).length) 
        end

        # 각 기능의 주별 사용도가 담긴 CSV
        CSV.open("lib/user_stats/weekly_general_stats.csv", "wb") do |csv|
            csv << weekly_header
            csv << users
            csv << answers
            csv << posts
            csv << custom_questions
            csv << channels
            csv << comments
            csv << replies
            csv << likes
            csv << drawers
            csv << tags
            csv << friendships
            csv << assignments
            csv << queries
            csv << user_queries
        end

        ##############################################################################

        puts "updating monthly stats.............."

        row_names = ["User", "Answer", "Post", "Custom_Question", "Channel", "Comment", "Reply", 
            "Like", "Drawer", "tags", "Friendship", "Assignment", "Query", "User_Query"]
        users, answers, posts, custom_questions, channels, comments, replies, 
            likes, drawers, tags, friendships, assignments, queries, user_queries = v = Array.new(row_names.length) { [] }
        for i in 0..13 # label first column 
            v[i][0] = row_names[i]
        end

        monthly_header = ["",]   # column header (dates) for tracking monthly stats (first col is empty)
        for x in 1..12 # 12 months
            bm = (DateTime.now - x.months).beginning_of_month # 새로운 달이 시작되기 전까지는 월별 데이터 업데이트하지 않음
            em = (DateTime.now - x.months).end_of_month
            monthly_header.push(em.strftime("%b_%Y")) # 오늘 데이터는 제외 (21시에 업데이트가 되므로)
            users.push(User.where(created_at: bm .. em).length)
            answers.push(Answer.where(created_at: bm .. em).length) 
            posts.push(Post.where(created_at: bm .. em).length)
            custom_questions.push(CustomQuestion.where(created_at: bm .. em).length)
            channels.push(Channel.where(created_at: bm .. em).length)
            comments.push(Comment.where(created_at: bm .. em).length)
            replies.push(Reply.where(created_at: bm .. em).length)
            likes.push(Like.where(created_at: bm .. em).length)
            drawers.push(Drawer.where(created_at: bm .. em).length)
            tags.push(Tag.where(created_at: bm .. em).length)
            friendships.push(Friendship.where(created_at: bm .. em).length)
            assignments.push(Assignment.where(created_at: bm .. em).length)
            queries.push(Query.where(created_at: bm .. em).length)
            user_queries.push(UserQuery.where(created_at: bm .. em).length) 
        end  
         
        # 각 기능의 월별 사용도가 담긴 CSV
        CSV.open("lib/user_stats/monthly_general_stats.csv", "wb") do |csv|
            csv << monthly_header
            csv << users
            csv << answers
            csv << posts
            csv << custom_questions
            csv << channels
            csv << comments
            csv << replies
            csv << likes
            csv << drawers
            csv << tags
            csv << friendships
            csv << assignments
            csv << queries
            csv << user_queries
        end

        ##############################################################################

        puts "updating total user stats.............."

        CSV.open("lib/user_stats/total_user_stats.csv", "wb") do |csv|
            csv << ["ID", "Username", "Visit", "Answer", "Post", "Custom_Question", "Channel", "Comment", "Reply", 
                "Like", "Drawer", "Tag", "Friendship", "Assignment", "Query", "User_Query"] # header
            # 모든 유저의 통계
            csv << ["N/A", "All_Users", Ahoy::Visit.all.length, Answer.all.length, Post.all.length, CustomQuestion.all.length, Channel.all.length, Comment.all.length, Reply.all.length, 
                Like.all.length, Drawer.all.length, Tag.all.length, Friendship.all.length, Assignment.all.length, Query.all.length, UserQuery.all.length]

            # 각 유저의 통계
            User.all.each do |user|
                csv << [user.id, user.username, user.visits.length, user.answers.length, user.posts.length, user.custom_questions.length, user.channels.length, user.comments.length, 
                    Reply.where(author_id: user.id).length, user.likes.length, user.drawers.length, user.tags.length, user.friendships.length, 
                    Assignment.where(assigner_id: user.id).length, user.queries.length, user.user_queries.length]
            end
        end

        ##############################################################################

        puts "updating recent user stats.............."

        # 최근 3일 간의 통계 (보고 당일 제외)
        CSV.open("lib/user_stats/recent_user_stats.csv", "wb") do |csv|
            csv << ["ID", "Username", "Visit", "Answer", "Post", "Custom_Question", "Channel", "Comment", "Reply", 
                "Like", "Drawer", "Tag", "Friendship", "Assignment", "Query", "User_Query"]
            bd = Date.today() - 3.days
            ed = Date.today()

            csv << ["N/A", "All_Users", Ahoy::Visit.where(started_at: bd .. ed).length, Answer.where(created_at: bd .. ed).length, Post.where(created_at: bd .. ed).length, 
                CustomQuestion.where(created_at: bd .. ed).length, Channel.where(created_at: bd .. ed).length, Comment.where(created_at: bd .. ed).length, 
                Reply.where(created_at: bd .. ed).length, Like.where(created_at: bd .. ed).length, Drawer.where(created_at: bd .. ed).length, 
                Tag.where(created_at: bd .. ed).length, Friendship.where(created_at: bd .. ed).length, Assignment.where(created_at: bd .. ed).length, 
                Query.where(created_at: bd .. ed).length, UserQuery.where(created_at: bd .. ed).length]
            User.all.each do |user|
                csv << [user.id, user.username, user.visits.where(started_at: bd .. ed).length, user.answers.where(created_at: bd .. ed).length, 
                    user.custom_questions.where(created_at: bd .. ed).length, user.channels.where(created_at: bd .. ed).length, 
                    user.comments.where(created_at: bd .. ed).length, Reply.where(author_id: user.id, created_at: bd .. ed).length, 
                    user.likes.where(created_at: bd .. ed).length, user.drawers.where(created_at: bd .. ed).length, user.tags.where(created_at: bd .. ed).length, 
                    user.friendships.where(created_at: bd .. ed).length, Assignment.where(assigner_id: user.id, created_at: bd .. ed).length, 
                    user.queries.where(created_at: bd .. ed).length, user.user_queries.where(created_at: bd .. ed).length]
            end
        end

        StatsMailer.send_stats.deliver_now
        puts "#{Time.now} - Success!"
    end
  end
   