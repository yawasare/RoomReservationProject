require 'icalendar'

class MeetingsController < ApplicationController
  
  before_action :set_meeting, only: [:show,:edit,:update,:destroy,:move,:resize]  
    
  respond_to :html, :xml, :json
  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.all
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end
 
  # GET /meetings/1/edit
  def edit
  end
 
  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = Meeting.new(meeting_params)
    
    respond_to do |format|
      if @meeting.save
        @room = Room.find(@meeting.room_id) 
        @meeting.color = Meeting::COLORS[@meeting.room_id % 10]
        @meeting.save
        format.html { redirect_to '/', notice: 'Meeting was successfully created.' }
        format.json { render :show, status: :created,location:'/'}
      else
        format.html { redirect_to '/'}
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    respond_to do |format|
      @room  = Room.find(@meeting.room_id)   
      if @meeting.update(meeting_params)    
        @meeting.color = Meeting::COLORS[params[:room_id] % 10]
        @meeting.save
        format.html { redirect_to @room, notice: 'Meeting was successfully updated.' }
        format.json { render :show, status: :ok, location: @room}
      else
        format.html { render :edit }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @room  = Room.find(@meeting.room_id) 
    @meeting.destroy
    respond_to do |format|
      format.html { redirect_to @room, notice: 'Meeting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def move 
    if @meeting
        @meeting.start_at= make_time(@meeting.start_at)
        @meeting.end_at  = make_time(@meeting.end_at)
        @meeting.save
        respond_with(@meeting)
    end
  end

  def resize
    if @meeting
        @meeting.end_at  = make_time(@meeting.end_at)
        @meeting.save
        respond_with(@meeting)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_params
      params.require(:meeting).permit(:notes, :start_at, :end_at,:room_id)
    end

    def make_time(event_time)
      time = params[:day_delta].to_i.days.from_now(event_time)
      time = params[:minute_delta].to_i.minutes.from_now(time)
      return time
    end
end
