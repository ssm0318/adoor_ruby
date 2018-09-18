class UserMailer < ApplicationMailer
  # https://github.com/plataformatec/devise/wiki/How-To:-Automatically-generate-password-for-users-(simpler-registration)
  # def send_temporary_password
  #   random_password = Devise.friendly_token(length=6)
  #   # 입력한 이메일을 가진 유저의 비번을 rrandom_password로 바꿈
  #   User.all.where(email: 받은비번).pass
  def send_temporary_password
    user_email = params[:email]
    random_password = Devise.friendly_token(length=6)

    user_to_change_password = User.where(email: user_email)
    user_to_change_password.password = random_password
    user_to_change_password.password_confirmation = random_password
    user_to_change_password.save
    
    mail(to: user_to_change_password, subject: "임시 비밀번호는 " + random_password + " 입니다.")
  end
end
