<style type="text/css">
    .scheduler-event-row {
        white-space: nowrap; overflow: hidden; margin-bottom: 2px;
    }
    .scheduler-event-cell {
        display: inline-block;  overflow: hidden; margin-right: 2px; border-right: 1px solid silver; padding-right: 2px
    }
    .scheduler-event-header {
        font-family: monospace; font-size: .9em; letter-spacing: 2px; padding-left: 4px; overflow: hidden
    }
    .scheduler-event-field {
        font-family: sans-serif; font-size: 1em;  padding-left: 20px; overflow: hidden
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td height="40" style='font-family: sans-serif; font-weight: bold; color: #333; background-color: rgba(202,202,202,.3)'>
            Today's Events
        </td>
    </tr>
    <tr>
        <td style='overflow: auto; padding: 1px 0px; vertical-align: top'>
            {foreach from=$events->listMyEvents() item=event}
                <div class="scheduler-event-row" style='background-color: rgba(202,202,202,{cycle values=".6,.85"})'>
                    <div class="scheduler-event-cell" style="min-width: 70px; width: 8%">
                        <div class="scheduler-event-header">
                            Event ID#
                        </div>
                        <div class="scheduler-event-field" style="text-align: center">
                            <b>{$event.id}</b>&nbsp;
                        </div>
                    </div>
                    <div class="scheduler-event-cell" style="min-width: 175px; width: 20%">
                        <div class="scheduler-event-header">
                            Participants
                        </div>
                        <div class="scheduler-event-field">
                            {$event.participants}
                        </div>
                    </div>

                    <div class="scheduler-event-cell" style="min-width: 150px; width: 20%">
                        <div class="scheduler-event-header">
                            Event Type
                        </div>
                        <div class="scheduler-event-field">
                            <a href="#" onclick="Scheduler.events.edit('{$event.event_id}'); return false">[{$event.namespace|ucfirst}] {$event.type}</a>&nbsp;
                        </div>
                    </div>
                    <div class="scheduler-event-cell" style="min-width: 80px; width: 10%">
                        <div class="scheduler-event-header">
                            Event Time
                        </div>
                        <div class="scheduler-event-field">
                            {$event.start_time} - {$event.end_time}&nbsp
                        </div>
                    </div>
                    <div class="scheduler-event-cell">
                        <div class="scheduler-event-header" style="min-width: 250px; width: 30%">
                            Location Address
                        </div>
                        <div class="scheduler-event-field" style="padding-right: 10px">
                            {if (isset($event.location_id_combo))}[{$event.location_id_combo}]{else}[N/A]{/if}
                            {if (isset($event.address_id_combo))}{$event.address_id_combo}{else}N/A{/if}
                        </div>
                    </div>                    
                </div>
            {/foreach}
        </td>
    </tr>
</table>
