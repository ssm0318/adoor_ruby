json.call(
  user,
  :id,
  :username
)
json.partial! 'api/v1/users/image', image: user.image
