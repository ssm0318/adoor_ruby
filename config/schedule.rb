# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# every :day, at: '0am' do
# end

#job_type :rails,    "cd :path && rails :task --silent :output"
job_type :rake, 'cd :path && RAILS_ENV=production bundle exec rake :task --silent :output'
# ENV['RAILS_ENV'] = "production"
 
set :output, 'log/whenever.log'

every :day, at: '0 am' do
# every 1.minutes do
    rake "today_question:update"
end

# every :day, at: '9 pm' do
every 1.minutes do  
    rake "user_stats:update"
end