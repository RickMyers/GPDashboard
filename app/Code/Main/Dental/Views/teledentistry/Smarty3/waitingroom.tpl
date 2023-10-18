<div id='dental-waiting-room-header' style="background-color: #333; color: ghostwhite; padding: 10px 2px 10px 2px; font-size: 1.3em">
    Dental Waiting Room
</div>
<div id='dental-waiting-room-body'>
    <div id="dental-waiting-rooms-available">
    </div>
</div>
<div id='dental-waiting-room-footer' style="background-color: #333; color: ghostwhite; padding: 2px 2px 10px 2px; font-size: .85em">
    &nbsp;
</div>
<script type='text/javascript'>
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#dental-waiting-room-body').height($(win.content).height() - $E('dental-waiting-room-header').offsetHeight - $E('dental-waiting-room-footer').offsetHeight);
        }   
        win._resize();
        (new EasyAjax('/dental/teledentistry/rooms')).then(function (response) {
            $('#dental-waiting-rooms-available').html(response);
        }).post();
    })();
    
</script>