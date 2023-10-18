<style type="text/css">
    .event_list_row {
        white-space: nowrap; overflow: hidden; margin: 0px;
    }
    .event_list_header {
        min-width: 70px; background-color: #333; color: ghostwhite; display: inline-block; padding: 2px; text-align: center
    }
    .event_list_field {
       margin: 0px; box-sizing: border-box; min-width: 70px; color: #333; display: inline-block; border-right: 1px solid #777; padding: 2px 4px; background-color: rgba(202,202,202,.2); color: ghostwhite;  white-space: nowrap
    }
</style>
<div class="event_list_row">
    <div class="event_list_header" style="width: 5%">
        Event #
    </div><div class="event_list_header" style="width: 15%">
        Event Date
    </div><div class="event_list_header" style="width: 15%">
        Contact
    </div><div class="event_list_header" style="width: 15%">
        IPA
    </div><div class="event_list_header" style="width: 25%">
        Location
    </div><div class="event_list_header" style="width: 25%">
        Address
    </div>
</div>
{foreach from=$events->listEvents() item=event}<div class="event_list_row" style="background-color: rgba(202,202,202,{cycle values=".1,.3"}); cursor: pointer" onclick="Scheduler.events.edit('{$event.id}'); return false"
    ><div class="event_list_field" style="width: 5%; text-align: center">
        {$event.id}
    </div><div class="event_list_field" style="width: 15%; text-align: center">
        {$event.start_date|date_format:"m/d/Y"} [{$event.start_time}-{$event.end_time}]
    </div><div class="event_list_field" style="width: 15%">
        {$event.contact_name}
    </div><div class="event_list_field" style="width: 15%">
        {$event.ipa_id_combo}
    </div><div class="event_list_field" style="width: 25%">
        {$event.location_id_combo}
    </div><div class="event_list_field" style="width: 25%">
        {$event.address_id_combo}
    </div></div>{foreachelse}<br />No events found to match criteria<br />{/foreach}