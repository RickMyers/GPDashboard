{assign var=daily_events value=$events->eventsByRoles()}
<style type="text/css">
    .event-date-field {
        font-weight: bold;
    }
    .event-time-field {
        font-weight: bold;
    }
</style>
<div id='scheduler-events-nav'>
</div>
<div id='scheduler-events-list'>

</div>
<div id="new-event-tab">
    <form nohref name='scheduler-event-form' id='scheduler-event-form' onsubmit='return false'>
        <div style="padding-left: 20px">
            <fieldset style="padding: 10px 5px; margin-bottom: 5px"><legend>Instructions</legend>
                To create an event, specify a start date and time, an end date and time, and choose the type of event we are creating.
            </fieldset>
            <input type='hidden' name='event_id' id='scheduler_event_id' value='' />
            <input type='hidden' name='event_start_date' id='scheduler_event_start_date' value='{$mm}/{$dd}/{$yyyy}' />
            <input type='hidden' name='event_start_time' id='scheduler_event_start_time' value='' />
            <input type='hidden' name='event_end_date'   id='scheduler_event_end_date'   value='{$mm}/{$dd}/{$yyyy}' />
            <input type='hidden' name='event_end_time'   id='scheduler_event_end_time'   value='' />
            <input type='hidden' name='resource'         id='scheduler_event_resource'   value='' />
            <input type='hidden' name='event_type_id'    id='scheduler_event_type_id'    value='' />
            <select name="event_type" id="scheduler_event_type" style="border: 1px solid silver; padding: 3px; border-radius: 2px">
                <option value="">Choose from one of the events below...</option>
                {foreach from=$event_types->userEventTypes() item=type}
                    <option value="{$type.id}|{$type.resource}">[{$type.namespace|ucfirst}] - {$type.type}</option>
                {/foreach}
            </select>
            <div style="letter-spacing: 2px; margin-bottom: 20px">
            Event Type
            </div>
            <div style="width: 660px;">
                <div style="display: inline-block; width: 320px;">
                    EVENT START DATE/TIME [<span id="event-start-date" class="event-date-field">{$mm}/{$dd}/{$yyyy}</span> <span id="event-start-time" class="event-time-field">hh:mn</span>]
                    <div id="event_start_calendar" >
                    </div>                   
                </div>
                <div style="display: inline-block; width: 320px">
                    EVENT END DATE/TIME [<span id="event-end-date" class="event-date-field">{$mm}/{$dd}/{$yyyy}</span> <span id="event-end-time" class="event-time-field">hh:mn</span>]
                    <div id="event_end_calendar">
                    </div>   
                </div>
                <div style="clear: both"></div>
            </div>
            
            <div style="clear: both"></div>
            <div id="new-event-details">
            </div>
        </div>
    </form>
</div>
<script type="text/javascript">
    (function () {
            let tabs = new EasyTab('scheduler-events-nav',120);
            tabs.add('Event List',function () {
                let ao = new EasyAjax('/scheduler/events/today');
                if ($('#year_calendar_user_id').val()) {
                    ao.add('user_id',$('#year_calendar_user_id').val());
                }
                ao.add('date','{$mm}/{$dd}/{$yyyy}').then(function (response) {
                    $('#scheduler-events-list').html(response);
                }).get();
            },'scheduler-events-list');
            tabs.add('New Event',false,'new-event-tab');
            tabs.tabClick(0)
            new EasyEdits('/edits/scheduler/eventtypes');
            let opts = {
                format: "m/d/Y h:i A", inline: true, lang: "en", startDate: "{$yyyy}/{$mm}/{$dd}",
                hours12: true,
                allowTimes:[
                    '8:00','8:30','9:00','9:30','10:00','10:30','11:00','11:30','12:00','12:30', '13:00', '13:30','14:00','14:30','15:00', 
                    '15:30', '16:00', '16:30', '17:00', '17:30', '18:00','18:30'
                ]
            }
            opts.onSelectDate = function (ct) {
                let now = moment(ct);
                $('#event-start-date').html(now.format('MM/DD/Y'));
                $('#scheduler_event_start_date').val(now.format('MM/DD/Y'));
                Scheduler.create.event();
            }
            opts.onSelectTime = function (ct) {
                 let now = moment(ct);
                $('#scheduler_event_start_time').val(now.format('h:mm A'));
                $('#event-start-time').html(now.format('h:mm A'));
                Scheduler.create.event();
            }
           $('#event_start_calendar').datetimepicker(opts);
            opts.onSelectDate = function (ct) {
                 let now = moment(ct);
                $('#event-end-date').html(now.format('MM/DD/Y'));
                $('#scheduler_event_end_date').val(now.format('MM/DD/Y'));
                Scheduler.create.event();
            }
            opts.onSelectTime = function (ct) {
                 let now = moment(ct);
                $('#event-end-time').html(now.format('h:mm A'));
                $('#scheduler_event_end_time').val(now.format('h:mm A'));
                Scheduler.create.event();
            }
           $('#event_end_calendar').datetimepicker(opts);
    })();
</script>            

