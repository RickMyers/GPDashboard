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
        font-family: sans-serif; font-size: 2.4em; letter-spacing: 3px
    }
</style>
<hr style='opacity: .4' />
<div onclick="Argus.scheduler.year()" style='position: relative; top: -6px; cursor: pointer; width: 120px; height: 40px; background-color: rgba(202,202,202,.3); font-size: 1.6em; font-family: sans-serif; padding: 5px; letter-spacing: 3px; text-align: center; float: right'>YEAR</div>
<span style='font-size: 1.2em'>SCHEDULER</span>
<hr style='opacity: .4' />
<div id='argus-scheduler-month-calendar'>

</div>
<script type='text/javascript'>
    var now = new Date();
    var y = new DynamicCalendar('argus-scheduler-month-calendar');
    y.setWeekday('month-scheduler-weekday');
    y.setWeekend('month-scheduler-weekend');
    y.setDayNames('month-scheduler-daynames');
    y.setMonthName('month-scheduler-monthname')
    y.build();
    y.set(now.getMonth(),now.getFullYear());
    var f = function (mm,dd,yyy) {
        Argus.scheduler.planner.fetch(mm,dd,yyy,'MONTH');
    }
    y.setDayHandler(f);
</script>