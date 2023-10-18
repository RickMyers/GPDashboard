<style type='text/css'>
    .scheduler-year-month {
        min-width: 300px; width: 32%; margin-right: 1%; float: left; padding: 3px; border: 1px solid rgba(202,202,202,.8); border-radius: 3px; margin-bottom: 5px
    }
    .year-scheduler-weekday {
        width: 50px; border: 1px solid rgba(202,202,202,.2); font-size: 1.1em; height: 30px; font-family: sans-serif; text-align: center
    }
    .year-scheduler-weekend {
        width: 60px; border: 1px solid rgba(202,202,202,.2); font-size: 1.1em; height: 30px; font-family: sans-serif; text-align: center; background-color: rgba(202,202,202,.3)
    }
    .year-scheduler-daynames {
        font-size: .8em; font-family: sans-serif;  background-color: rgba(202,202,202,.3)
    }
    .year-scheduler-monthname {
        font-family: sans-serif; font-size: 1.0em; letter-spacing: 1px; background-color: rgba(202,202,202,.3)
    }
    .year-calendar-userid {
        border: 1px solid #aaf; padding: 2px; background-color: lightcyan; margin-left: 10px
    }
    .year-calendar-popout {
        cursor: pointer; height: 28px; display: inline-block; position: relative; top: -2px
    }
</style>
<hr style='opacity: .4' />
<div onclick="Scheduler.events.month();" style='position: relative; top: -6px; cursor: pointer; width: 120px; height: 40px; background-color: rgba(202,202,202,.3); font-size: 1.6em; font-family: sans-serif; padding: 5px; letter-spacing: 3px; text-align: center; float: right'>MONTH</div>
<span style='font-size: 1.2em'>SCHEDULER</span>
<a href="#" onclick="Scheduler.calendar.renderYear(2019); return false;" class="scheduler-calendar-year"> 2019 </a> | 
<a href="#" onclick="Scheduler.calendar.renderYear(2020); return false;" class="scheduler-calendar-year"> 2020 </a> | 
<a href="#" onclick="Scheduler.calendar.renderYear(2021); return false;" class="scheduler-calendar-year"> 2021 </a> | 
<a href="#" onclick="Scheduler.calendar.renderYear(2022); return false;" class="scheduler-calendar-year"> 2022 </a> | 
<a href="#" onclick="Scheduler.calendar.renderYear(2023); return false;" class="scheduler-calendar-year"> 2023 </a> |
<a href="#" onclick="Scheduler.calendar.renderYear(2024); return false;" class="scheduler-calendar-year"> 2024 </a> |
<div style=" display: inline-block">
    <form name="year_calendar_form" id="year_calendar_form" onsubmit="return false">
    <select style='width: 200px;' name="user_id" id="year_calendar_user_id" class='year-calendar-userid'>
        <option value=""></option>
        {foreach from=$users->usersWithRoleName('O.D.') item=user}
            <option value="{$user.user_id}">{$user.last_name}, {$user.first_name}</option>
        {/foreach}
        {foreach from=$users->usersWithRoleName('PCP Staff') item=user}
            <option value="{$user.user_id}">{$user.last_name}, {$user.first_name}</option>
        {/foreach}                                                        
    </select>
    <input type="hidden" name="calendar_year" id="year_calendar_current_year" value="" />
    </form>
</div>
<img src='/images/scheduler/popout.png'  class='year-calendar-popout' title='Pop Out Calendar'/>
<hr style='opacity: .4' />
<div id="year-scheduler-tabs" style="color: #333">
</div>
<div id='scheduler-year-calendar'>
    <div class="scheduler-year-month" id="scheduler-year-month-0"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-1"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-2"></div>
    <div style="clear: both"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-3"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-4"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-5"></div>
    <div style="clear: both"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-6"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-7"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-8"></div>
    <div style="clear: both"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-9"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-10"></div>
    <div class="scheduler-year-month" id="scheduler-year-month-11"></div>
    <div style="clear: both"></div>
</div>
<div id="scheduler-year-list">

</div>
<div id="scheduler-availability-calendar">

</div>
<script type='text/javascript'>
    (function () {
        let now = new Date();
        let yyyy = now.getFullYear();
        (function (year) {
            let tabs = new EasyTab('year-scheduler-tabs',150);
            tabs.add('Calendar',null,"scheduler-year-calendar");
            tabs.add('Event List',(function (year) {
                return function () {
                    (new EasyAjax('/scheduler/events/review')).then(function (response) {
                        $('#scheduler-year-list').html(response);
                    }).post();
                }
            })(year),"scheduler-year-list");
            tabs.add('Availability',(function (year) {
                return function () {
                    (new EasyAjax('/scheduler/availability/review')).then(function (response) {
                        $('#scheduler-availability-calendar').html(response);
                    }).post();
                }
            })(year),'scheduler-availability-calendar');
            tabs.tabClick(0);
        })(yyyy);
        $('.scheduler-calendar-year').on('click',function (evt) {
            $('.scheduler-calendar-year').css({ "font-weight": 'normal',color: '#007bff' });
            $(evt.target).css({ "font-weight":'bold',color: 'ghostwhite' });
        });
        $('#year_calendar_user_id').on('change',function (evt) {
            Scheduler.calendar.renderYear(Scheduler.calendar.currentYear,$(evt.target).val());
        });  
        Scheduler.calendar.renderYear(yyyy,$('#year_calendar_user_id').val());
        $('.year-calendar-popout').on('click',function (evt) {
            if ($('#year_calendar_user_id').val()) {
                let win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/scheduler/calendar/popout')).add('window_id',win.id).add('user_id',$('#year_calendar_user_id')).then(function (response) {
                    win._open(response);
                }).post();
            } else {
                alert('Please select someone to load their calendar');
            }
        });
    })();
</script>