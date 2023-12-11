<style type="text/css">
    .scheduler-event-row {
        white-space: nowrap; overflow: hidden;
    }
    .scheduler-event-cell {
        display: inline-block
    }
    .scheduler-event-heading {
        font-family: monospace; font-size: .95em
    }
    .scheduler-event-field {
        padding-left: 20px; font-family: sans-serif; font-size: .9em
    }
</style>
<div style='color: #333; margin-top: 2px; margin-bottom: 2px'>
    <form name='event_list_form' id='event_list_form' onsubmit='return false'>
        <select name="year" id="event_year">
            <option value="2025"> 2025 </option>
            <option value="2024"> 2024 </option>
            <option value="2023" selected="true"> 2023 </option>
            <option value="2022"> 2022 </option>
            <option value="2021"> 2021 </option>
            <option value="2020"> 2020 </option>
            <option value="2019"> 2019 </option>
        </select>
        <select name="month" id="event_month">
            <option value='' style='text-style: italic'  disabled selected>Month</option>
            <option value="01">January</option>
            <option value="02">Febuary</option>
            <option value="03">March</option>
            <option value="04">April</option>
            <option value="05">May</option>
            <option value="06">June</option>
            <option value="07">July</option>
            <option value="08">August</option>
            <option value="09">September</option>
            <option value="10">October</option>
            <option value="11">November</option>
            <option value="12">December</option>
        </select>
        <select name="technician" id="event_technician">
            <option value='' style='text-style: italic'  selected>Technician</option>
            {foreach from=$technicians->getUsersByRoleName('PCP Staff') item=technician}
                <option value="{$technician.user_id}">{$technician.last_name}, {$technician.first_name}</option>
            {/foreach}
        </select>
        <select name="od" id="event_od">
            <option value='' style='text-style: italic' selected>O.D. Reviewer</option>
            {foreach from=$ods->getUsersByRoleName('O.D.') item=od}
                <option value="{$od.user_id}">{$od.last_name}, {$od.first_name}</option>
            {/foreach}
        </select>
        <input type='button' id='event_list_submit' name='event_list_submit' value=' Display ' />
    </form>
    <div id='scheduler_events_list'>
    </div>
</div>
<script type='text/javascript'>
    (function () {
        new EasyEdits('/edits/scheduler/eventlist','eventlist');
    })();
</script>
