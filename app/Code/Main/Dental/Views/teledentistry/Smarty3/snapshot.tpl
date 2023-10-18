<div id='dental-snapshot-header' style="position: absolute; margin-left: auto; margin-right: auto; background-color: rgba(50,50,50,.4); color: ghostwhite; font-size: 1em; width: 172px; border-bottom-left-radius: 5px; border-bottom-right-radius: 5px; border: 1px solid transparent; margin-left: auto; margin-right: auto ">
    <div style="display:block; position: relative; z-index: 9;padding-top: 2px; padding-bottom: 5px;  margin-left: auto; margin-right: auto; width: 172px; color: #333; white-space: nowrap; overflow: hidden; text-align: center">
        <button id='dental-snapshot-save' style=' color: #333;' >Save and Attach</button>
    </div>
</div>
<div id='dental-snapshot-body'>
    <table style='width: 100%; height: 100%'>
        <tr>
            <td valign='middle'>
                <center>
                    <canvas id='dental-snapshot-canvas' style='display: none; width: 800px; height: 600px'></canvas>
                    <img style='width: 800px; height: 600px;' id='dental-snapshot-image' src="" style='margin-left: auto; margin-right: auto;' />
                </center>
            </td>
        </tr>
    </table>
</div>
<div id='dental-snapshot-footer' style="background-color: #333; color: ghostwhite; padding: 2px 2px 10px 2px; font-size: .85em; text-align: center">
</div>
<script type='text/javascript'>
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#dental-snapshot-body').height($(win.content).height() -  $E('dental-snapshot-footer').offsetHeight);
            $('#dental-snapshot-header').css('left',(($(win.content).width() - $E('dental-snapshot-header').offsetWidth)/2)+"px");
        }
        win._resize();
        $('#dental-snapshot-save').on('click',function () {
            (new EasyAjax('/dental/consultation/snapshot')).add('form_id','{$form_id}').add('snapshot',$E('dental-snapshot-image').src).then(function (response) {
                Desktop.window.list['{$window_id}']._close();
                Argus.dashboard.socket.emit('newDentalSnapshot');
            }).post();
        });
    })();
</script>