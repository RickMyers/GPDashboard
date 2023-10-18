<style type='text/css'>
    .availability-year-month {
        min-width: 300px; width: 32%; margin-right: 1%; float: left; padding: 3px; border: 1px solid rgba(202,202,202,.8); border-radius: 3px; margin-bottom: 5px
    }
    .year-availability-weekday {
        width: 50px; border: 1px solid rgba(202,202,202,.2); font-size: 1.1em; height: 30px; font-family: sans-serif; text-align: center
    }
    .year-availability-weekend {
        width: 60px; border: 1px solid rgba(202,202,202,.2); font-size: 1.1em; height: 30px; font-family: sans-serif; text-align: center; background-color: rgba(202,202,202,.3)
    }
    .year-availability-daynames {
        font-size: .8em; font-family: sans-serif;  background-color: rgba(202,202,202,.3)
    }
    .year-availability-monthname {
        font-family: sans-serif; font-size: 1.0em; letter-spacing: 1px; background-color: rgba(202,202,202,.3)
    }
    .year-availability-userid {
        border: 1px solid #aaf; padding: 2px; background-color: lightcyan; margin-left: 10px
    }
    .year-availability-popout {
        cursor: pointer; height: 28px; display: inline-block; position: relative; top: -2px
    }
</style>

<form name="year_availability_form" id="year_availability_form" onsubmit="return false">
    <select style='width: 200px;' name="user_id" id="year_availability_user_id" class='year-availability-userid'>
        <option value=""></option>
        {foreach from=$users->usersWithRoleName('O.D.') item=user}
            <option value="{$user.user_id}">{$user.last_name}, {$user.first_name}</option>
        {/foreach}
        {foreach from=$users->usersWithRoleName('PCP Staff') item=user}
            <option value="{$user.user_id}">{$user.last_name}, {$user.first_name}</option>
        {/foreach}                                                        
    </select>
    <input type="hidden" name="availability_year" id="year_availability_current_year" value="" />
</form>
<img src='/images/scheduler/popout.png'  class='year-availability-popout' title='Pop Out Calendar'/>
<hr style='opacity: .4' />
<div id="year-availability-tabs" style="color: #333">
</div>
<div id='scheduler-availability-year'>
    <div class="availability-year-month" id="availability-year-month-0"></div>
    <div class="availability-year-month" id="availability-year-month-1"></div>
    <div class="availability-year-month" id="availability-year-month-2"></div>
    <div style="clear: both"></div>
    <div class="availability-year-month" id="availability-year-month-3"></div>
    <div class="availability-year-month" id="availability-year-month-4"></div>
    <div class="availability-year-month" id="availability-year-month-5"></div>
    <div style="clear: both"></div>
    <div class="availability-year-month" id="availability-year-month-6"></div>
    <div class="availability-year-month" id="availability-year-month-7"></div>
    <div class="availability-year-month" id="availability-year-month-8"></div>
    <div style="clear: both"></div>
    <div class="availability-year-month" id="availability-year-month-9"></div>
    <div class="availability-year-month" id="availability-year-month-10"></div>
    <div class="availability-year-month" id="availability-year-month-11"></div>
    <div style="clear: both"></div>
</div>
<script type='text/javascript'>
    (function () {
        let now = new Date();
        let yyyy = now.getFullYear();
        $('#year_availability_user_id').on('change',function (evt) {
            Scheduler.availability.renderYear(Scheduler.availability.currentYear,$(evt.target).val());
        });  
        Scheduler.availability.renderYear(yyyy,$('#year_availability_user_id').val());
        $('.year-availability-popout').on('click',function (evt) {
            if ($('#year_availability_user_id').val()) {
                let win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/scheduler/availability/popout')).add('window_id',win.id).add('user_id',$('#year_availability_user_id')).then(function (response) {
                    win._open(response);
                }).post();
            } else {
                alert('Please select someone to load their availability');
            }
        });
    })();
</script>