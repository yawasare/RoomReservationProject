class Meeting < ActiveRecord::Base
    validates  :start_at, presence:true
    validates  :end_at  , presence:true    
    validates  :notes   , presence:true
    validates  :room_id , presence:true
    validates  :day, :month, :year, presence:true
    validate   :meeting_time_is_free
    validate   :meeting_time_is_valid
    belongs_to :room
    
    def meeting_time_is_free        
          meetings = Meeting.where(:day => day)  
          meetings = meetings.where(:month => month)
          meetings = meetings.where(:year => year)
          meetings = meetings.where(:room_id => room_id)
          for meeting in meetings
              if end_at > meeting.start_at and end_at < meeting.end_at
                  errors.add(:base, "conflicting times")
              end
              if start_at > meeting.start_at and start_at < meeting.end_at
                   errors.add(:base, "conflicting times")
              end
              if meeting.start_at > start_at and meeting.start_at < end_at
                   errors.add(:base, "conflicting times")
              end 
              if meeting.end_at > start_at and meeting.end_at < end_at
                   errors.add(:base,"conflicting times")
              end
          end  
    end
    def meeting_time_is_valid
        if start_at > end_at
            errors.add(:base,"Time is invalid, start time cannot be after meetime")
        end
        if start_at == end_at
            errors.add(:base,"Time is invalid, meeting must last at least 5 minutes")
        end
        if start_at < DateTime.now
            errors.add(:base, "Time is invalid, meeting cannot be scheduled in the past")
        end
    end
end
