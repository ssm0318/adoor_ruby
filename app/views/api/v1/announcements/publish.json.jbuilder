json.data do
  json.announcement do
    json.partial! 'api/v1/annoucements/annoucement', annoucement: announcement
  end
end
