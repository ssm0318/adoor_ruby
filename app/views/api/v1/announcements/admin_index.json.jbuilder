json.data do
  json.array! @published_announcements do |announcement|
    json.partial! 'api/v1/annoucements/annoucement', annoucement: announcement
  end
  json.array! @unpublished_announcements do |announcement|
    json.partial! 'api/v1/annoucements/annoucement', annoucement: announcement
  end
end
