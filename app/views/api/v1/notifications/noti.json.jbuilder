json.data do
  json.notifcation do
    json.call(
      notification,
      :id,
      :recipient_id,
      :actor_id,
      :read_at,
      :target_id,
      :target_type,
      :origin_id,
      :origin_type,
      :action,
      :invisible
    )
  end
end
