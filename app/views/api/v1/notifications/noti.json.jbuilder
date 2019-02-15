json.data do
  json.notifcation do
    json.partial! 'api/v1/notifications/noti', notification: notification
  end
end
