<div id='dental-facetime-header' style="position: absolute; margin-left: auto; margin-right: auto; background-color: rgba(50,50,50,.4); color: ghostwhite; font-size: 1em; width: 272px; border-bottom-left-radius: 5px; border-bottom-right-radius: 5px; border: 1px solid transparent; margin-left: auto; margin-right: auto ">
    <div style="display:block; position: relative; z-index: 9;  margin-left: auto; margin-right: auto; width: 272px; color: #333; white-space: nowrap; overflow: hidden; text-align: center">
        <div title="Switch Cameras" style="display: inline-block; cursor: pointer; width: 36px;  position: relative; top: 0px; height: 36px; overflow: hidden;  border-radius: 20px; background-color: #cecece; margin-right: 30px;"><img src="/images/dental/swap.png" style="height: 34px" onclick="Argus.teledentistry.connect.swap();" /></div>
        <div title="Place Call" id="dental-facetime-call-button" style="display: inline-block; cursor: pointer; width: 36px;  position: relative; top: 0px; height: 36px; overflow: hidden;  border-radius: 20px; background-color: #cecece; padding-top: 3px"><img src="/images/dental/call.png" style="height: 30px" /></div>
        <div title="Hangup" id="dental-facetime-hangup-button" style="display: inline-block; cursor: pointer; width: 36px; position: relative; top: 0px; height: 36px; overflow: hidden;  border-radius: 20px; background-color: #cecece; padding-top: 5px"><img src="/images/dental/hangup.png" style="height: 30px" /></div>
        <div title="Take a Snapshot" style="display: inline-block; position: relative; height: 36px; cursor: pointer; overflow: hidden;  border-radius: 18px; background-color: #cecece; padding: 6px; margin-right: 30px" onclick="Argus.teledentistry.open.snapshot('{$form_id}','facetime')"><img src="/images/dental/snapshot_red.png" style="height: 24px" /></div>
        <div title="Activate Wand" style="display: inline-block; cursor: pointer; position: relative; top: -0px; height: 36px; overflow: hidden;  border-radius: 18px; background-color: #cecece" onclick="Argus.teledentistry.open.wand('{$form_id}');"><img src="/images/dental/wand_icon.png" style="height: 36px" /></div>
    </div>
</div>
<center>
    <div id="">
    <video muted="muted" id='dental-facetime-body' style="background-color: lightcyan">
    </video>
    </div>
</center>
<script type='text/javascript'>
    //this is a bit extreme, but there's no pollution of the global namespace
    (function (win,RTC,form_id) {
        var cb = $E('dental-facetime-call-button');
        var hb = $E('dental-facetime-hangup-button');
        Argus.teledentistry.set('facetime',RTC);
        hb.disabled = true;
        RTC.ready(RTC.play);
        win.close = function () {
            RTC.hangup();
        };
        Argus.dashboard.socket.on('inbound'+form_id+'FacetimeCall',function (data) {
            if (data.id != Argus.dashboard.socket.id) {
                RTC.callInProgress = true;
                Argus.dashboard.socket.emit('RTCMessageRelay',{ "message": RTC.events.reply.inbound, 'id': this.id } );
            }
        });
        $(cb).on('click',function () { 
            if (!Argus.teledentistry._facetime()) { 
                Argus.teledentistry._facetime(true);
                RTC.findPeer(); 
            } else {
                Argus.teledentistry._facetime(false);
            };
            //cb.disabled=true;  
        });
        $(hb).on('click',function () { win._close(); });
    })((function (win) {
        win.resize = function () {
            $('#dental-facetime-body').height($(win.content).height());
            $('#dental-facetime-header').css('left',(($(win.content).width() - $E('dental-facetime-header').offsetWidth)/2)+"px");
        };
        win._resize();
        return win;
    })(Desktop.window.list['{$window_id}']),EasyRTC.get('dental-facetime-body',Argus.dashboard.socket,Argus.teledentistry.configuration(),Argus.teledentistry.constraints('facetime'),Argus.teledentistry.options('facetime'),Argus.teledentistry.events('{$form_id}Facetime')),'{$form_id}');
</script>
