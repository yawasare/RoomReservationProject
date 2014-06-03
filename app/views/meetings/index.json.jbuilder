json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :notes, :start, :end
  json.url meeting_url(meeting, format: :json)
end
