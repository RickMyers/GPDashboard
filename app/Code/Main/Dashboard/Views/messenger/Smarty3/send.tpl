<script type="text/javascript">
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        
        var minHeight = 500;
        var minWidth  = 600;
        var call    = {
            configuration: function () {
                return [
                    {
                        urls: "stun:stun.l.google.com:19302"
                    },
                    {
                        urls: "turn:numb.viagenie.ca",
                        'credential': 'fXcQKKaMyyhx',
                        'username': 'rickmyers1969@gmail.com'
                    }
                ]
            },
            constraints: function () {
                return {
                    audio: true,
                    video: {
                        mandatory: {
                            sourceId: false
                        }
                    }
                }
            },
            options: function () {
                return  {
                    offerToReceiveAudio: 0,
                    offerToReceiveVideo: 1
                },
            },
            events: function () {
                return             return {
                    "call": {
                        "inbound": "inbound_"+Branding.id+"_Call"
                    },
                    "reply": {
                        "inbound": "inbound_"+Branding.id+"_Reply"
                    },
                    "offer": {
                        "inbound": "inbound_"+Branding.id+"_Offer"
                    },
                    "answer": {
                        "inbound": "inbound_"+Branding.id+"_Answer"
                    },
                    "candidate": {
                        "inbound": "inbound_"+Branding.id+"_Candidate"
                    },
                    "negotiation": {
                        "inbound": "inbound_"+Branding.id+"_Negotiation"
                    }
                }
            }
        };
        win.resize = function () {
            $('#messenger-{$window_id}').height(win.content.height());
            var w   = win.content.width() > minWidth   ? win.content.width()  : minWidth;
            var h   = win.content.height() > minHeight ? win.content.height() : minHeight;
            $('#messenger-call-{$window_id}').width(Math.round(.7*w)).height(h-120);
            $('#messenger-text-{$window_id}').width(Math.round(.7*w)).height(h-120);
        };
       // win.resize();
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
        })(Desktop.window.list['{$window_id}']),EasyRTC.get('messenger-chat-{$window_id}',Argus.dashboard.socket,call.configuration(),Argus.call.constraints('facetime'),call.options('facetime'),call.events('Facetime')));
    })();
</script>

