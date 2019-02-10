class StatsMailer < ApplicationMailer
    default from: "adoor.team@gmail.com"

    def send_stats
        attachments["daily_general_stats.csv"] = File.read("lib/user_stats/daily_general_stats.csv")
        attachments["weekly_general_stats.csv"] = File.read("lib/user_stats/weekly_general_stats.csv")
        attachments["monthly_general_stats.csv"] = File.read("lib/user_stats/monthly_general_stats.csv")
        attachments["total_user_stats.csv"] = File.read("lib/user_stats/total_user_stats.csv")
        attachments["recent_user_stats.csv"] = File.read("lib/user_stats/recent_user_stats.csv")
        mail(to: "adoor.team@gmail.com", subject: "#{Date.today().strftime("%b. %d, %Y")} 유저 통계입니다.")
        mail(to: "sjlee739@gmail.com", subject: "#{Date.today().strftime("%b. %d, %Y")} 유저 통계입니다.")
        mail(to: "gjinsun96@gmail.com", subject: "#{Date.today().strftime("%b. %d, %Y")} 유저 통계입니다.")
        mail(to: "njs03332@gmail.com", subject: "#{Date.today().strftime("%b. %d, %Y")} 유저 통계입니다.")
        mail(to: "kleenex0318@gmail.com", subject: "#{Date.today().strftime("%b. %d, %Y")} 유저 통계입니다.")
    end
end
