
<style type='text/css'>
    .event_queue_header {
        display: inline-block; border: 1px solid ghostwhite;  width: 100%; 
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; 
    }
    .event_queue_body {
        display: inline-block; border: 1px solid ghostwhite; width: 100%; height: 72%; margin-top: 0px; overflow: hidden;
    }
    .event_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; width: 100%; height: 15%;
        color: navy; text-align: center; margin-bottom: 0px;
    }
    .event_pagination_control {
        padding: 2px 5px;
    }
</style>

<div class='event_queue_header'>
Today's Events
</div>
<br />
<div class='event_queue_body' id="events-queue">
</div>

<div class='event_queue_footer' >
    <table width='100%'>
        <tr>
            <td>
                <span id='events-from-row'></span>-<span id='events-to-row'></span> of <span id='events-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='events-previous' id='events-previous' style='' class='event_pagination_control' value='<' />
                <input type='button' name='events-first' id='events-first' style='' class='event_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='events-last' id='events-last' style='' class='event_pagination_control' value='>>' />
                <input type='button' name='events-next' id='events-next' style='' class='event_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='events-page'></span> of <span id='events-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('events',function (page,rows) {
       Scheduler.events.queue($E('events-queue'),'events',page,rows);
    },1,14);
</script>