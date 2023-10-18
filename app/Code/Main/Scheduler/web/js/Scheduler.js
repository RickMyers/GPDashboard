let Scheduler = (function () {
    let win = false;
    function init() {
        Argus.dashboard.socket.on('userCalendar'+Branding.id+'Update',function (data) {
            console.log('Received Command To Update Calendar');
            Scheduler.calendar.updateAll();
        });
    }
    function summary (events) {
        let dates = {  }
        let d = '';
        for (let i in events) {
            d = this.id+'-'+events[i].date.replace(/-/g,'');
            dates[d] = [];
        }
        for (i in events) {
            d = this.id+'-'+events[i].date.replace(/-/g,'');
            dates[d][dates[d].length] = {
                type: events[i].type,
                location: events[i].location_id_combo,
                start_time: events[i].start_time
            }
        }
        return dates;
    }
    return {
        availability: {
            currentYear: false,
            states: { },
            updateAll: function (yyyy,user_id) {
                let ao = new EasyAjax('/scheduler/availability/list');
                if (user_id) {
                    ao.add('user_id',user_id);
                }
                ao.add('yyyy',yyyy).then(function (response) {
                    let dates = JSON.parse(response);
                    let d,m,y,c,x;
                    for (let i in dates) {
                        d = dates[i].date.split('-');
                        m = d[1]; y=d[0]; 
                        for (let j in EasyCalendar.calendars()) {
                            c = EasyCalendar.get(j);
                            if ((m == c.current.month) && (y == c.current.year)) {
                                x = c.get(d[2])
                                if (x) {
                                    $E(x).style.backgroundColor = '#f99';
                                }
                            }
                            sum = summary.call(c,dates);                            
                            for (i in sum) {
                                if ($E(c.xref[i])) {
                                    $E(c.xref[i]).title = sum[i].length+' Available';
                                }
                            }                    
                        }
                    }
                }).post();
            },
            renderYear: function (yyyy,user_id) {
                user_id     = (user_id) ? user_id : false;
                Scheduler.availability.currentYear  = yyyy = ((yyyy) ? yyyy : (new Date()).getFullYear());
                if (!user_id) {
                    user_id = $('#year_availability_user_id').val() ? $('#year_availability_user_id').val() : false;
                }
                let cal = false;
                for (let i=0; i<12; i++) {
                    cal = EasyCalendar.create('availability-year-month-'+i,i+1,yyyy).render({
                        "controls": false,
                        "callback": Scheduler.availability.update,
                        "onMonthChange": function () {

                        },
                        "classes": {
                            "weekday":      "year-availability-weekday",
                            "weekend":      "year-availability-weekend",
                            "daynames":     "year-availability-daynames",
                            "monthname":    "year-availability-monthname"
                        }            
                    });
                    console.log(cal);
                }
                Scheduler.availability.updateAll(yyyy,user_id);                
            },
            update: function () {
                console.log(this);
                this.state = (this.state) ? this.state : 1;
                switch (++this.state) {
                    case 2 :
                        this.current.cell.style.backgroundColor='green';
                        break;
                    case 3 :
                        this.current.cell.style.backgroundColor='#ff9999';
                        break;
                    default : 
                        this.state = 1;
                        this.resetCell(this.current.cell.id);
                        break;
                } 
                let d = this.current.month+'/'+this.current.day+'/'+this.current.year;
                (new EasyAjax('/scheduler/availability/record')).add('date',d).add('state',this.state).then(function (response) {
                    console.log(response);
                }).post();
            }
        },
        calendar: {
            wins: { },
            currentYear: false,
            update: function () {
                console.log('calendar update');
                (new EasyAjax('/scheduler/events/list')).add('mm',this.current.month).add('yyyy',this.current.year).add('user_id',Branding.id).then(function (response) {
                    let dates = JSON.parse(response);
                    let d,m,y,c,x;
                    for (let i in dates) {
                        d = dates[i].date.split('-');
                        m = d[1]; y=d[0]; 
                        for (let j in EasyCalendar.calendars()) {
                            c = EasyCalendar.get(j);
                            if ((m == c.current.month) && (y == c.current.year)) {
                                x = c.get(d[2])
                                if (x) {
                                    $E(x).style.backgroundColor = '#f99';
                                }
                            }
                        }
                    }
                    let sum = summary.call(c,dates);
                    for (i in sum) {
                        $E(c.xref[i]).title = sum[i].length+' Events';
                    }
                }).post();
            },
            updateAll: function (yyyy,user_id) {
                console.log('calendar update all');
                let ao = new EasyAjax('/scheduler/events/list');
                if (user_id) {
                    ao.add('user_id',user_id);
                }
                ao.add('yyyy',yyyy).then(function (response) {
                    let dates = JSON.parse(response);
                    let d,m,y,c,x;
                    for (let i in dates) {
                        d = dates[i].date.split('-');
                        m = d[1]; y=d[0]; 
                        for (let j in EasyCalendar.calendars()) {
                            c = EasyCalendar.get(j);
                            if ((m == c.current.month) && (y == c.current.year)) {
                                x = c.get(d[2])
                                if (x) {
                                    $E(x).style.backgroundColor = '#f99';
                                }
                            }
                            sum = summary.call(c,dates);                            
                            for (i in sum) {
                                if ($E(c.xref[i])) {
                                    $E(c.xref[i]).title = sum[i].length+' Events';
                                }
                            }                    
                        }
                    }
                }).post();
            },
            day: function (m,d,y) {
                this.current.month = (+this.current.month<10) ? '0'+ +this.current.month : ''+this.current.month;
                this.current.day   = (+this.current.day<10)   ? '0'+ +this.current.day : ''+this.current.day;
                let date           = moment((this.current.year)+''+(this.current.month)+''+(this.current.day));
                let dateString     = date.format('MM/DD/YYYY');
                let win            = Scheduler.calendar.wins[dateString] = (Scheduler.calendar.wins[dateString] ? Scheduler.calendar.wins[dateString] : Desktop.semaphore.checkout(true));
                win._static(true)._title('Events On '+dateString);
                (new EasyAjax('/scheduler/events/today')).add('date',dateString).then(function (response) {
                    win._open(response);
                }).get();
            },
            renderYear: function (yyyy,user_id) {
                user_id     = (user_id) ? user_id : false;
                Scheduler.calendar.currentYear  = yyyy = ((yyyy) ? yyyy : (new Date()).getFullYear());
                if (!user_id) {
                    user_id = $('#year_calendar_user_id').val() ? $('#year_calendar_user_id').val() : false;
                }
                for (let i=0; i<12; i++) {
                    EasyCalendar.create('scheduler-year-month-'+i,i+1,yyyy).render({
                        "controls": false,
                        "callback": Scheduler.events.open,
                        "onMonthChange": function () {
                            Scheduler.calendar.update.apply(this);
                        },
                        "classes": {
                            "weekday":      "year-scheduler-weekday",
                            "weekend":      "year-scheduler-weekend",
                            "daynames":     "year-scheduler-daynames",
                            "monthname":    "year-scheduler-monthname"
                        }            
                    });
                }
                Scheduler.calendar.updateAll(yyyy,user_id);                
            }
        },
        init: init,
        create: {
            event: function () {
                if (($('#scheduler_event_start_date').val()) && ($('#scheduler_event_start_time').val()) && ($('#scheduler_event_end_date').val()) && ($('#scheduler_event_end_time').val())) {
                    let resource = $('#scheduler_event_type').val().split('|');
                    let ev = $('#scheduler_event_type option:selected').text();
                    if (resource[0] && confirm('Would you like to create a '+ev+' Event beginning on '+$('#scheduler_event_start_date').val()+' at '+$('#scheduler_event_start_time').val()+' and running through to '+$('#scheduler_event_end_date').val()+' at '+$('#scheduler_event_end_time').val()+'?')) {
                        $('#scheduler_event_resource').val(resource[1]);
                        $('#scheduler_event_type_id').val(resource[0]);
                        $( "#event_end_calendar" ).datetimepicker( "destroy");
                        $( "#event_start_calendar" ).datetimepicker( "destroy");
                        (new EasyAjax('/scheduler/event/create')).packageForm('scheduler-event-form').then(function (response) {
                            $('#new-event-tab').html(response);
                        }).post();
                    }
                }
            }
        },
        events: {
            wins: { },
            edit: function (event_id) {
                let win = Scheduler.events.wins[event_id] = (Scheduler.events.wins[event_id]) ? Scheduler.events.wins[event_id] : Desktop.semaphore.checkout(true);
                win._scroll(true)._title('Event Review')._open('<i style="color: #333">Fetching Event Data...</i>').dock('R');
                (new EasyAjax('/scheduler/event/edit')).add('id',event_id).then(function (response) {
                    win.set(response);
                }).post();
            },
            month: function () {
                (new EasyAjax('/scheduler/events/month')).then(function (response) {
                    $('#container').html(response);
                }).get();
            },
            planner: {
                fetch: function (mm,dd,yyyy) {
                    
                }
            },
            queue: function () {
             //   alert('Events Queue');
            },
            year: function () {
                (new EasyAjax('/scheduler/events/year')).then(function (response) {
                    $('#container').html(response);
                }).get();                
            },
            init: function () {
                
            },
            open: function (dd,mm,yyyy) {
                win = (win) ? win : Desktop.semaphore.checkout(true);
                win._static(true)._title('Event Scheduling')._scroll(true)._open('<i style="color: #333">Retrieving Event List...</i>').dock('L');
                let ao = new EasyAjax('/scheduler/events/open');
                if ($('#year_calendar_user_id').val()) {
                    ao.add('user_id',$('#year_calendar_user_id').val());
                }
                ao.add('mm',this.current.month).add('dd',this.current.day).add('yyyy',this.current.year).then(function (response) {
                    win.set(response);
                }).post();
            },
            create: function () {
                
            }
        }
    }
})();


