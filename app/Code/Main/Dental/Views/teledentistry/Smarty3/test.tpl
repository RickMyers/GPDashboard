<div id="call_test_{$window_id}" style="background-color: lightcyan">
    <center style="position: relative">
        <video style="margin-right: 10px; display: inline-block; border: 1px solid black; background-image: url(/images/paradigm/bg_graph.png)" id="video_player_{$window_id}">

        </video>
    </center>
</div>
<div id="video_call_controls_{$window_id}" style="text-align: center; background-color: #333; padding: 5px">
    <button id="rtc_test_call_{$window_id}">Make Call</button>&nbsp;
    <button id="rtc_test_hangup_{$window_id}">Hangup</button>
</div>
<script type="text/javascript">
    (function () {
        var win = Desktop.window.list['{$window_id}'];

        win.resize = function () {
            var h = win.content.height() - $E('video_call_controls_{$window_id}').offsetHeight
            $('#call_test_{$window_id}').height(h);
            $('#video_player_{$window_id}').width(h*(4/3)).height(h);
        };
        win._resize();
    })();
    (function (RTC) {
        RTC.ready(RTC.play);
        $('#rtc_test_call_{$window_id}').on('click',function () { RTC.call(); });
        $('#rtc_test_hangup_{$window_id}').on('click',function () { RTC.hangup(); });
    })(EasyRTC.get('{$window_id}',Argus.dashboard.socket,Argus.teledentistry.configuration(),Argus.teledentistry.constraints('facetime'),Argus.teledentistry.options('facetime')));
</script>