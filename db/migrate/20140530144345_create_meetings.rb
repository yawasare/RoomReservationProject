class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :notes
      t.datetime :start_at
      t.datetime :end_at
      t.integer  :day
      t.integer  :month
      t.integer  :year
      t.belongs_to :room, index:true

      t.timestamps
    end
  end
end
