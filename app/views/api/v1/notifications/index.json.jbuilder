json.data do
  json.array! notifications do |notification|
    json.partial! 'api/v1/notifications/noti', notification: notification
  end
end
