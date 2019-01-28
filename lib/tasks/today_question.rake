namespace :today_question do
  desc "Rake task to update new daily questions"
  task update: :environment do
    puts "#{Time.now} Updating daily questions..."

    list = Question.where(selected_date: nil)
    numbers = (0..(list.count-1)).to_a.sample 5

    numbers.each do |number|
      question = list[number]
      question.selected_date = Date.today
      question.save
    end

    puts "#{Time.now} - Success!"
  end
end
