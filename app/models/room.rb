class Room < ActiveRecord::Base
    has_many :meetings
    validates :name, presence:true
    validates :name, uniqueness: true
end
