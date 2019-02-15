json.data do
  json.announcement do
    json.array! published_announcements do |announcement|
      json.partial! 'api/v1/announcements/announcement', announcement: announcement
    end
  end
end
