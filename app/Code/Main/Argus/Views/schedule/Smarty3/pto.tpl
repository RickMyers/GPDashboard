<div id="event-date-picker">
    
</div>
<script type="text/javascript">
$("#event-date-picker").filthypillow( {
        exitOnBackgroundClick: false,
        {if (isset($data.event_date))}
            initialDateTime:  function (m) {
                                return moment("{$date} 12:00").format("YYYY-MM-DD HH:mm"); 
                              },
        {/if}            
        calendar: {
            isPinned: true
        },
        minDateTime: function( ) {
          return moment( ).subtract( "days", 365 );
        },
        maxDateTime: function( ) {
          return moment( ).add( "days", 365 );
        }
});
$("#event-date-picker").filthypillow( "show");    

$('#event-date-picker').on("fp:save",function (e, stamp) {
    if (stamp) {
        $('#event_date').val(stamp.format('YYYY-MM-DD'));
        $('#event_time').val(stamp.format('HH:mm'));
    }
});
</script>
