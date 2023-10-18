{foreach from=$events->listMyEvents() item=event}
    <div class="scheduler-event-row" style="background-color: rgba(202,202,202,{cycle values=".1,.4"})">
        <div class="scheduler-event-cell" style="width: 15%">
            <div class="scheduler-event-heading">
                Date
            </div>
            <div class="scheduler-event-field">
                {$event.start_date|date_format:"m/d/Y"}-{$event.end_date|date_format:"m/d/Y"}
            </div>
        </div>
        <div class="scheduler-event-cell"style="width: 15%">
            <div class="scheduler-event-heading">
                Health Plan
            </div>
            <div class="scheduler-event-field">
                {$event.health_plan}
            </div>
        </div>            
        <div class="scheduler-event-cell"style="width: 20%">
            <div class="scheduler-event-heading">
                Event Type
            </div>
            <div class="scheduler-event-field">
                {$event.type}
            </div>
        </div>
        <div class="scheduler-event-cell" style="width: 30%">
            <div class="scheduler-event-heading">
                Location
            </div>
            <div class="scheduler-event-field">
                {$event.screening_location_combo}
            </div>
        </div>
        <div class="scheduler-event-cell" style="width: 20%">
            <div class="scheduler-event-heading">
                Contact Name
            </div>
            <div class="scheduler-event-field">
                {$event.contact_name}
            </div>
        </div>
    </div>
{/foreach}

