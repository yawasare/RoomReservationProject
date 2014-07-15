if @meeting.errors
    json.errors @meeting.errors.full_messages
end

