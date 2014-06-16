class Meeting < ActiveRecord::Base
    validates  :start_at, presence:true
    validates  :end_at  , presence:true    
    validates  :notes   , presence:true
    validates  :room_id , presence:true
    validate   :meeting_time_is_free
    validate   :meeting_time_is_valid
    belongs_to :room
    
    COLORS = ['#FF8080','#FFFF80','#B2FFB2','#B280B2','#80FFFF','#4D4DFF','#999999','#FF944D','#335C33','#855C33']

    def meeting_time_is_free        
          meetings = meetings.where(:room_id => room_id)
          for meeting in meetings
              if end_at > meeting.start_at and end_at < meeting.end_at
                  if room_id == meeting.room_id and not self == meeting
                    errors.add(:base, "conflicting times")
                  end
              end
              if start_at > meeting.start_at and start_at < meeting.end_at
                  if room_id == meeting.room_id and not self == meeting
                   errors.add(:base, "conflicting times")
                  end 
              end
              if meeting.start_at > start_at and meeting.start_at < end_at
                  if room_id == meeting.room_id and not self == meeting
                   errors.add(:base, "conflicting times")
                  end 
              end 
              if meeting.end_at > start_at and meeting.end_at < end_at
                  if room_id == meeting.room_id and not self == meeting
                   errors.add(:base,"conflicting times")
                  end 
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
        if end_at < DateTime.now
            errors.add(:base, "Time is invalid, meeting cannot be scheduled in the past")
        end
    end
end
