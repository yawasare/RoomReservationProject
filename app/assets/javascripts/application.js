// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require fullcalendar
//= require jquery.ui.all
//= require jquery.turbolinks

$(document).on('ready page:load',function() {
      // page is now ready, initialize the calendar...    
      $('#calendar').fullCalendar({
        
        allDayDefault: false,  
        events: '/meetings.json',  
        editable: true,
        disableResizing :false,
        weekends: false,
        allDaySlot: false,
        minTime:6,  
        maxTime:20,
        slotEventOverlap:false,
        selectable:true,
        selectHelper:true,
        eventTextColor: 'black' , 

        header: {
            left: 'agendaWeek,agendaDay',
            center: 'title'
        },

        select: function(start, end, jsEvent, view) {
            form.display({start_at: new Date(start.getTime()), 
                        end_at:   new Date(end.getTime())} );
        },

        eventDrop: function(event,dayDelta,minuteDelta,allDay,revertFunc) {
            $.ajax({
                data: {day_delta: dayDelta,minute_delta: minuteDelta},
                type: "POST",
                url:  '/meetings/' + event.id + '/move.json',
                error: function (jqXHR,textStatus,errorThrown){
                    console.log("error");        
                    revertFunc();
                    alert(JSON.parse(jqXHR.responseText).errors.base[0]);
                },
                success: function(data){
                    console.log(data);
                }
            });
        },

        eventResize: function(event, dayDelta, minuteDelta, revertFunc){
            $.ajax({
               data: {day_delta: dayDelta,minute_delta: minuteDelta},
               type: "POST",
               url:  '/meetings/' + event.id + '/resize.json',
               error: function (jqXHR,textStatus,errorThrown){
                    console.log("error");        
                    revertFunc();
                    alert(JSON.parse(jqXHR.responseText).errors.base[0]);
                },
                success: function(data){
                    console.log(data);
                }
            });
        },
});    

  $('#calendar_show').fullCalendar({
      allDayDefault: false,  
      events: '/rooms/'+'3'+'.json',  
      editable: true,
      disableResizing :false,
      weekends: false,
      allDaySlot: false,
      minTime:6,  
      maxTime:20,
      slotEventOverlap:false,
      selectable:true,
      selectHelper:true,
      eventTextColor: 'black',
      
        header: {
            left: 'agendaWeek,agendaDay',
            center: 'title'
        },

        select: function(start, end, jsEvent, view) {
            form.display({start_at: new Date(start.getTime()), 
                        end_at:   new Date(end.getTime())} );
        },

        eventDrop: function(event,dayDelta,minuteDelta,allDay,revertFunc) {
            $.ajax({
                data: {day_delta: dayDelta,minute_delta: minuteDelta},
                type: "POST",
                url:  '/meetings/' + event.id + '/move.json',
                error: function (jqXHR,textStatus,errorThrown){
                    console.log("error");        
                    revertFunc();
                    alert(JSON.parse(jqXHR.responseText).errors.base[0]);
                },
                success: function(data){
                    console.log(data);
                }
            });
        },

        eventResize: function(event, dayDelta, minuteDelta, revertFunc){
            $.ajax({
               data: {day_delta: dayDelta,minute_delta: minuteDelta},
               type: "POST",
               url:  '/meetings/' + event.id + '/resize.json',
               error: function (jqXHR,textStatus,errorThrown){
                    console.log("error");        
                    revertFunc();
                    alert(JSON.parse(jqXHR.responseText).errors.base[0]);
                },
                success: function(data){
                    console.log(data);
                }
            });
        }
  });

 form = {
            display: function(options) {
               if (typeof(options) == 'undefined') { options = {} }
                    form.fetch(options) 
            },
            render: function(options){
               $('#meeting_form').trigger('reset');
               var startTime = options['start_at'] || new Date(), endTime = options['end_at'] || new Date(startTime.getTime());
               if(startTime.getTime() == endTime.getTime()) { endTime.setMinutes(startTime.getMinutes() + 30); }
               form.setTime('#meeting_start_at', startTime)
               form.setTime('#meeting_end_at', endTime)
               $('#create_meeting_dialog').dialog({
                    title: 'New Event',
                    modal: true,
                    width: 500,
                    close: function(event, ui) { 
                        $('#create_event_dialog').dialog('destroy')
                    }
               });
            },
            fetch: function(options){
              $.ajax({
                   type: "GET",
                   async: true,
                   url:  '/meetings/new',
                   success: function(){ form.render(options) }
              });
            },
            setTime: function(type, time) {
                 var $year=$(type + '_1i'), $month=$(type + '_2i'), $day=$(type + '_3i'), $hour=$(type + '_4i'), $minute=$(type + '_5i')
                 $year.val(time.getFullYear());
                 $month.prop('selectedIndex', time.getMonth());
                 $day.prop('selectedIndex', time.getDate() - 1);
                 $hour.prop('selectedIndex', time.getHours());
                 $minute.prop('selectedIndex', time.getMinutes());
            }
      }
});     
