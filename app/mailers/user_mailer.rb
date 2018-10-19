class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  before_action :putsputs
  after_action :putsputs

  def putsputs
    puts "*****************************"
  end

  def send_temporary_password(email)
    random_password = Devise.friendly_token(length=6)
    puts random_password
    puts "----------------------"

    # user_to_change_password = User.where(email: email)
    # user_to_change_password.password = random_password
    # user_to_change_password.password_confirmation = random_password
    # user_to_change_password.save

    mail(to: email, subject: "임시 비밀번호는 #{random_password} 입니다.")
    # puts random_password
  end
end
