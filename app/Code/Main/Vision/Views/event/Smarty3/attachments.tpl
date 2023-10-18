<style type="text/css">
    .event-attachment-cell {
        display: inline-block; padding: 2px;  background-color: rgba(202,202,202,.15); font-size: .9em; margin-right: 2px;
    }
    .event-attachment-filename {
        width: 20%;
    }
    .event-attachment-author {
        width: 19%;
    }
    .event-attachment-description {
        width: 50%;
    }
    .event-attachment-date {
        width: 10%;
    }
    .event-attachment-column-header {
        text-align: center; font-weight: bolder
    }
</style>
<div style="border-bottom: 1px solid #333"><div class="event-attachment-cell event-attachment-filename event-attachment-column-header">
        Filename
    </div><div class="event-attachment-cell event-attachment-author event-attachment-column-header">
        Author
    </div><div class="event-attachment-cell event-attachment-description event-attachment-column-header">
        Description
    </div><div class="event-attachment-cell event-attachment-date event-attachment-column-header">
        Uploaded
    </div></div>
{foreach from=$attachments->details() item=attachment}
    <div style="background-color: rgba(202,202,202,{cycle values=".2,.4"})"><div class="event-attachment-cell event-attachment-filename">
            <a href="#" onclick="Argus.vision.event.attachment('{$attachment.id}');return false;">{$attachment.filename}</a>&nbsp;
        </div><div class="event-attachment-cell event-attachment-author">
            {$attachment.author}&nbsp;
        </div><div class="event-attachment-cell event-attachment-description">
            {$attachment.description}&nbsp;
        </div><div class="event-attachment-cell event-attachment-date">
            {$attachment.modified|date_format:"m/d/Y"}&nbsp;
        </div></div>
{/foreach}
<div style="height: 100px">
</div>
