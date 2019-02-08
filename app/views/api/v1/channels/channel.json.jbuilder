json.data do
  json.channel do
    json.call(
      channel,
      :id,
      :user_id,
      :name
    )
  end
end
