json.data do
  json.user do
    json.call(
      @user,
      :id,
      :username,
      :email,
      # :authentication_token, # use jwt instead
      :confirmed_at # check if user email has been confirmed
    )
    # json.id @user.id
    # json.email @user.email
  end
end
 