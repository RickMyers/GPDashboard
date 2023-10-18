<div id='dental-facetime-header' style="background-color: #333; color: ghostwhite; padding: 10px 2px 10px 2px; font-size: 1.3em">
    <div style="float: right; position: relative; top: -10px; height: 36px; overflow: hidden;  border-radius: 18px; background-color: #8AA9C1" onclick="Argus.teledentistry.open.wand()"><img src="/images/dental/wand_icon.png" style="height: 36px" /></div>
    Argus Facetime
</div>
<video id='dental-facetime-body' style="background-color: lightcyan">
</video>
<div id='dental-facetime-footer' style="background-color: #333; color: ghostwhite; padding: 2px 2px 10px 2px; font-size: .85em; text-align: center">

    <button style="color: #333" id="hangupButton-player" onclick="Argus.teledentistry.connect.hangup()">Hangup</button>
</div>
<script type='text/javascript'>
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#dental-facetime-body').height($(win.content).height() - $E('dental-facetime-header').offsetHeight - $E('dental-facetime-footer').offsetHeight);
        }   
        win._resize();
        $('#hangupButton-player').on('click',function () {
            alert('hanging up');
        });
        Argus.teledentistry.connect.facetime();
    })();
</script>

