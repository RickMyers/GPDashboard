<style type='text/css'>
    .month-scheduler-weekday {
        width: 120px; border: 1px solid rgba(202,202,202,.2); font-size: 2em; height: 130px; font-family: sans-serif; text-align: center
    }
    .month-scheduler-weekend {
        width: 130px; border: 1px solid rgba(202,202,202,.2); font-size: 2em; height: 100px; font-family: sans-serif; text-align: center
    }
    .month-scheduler-daynames {
        font-size: 2.2em; font-family: sans-serif;
    }
    .month-scheduler-monthname {
        font-family: sans-serif; font-size: 2.4em; letter-spacing: 3px; background-color: rgba(202,202,202,.3)
    }
</style>
<hr style='opacity: .4' />
<div onclick="Scheduler.events.year()" style='position: relative; top: -6px; cursor: pointer; width: 120px; height: 40px; background-color: rgba(202,202,202,.3); font-size: 1.6em; font-family: sans-serif; padding: 5px; letter-spacing: 3px; text-align: center; float: right'>YEAR</div>
<span style='font-size: 1.2em'>SCHEDULER</span>
<hr style='opacity: .4' />
<div id='scheduler-month-calendar'>

</div>
<script type='text/javascript'>
    (function () { 
        var f = function () {
            Scheduler.calendar.update.apply(this);
        }
        var now = new Date();
        EasyCalendar.create('scheduler-month-calendar',now.getMonth()+1,now.getFullYear()).render({
            "controls": true,
            "callback": Scheduler.events.open,
            "onMonthChange": f,
            "classes": {
                "weekday": "month-scheduler-weekday",
                "weekend": "month-scheduler-weekend",
                "daynames": "month-scheduler-daynames",
                "monthname": "month-scheduler-monthname"
            }
        });   
        var x = EasyCalendar.get('scheduler-month-calendar');
        x.options.onMonthChange.apply(x);
    })();
</script>