json.data do
  json.partial! 'api/v1/users/user', user: @user
  json.array! @drawers do |drawer|
    json.partial! 'api/v1/drawers/drawer', drawer: drawer
  end
end
