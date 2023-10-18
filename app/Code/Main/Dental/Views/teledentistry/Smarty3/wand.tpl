<div id='dental-wand-header' style="position: absolute; left: 40%; background-color: rgba(50,50,50,.4); color: ghostwhite; font-size: 1em; width: 240px; border-bottom-left-radius: 5px; border-bottom-right-radius: 5px; border: 1px solid transparent; margin-left: auto; margin-right: auto ">
    <div style="display:block; position: relative; z-index: 9;  margin-left: auto; margin-right: auto; width: 100px; color: #333; white-space: nowrap; overflow: hidden; text-align: center">
        <div id="dental-wand-broadcast-button" title="Broadcast" style="display: inline-block; position: relative; top: -0px; height: 36px; overflow: hidden; cursor: pointer; border-radius: 18px; background-color: #cecece" onclick=""><img src="/images/dental/broadcast.png" style="height: 36px" /></div>
        <div title="Take a Snapshot" style="display: inline-block; position: relative; height: 36px; cursor: pointer; overflow: hidden;  border-radius: 18px; background-color: #cecece; padding: 6px" onclick="Argus.teledentistry.open.snapshot('{$form_id}','wand')"><img src="/images/dental/snapshot_red.png" style="height: 24px" /></div>
    </div>
</div>
<center>
<video muted="muted" id='dental-wand-body' style="background-color: lightcyan">
</video>
</center>
<div id='dental-wand-footer' style="background-color: #333; color: ghostwhite; padding: 2px 2px 10px 2px; font-size: .85em">
</div>
<script type='text/javascript'>
    (function (win,RTC,form_id) {
        var cb = $E('dental-wand-broadcast-button');
        Argus.teledentistry.set('wand',RTC);
        RTC.prep();
        RTC.ready(RTC.play);
        win.close = function () { 
            RTC.hangup();
        };
        Argus.dashboard.socket.on('inbound'+form_id+'WandCall',function (data) {
            if (data.id != Argus.dashboard.socket.id) {
                RTC.callInProgress = true;
                Argus.dashboard.socket.emit('RTCMessageRelay',{ "message": RTC.events.reply.inbound, 'id': this.id } );
            }
        });        
        $(cb).on('click',function () { RTC.findPeer(); cb.disabled = true; });
    })((function (win) {
        win.resize = function () {
            $('#dental-wand-body').height($(win.content).height());
            $('#dental-wand-header').css('left',(($(win.content).width() - $E('dental-wand-header').offsetWidth)/2)+"px");            
        };
        win._resize();
        return win;
    })(Desktop.window.list['{$window_id}']),EasyRTC.get('dental-wand-body',Argus.dashboard.socket,Argus.teledentistry.configuration(),Argus.teledentistry.constraints('wand'),Argus.teledentistry.options('wand'),Argus.teledentistry.events('{$form_id}Wand')),'{$form_id}');
</script>
