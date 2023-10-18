<style type="text/css">
    #messenger-{$window_id} {
        position: relative; width: 100%; height: 100%; white-space: nowrap; overflow: hidden; margin: 0px; padding: 0px
    }
    .messenger-region {
        display: inline-block; position: relative; box-sizing: border-box; margin: 0px; padding: 0px
    }
    .call-window {
        min-width: 450px; width: 70%; border-right: 1px solid #777; border-bottom: 1px solid #777; background: url("/images/paradigm/bg_graph.png"); 
    }
    .text-window {
        min-width: 100px; width: 29%; border-bottom: 1px solid #777; background: url("/images/dashboard/text_bkg.png"); background-size: 100% 100%;
    }
    .chat-window {
        width: 100%; min-height: 120px; top: -5px
    }
</style>
{*
 background: url("/images/dashboard/text_bkg.png") no-repeat fixed center center / cover rgba(0, 0, 0, 1)
*}
<div id="messenger-{$window_id}" style='width: 100%; height: 500px'>
    <video muted="muted" id='{$window_id}' style="background-color: lightcyan" style='width: 100%; height: 100%'>
    </video>
</div>
<script type="text/javascript">
//    Branding.person = "{$user->getFirstName()} {$user->getLastName()}";
(function (win) {
    win._title('Call With {$name}');
    var user_id = '{$with}';
    var RTC     = EasyRTC.get(win.id,
        Argus.dashboard.socket,
        Argus.teledentistry.configuration(),
        Argus.teledentistry.constraints('facetime'),
        Argus.teledentistry.options('facetime'),
        Argus.teledentistry.events(user_id+'Facetime'));
    Argus.teledentistry.set('facetime',RTC);
    RTC.ready(RTC.play);
    win.close = function () {
        EasyRTC.get(win.id).hangup();
    };
    Argus.dashboard.socket.on('inbound'+user_id+'FacetimeCall',function (data) {
       // if (data.id != Argus.dashboard.socket.id) {
            RTC.callInProgress = true;
            Argus.dashboard.socket.emit('RTCUserMessageRelay',{ "message": RTC.events.reply.inbound, 'user_id': user_id, 'id': this.id } );
       // }
    });
})(Desktop.window.list['{$window_id}']);


</script>