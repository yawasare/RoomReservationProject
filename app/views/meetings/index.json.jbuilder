json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :color
  json.title meeting.notes
  json.start meeting.start_at
  json.end   meeting.end_at
  json.url meeting_url(meeting, format: :html)
end
