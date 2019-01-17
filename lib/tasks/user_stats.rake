require 'csv'

namespace :user_stats do
    desc "Rake task to update user stats CSV files"
    task update: :environment do
        puts "#{Time.now} Updating files..."

        daily_header = ["",]   # column header for tracking daily stats
        for x in 1..30
            daily_header.push(Date.today() - x)
        end

        weekly_header = ["",]   # column header for tracking weekly stats
        for x in 1..12
            weekly_header.push(x.weeks.ago + 6.days)
        end

        monthly_header = ["",]   # column header for tracking monthly stats
        for x in 1..12
            monthly_header.push(x.months.ago + 1.month - 1.day)
        end

        row_names = ["Answers", "Assignments", "Comments", "Drawers", "Friends", "Likes", "Posts", "Queries", "Replies", "Tags", "Users", "User Queries"]
        # answers, assignments, comments, drawers, friends, likes, posts, queries, replies, tags, users, user_queries = Array.new(10) { [] }
        v = Array.new(10) { [] }
        CSV.open("general_stats.csv", "wb", write_headers: :true, headers: :daily_header) do |csv|
            for i in 1..30
                answers = ["Answer"]
                daily_header[i]
            csv << [Answer.all.length]
            csv << ["row", "of", "CSV", "data"]
            csv << ["another", "row"]
        end
  
        # current_user.tasks.where(due_date: 1.week.ago..Date.today)
        # Answer.where(created_at: 2.days.ago.midnight..2.days.ago.end_of_day)
        
        list = Question.where(author_id: 1, selected_date: nil)
        numbers = (0..(list.count-1)).to_a.sample 5

        numbers.each do |number|
            question = list[number]
            question.selected_date = Date.today
            question.save
        end
  
        puts "#{Time.now} - Success!"
    end
  end
   