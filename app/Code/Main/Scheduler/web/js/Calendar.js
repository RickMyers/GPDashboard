/*                                                                                                                 
 _|_|_|_|                                  _|_|_|            _|                            _|                      
 _|          _|_|_|    _|_|_|  _|    _|  _|          _|_|_|  _|    _|_|    _|_|_|      _|_|_|    _|_|_|  _|  _|_|  
 _|_|_|    _|    _|  _|_|      _|    _|  _|        _|    _|  _|  _|_|_|_|  _|    _|  _|    _|  _|    _|  _|_|      
 _|        _|    _|      _|_|  _|    _|  _|        _|    _|  _|  _|        _|    _|  _|    _|  _|    _|  _|        
 _|_|_|_|    _|_|_|  _|_|_|      _|_|_|    _|_|_|    _|_|_|  _|    _|_|_|  _|    _|    _|_|_|    _|_|_|  _|        
                                     _|                                                                            
                                 _|_|    

By Rick Myers
*/

let EasyCalendar = (function () {
    'use strict';
    let Calendars       = { };
    let months          = "January,February,March,April,May,June,July,August,September,October,November,December".split(",");
    let SECOND          = 1000;
    let MINUTE          = 60 * SECOND;
    let HOUR            = 60 * MINUTE;
    let DAY             = 24 * HOUR;
    let originalColor   = { };
    let current = {
        day:    false,
        month:  false,
        year:   false,
        cell:   false,
        monthname: false        
    };
    let previous = {
        day:    false,
        month:  false,
        year:   false,
        cell:   false,
        monthname: false        
    }
    let arrows  = {
            "left": "&lt;&lt;",
            "right": "&gt;&gt;"
    };
    let classes = {
            "weekday":      "",
            "weekend":      "",
            "days":         "",
            "daynames":     "",
            "monthname":    "",
            "layout":       ""
    };
    let options = {
        "controls": true, 
        "arrows":   Object.create(arrows),
        "classes":  Object.create(classes),
        callback: function () {
            alert(this.current.day+","+this.current.month+","+this.current.year);
        },
        onMonthChange: function () {
            console.log('m');
        },
        onYearChange: function () {
            console.log('y');
        }
    }
    let Calendar = {
        id:     '',
        node:   null,
        firstRender: true,
        days: [],
        args: {},
        add: function (arg,value) {
            this.args[arg] = value;
            return this;
        },
        init:   function () {
            let styles = []; let cell = '';
            for (let i=0; i<41; i++) {
                cell = $E(this.id+"-c"+i);
                styles = window.getComputedStyle(cell);
                originalColor[cell.id] = styles.getPropertyValue('background-color');
            }
            return this;
        },
        resetCell: function (cell_id) {
            if (this.originalColor[cell_id]) {
                $E(cell_id).style.backgroundColor = this.originalColor[cell_id];
                this.states[cell_id] = 1;
            } 
        },
        process: function (defaults,options) {
            for (let i in options) {
                if (typeof(defaults[i]) !== 'undefined') {
                    if ((typeof(options[i]) === 'object')) {
                        this.process(defaults[i],options[i]);
                    } else {
                        defaults[i] = options[i];
                    }
                }
            }
        },
        defaults: function (opts) {
            for (let i in opts) {
                if (!opts[i] && (opts[i] !== false)) {
                   opts[i] = i;
                }
            }
        },
        draw: function () {
            let calendar = this;
            let HTML = '<table style="margin-left: auto; margin-right: auto" class="'+ calendar.options.classes.layout +'" id="'+ calendar.id +'-calTB" cellspacing="1">'+
                        '<tr><td colspan="5" id="'+ calendar.id +'-monthName" class="'+ calendar.options.classes.monthname +'"></td>'+
                        '<td colspan="2" class="'+ calendar.options.classes.monthname +'" align="right">';
            if (calendar.options.controls) {
                HTML += '<img style="height: 16px; cursor: pointer" src="/images/scheduler/left-arrow-white.png" onclick="(EasyCalendar.get(\''+calendar.id+'\')).back(\''+ calendar.id +'\'); return false">&nbsp;<img style="height: 16px; cursor: pointer" src="/images/scheduler/right-arrow-white.png" href="#" onclick="(EasyCalendar.get(\''+calendar.id+'\')).next(\''+ calendar.id +'\'); return false">';
            }
            HTML += '</td></tr><tr><td class="'+calendar.options.classes.daynames+'">SUN</td><td class="'+calendar.options.classes.daynames+'">MON</td><td class="'+calendar.options.classes.daynames+'">TUE</td><td class="'+calendar.options.classes.daynames+'">WED</td><td class="'+calendar.options.classes.daynames+'">THU</td><td class="'+calendar.options.classes.daynames+'">FRI</td><td class="'+calendar.options.classes.daynames+'">SAT</td></tr>'+
                    '<tr id="'+ calendar.id +'-week0" weeknum="0"><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c0"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c1"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c2"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c3"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c4"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c5"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c6"> </td></tr>'+
                    '<tr id="'+ calendar.id +'-week1" weeknum="1"><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c7"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c8"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c9"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c10"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c11"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c12"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c13"> </td></tr>'+
                    '<tr id="'+ calendar.id +'-week2" weeknum="2"><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c14"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c15"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c16"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c17"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c18"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c19"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c20"> </td></tr>'+
                    '<tr id="'+ calendar.id +'-week3" weeknum="3" ><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c21"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c22"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c23"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c24"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c25"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c26"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c27"> </td></tr>'+
                    '<tr id="'+ calendar.id +'-week4" weeknum="4"><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c28"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c29"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c30"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c31"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c32"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c33"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c34"> </td></tr>'+
                    '<tr id="'+ calendar.id +'-week5" weeknum="5"><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c35"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c36"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c37"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c38"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c39"> </td><td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekday +'" id="'+ calendar.id +'-c40"> </td>'+
                    '<td onclick="(EasyCalendar.get(\''+calendar.id+'\')).handler(event)" class="easy-calendar-cell '+ calendar.options.classes.weekend +'" id="'+ calendar.id +'-c41"> </td></tr>'+
                    '</table>';
            $(calendar.node).html(HTML);     
            if (this.firstRender) {
                this.init();
                this.firstRender = false;
            }
        },
        render: function (options)	{
            let calendar = this;
            calendar.current.month = !calendar.current.month ? calendar.month : calendar.current.month;
            calendar.current.year  = !calendar.current.year  ? calendar.year : calendar.current.year;
            $(calendar.node).html(' ');
            if (options) {
                calendar.process(calendar.options,options);
            }
            calendar.defaults(calendar.options.classes);
            calendar.draw();
            return calendar.set(calendar.current.month, calendar.current.year);
        },
        reset: function () {
            //this.draw();
            this.set(this.current.month, this.current.year);
        },
        set: function (mm,yyyy){
            this.current.month  = mm;
            this.current.year   = yyyy;
            this.xref           = { };
            this.original       = { };
            this.days           = [];
            this.thisMonth      = +mm-1;
            let dayCounter      = 1;            
            let cal             = new Date(months[this.thisMonth]+" 1, "+yyyy+" 12:00:00");
            let startDay        = cal.getDay();
            this.thisYear       = yyyy;
            this.monthname      = months[parseInt(this.thisMonth)];  
            $E(this.id+"-monthName").innerHTML = this.monthname+" "+yyyy;
            do {
                let cd = $E(this.id+"-c"+(startDay+(dayCounter-1)));
                this.days[this.days.length] = yyyy+""+(((mm)<10) ? "0" + +(mm) : (mm))+""+ (dayCounter<10 ? '0'+dayCounter : dayCounter);
                let isoDay = this.id+'-'+this.days[this.days.length-1];
                if (isoDay) {
                    this.xref[isoDay] = this.id+"-c"+(startDay+(dayCounter-1));  
                }
                $(cd).html(dayCounter++).attr('title','');
                cal.setTime(cal.getTime()+DAY);
            } while (this.thisMonth == cal.getMonth())
            return this;
        },
        clear: function ()	{
            for (let i=0; i<41; i++) {
                let cell = $E(this.id+"-c"+i);
                cell.style.backgroundColor = this.originalColor[cell.id];
                cell.innerHTML = ''; cell.title = '';
            }
            return this;
        },
        getYear: function () {
            return this.thisYear;
        },
        get: function (day) {
            let yyyy    = this.current.year;
            let mm      = this.current.month;
            let today   = this.id+'-'+yyyy + "" + (((mm)<10) ? "0"+(mm) : (mm)) + "" +day;
            return (this.xref[today]) ? this.xref[today] : false;
        },
        next:  function (id) {
            let calendar = EasyCalendar.get(id);
            calendar.clear();
            calendar.current.month++;
            let yearChange = (calendar.current.month > 12);
            if (yearChange) {
                calendar.current.year++;
                calendar.current.month = 1;
                calendar.current.monthname = months[calendar.current.month-1];
            }
            calendar.render(calendar.options);
            calendar.options.onMonthChange.apply(calendar);
            if (yearChange) {
                calendar.options.onYearChange.apply(calendar);            
            }            
            return this;
        },
        back: function (id) {
            let calendar = EasyCalendar.get(id);
            calendar.clear();
            calendar.current.month--;
            let yearChange = (calendar.current.month < 1);
            if (yearChange) {
                calendar.current.year--;
                calendar.current.month = 12;
                calendar.current.monthname = months[calendar.current.month-1];
            }
            calendar.render(calendar.options);
            calendar.options.onMonthChange.apply(calendar);
            if (yearChange) {
                calendar.options.onYearChange.apply(calendar);            
            }
            return this;
        },
        handler: function (evt) {
            evt = (evt) ? evt : ((window.event) ? event : null);
            for (var i in this.current) {
                this.previous[i] = this.current[i];
            }
            this.current.cell = evt.target;
            this.current.day  = $(evt.target).text();
            this.options.callback.apply(this);
            return this;
        }        
    };    
    return {
        create: function (id,MM,YYYY) {
            return Calendars[id] = Object.create(Calendar,{"id": { "value": id }, "month": { "value": MM }, "year": { "value": YYYY }, 'originalColor': { "value": originalColor }, 'node': { "value": $E(id)}, 'current': { "value": Object.create(current) }, 'previous': { "value": Object.create(previous) }, 'options': { "value": Object.create(options) } } );
        },
        get: function (id) {
            return (Calendars[id]) ? Calendars[id] : false;
        },
        calendars:  function () {
            for (var i in Calendars) {
                if (!$E(i)) {
                    delete Calendars[i];
                }
            }
            return Calendars; 
        },        
    }
})();
