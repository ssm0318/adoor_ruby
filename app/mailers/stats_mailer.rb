class StatsMailer < ApplicationMailer
    default from: "adoor.team@gmail.com"

    def send_stats
        attachments["lib/user_stats/daily_general_stats.csv"] = File.read("lib/user_stats/daily_general_stats.csv")
        attachments["lib/user_stats/weekly_general_stats.csv"] = File.read("lib/user_stats/weekly_general_stats.csv")
        attachments["lib/user_stats/monthly_general_stats.csv"] = File.read("lib/user_stats/monthly_general_stats.csv")
        mail(to: "adoor.team@gmail.com", subject: "#{Date.today().strftime("%b. %d, %Y")} 유저 통계입니다.")
    end
end
