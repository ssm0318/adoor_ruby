json.call(
  user,
  :id,
  :username,
  :email,
  :date_of_birth,
  :profile  
)
json.partial! 'api/v1/users/image', image: user.image