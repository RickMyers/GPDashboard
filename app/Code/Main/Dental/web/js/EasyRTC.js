'use strict';
var EasyRTC = (function () {
    //variables that can be "elevated" to a semi-global scope relative the object are placed up here
    let EasyRTCs        = { };
    let mediaStream     = { };
    let socket          = false;
    let pc              = { };
    let players         = { };
    let defaults        = {
        "events": {
            "call": {
                "inbound": "inboundCall"
            },
            "reply": {
                "inbound": "inboundReply"
            },
            "offer": {
                "inbound": "inboundOffer"
            },
            "answer": {
                "inbound": "inboundAnswer"
            },
            "candidate": {
                "inbound": "inboundCandidate"
            },
            "negotiation": {
                "inbound": "inboundNegotiation"
            }
        },
        "configuration": {
            iceServers: [
                {
                    urls: [
                            "stun:stun.l.google.com:19302",
                            "stun:stun1.l.google.com:19302",
                            "stun:stun2.l.google.com:19302",
                            "stun:stun3.l.google.com:19302",
                            "stun:stun4.l.google.com:19302"
                    ]
                }
            ]
        },
        "options": {
            offerToReceiveAudio: 1,
            offerToReceiveVideo: 1
        },
        "constraints": {
            audio: true,
            video: true
        }
    };
    function output(m) {
        return function (e) {
            console.log('EasyRTC: '+m);
            if (e) {
                console.log(e);
            }
        };
    }
    function scrubEvents(events) {
        events.call         = (events.call) ? events.call : defaults.events.call;
        events.reply        = (events.reply) ? events.reply : defaults.events.reply;
        events.offer        = (events.offer) ? events.offer : defaults.events.offer;
        events.answer       = (events.answer) ? events.answer : defaults.events.answer;
        events.candidate    = (events.candidate) ? events.candidate : defaults.events.candidate;
        events.negotiation  = (events.negotiation) ? events.negotiation : defaults.events.negotiation;
        return events;
    }
    function scrubConstraints(constraints) {
        constraints.audio = (constraints.audio || constraints.audio === false || constraints.audio === 0) ? constraints.audio : defaults.constraints.audio;
        constraints.video = (constraints.video || constraints.video === false || constraints.video === 0) ? constraints.video : defaults.constraints.video;
        return constraints;
    }
    function scrubOfferOptions(options) {
        options.offerToRecieveAudio = (options.offerToReceiveAudio || options.offerToReceiveAudio === false || options.offerToReceiveAudio === 0) ? options.offerToReceiveAudio  : defaults.options.offerToReceiveAudio;
        options.offerToRecieveVideo = (options.offerToRecieveVideo || options.offerToRecieveVideo === false || options.offerToRecieveVideo === 0) ? options.offerToRecieveVideo  : defaults.options.offerToRecieveVideo;
        return options;
    }
    function scrubConfiguration(config) {
        config.iceServers   = (config.iceServers)   ? config.iceServers  : defaults.configuration.iceServers;
        return config;
    }
    function init(id,configuration,constraints) {
        pc[id] = new RTCPeerConnection(configuration);
        mediaStream[id] = false;
        if (constraints.video.mandatory.sourceId) {
            navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
                stream.getTracks().forEach(
                    function(track) {
                        pc[id].addTrack(track,stream);
                    }
                );
                mediaStream[id] = stream;
            }).catch(
                output('Failed to initialize stream')
            );
        }
        return true;
    };
    let RTC     = {
        failed:         false,
        prepped:        false,
        playing:        false,
        audio:          false,
        video:          false,
        initialized:    false,
        mediaStream:    false,
        callInProgress: false,
        listeningForReply: false,
        readyFunc:      [],
        failFunc:       [],
        goodFunc:       [],
        defaults:   function () {
            return defaults;
        },
        fail: function (func) {
            if (func) {
                this.failFunc[this.failFunc.length] = func;
            } else {
                for (var i=0; i<this.failFunc.length; i++) {
                    this.failFunc[i]();
                }
            }
        },
        success: function (func) {
            if (func) {
                this.goodFunc[this.goodFunc.length] = func;
            } else {
                for (var i=0; i<this.goodFunc.length; i++) {
                    this.goodFunc[i]();
                }
            }
        },
        ready: function (func) {
            //This is an implementation of a poor-mans Promise.  Used this way because ES6 is not guaranteed.
            //When the media stream is ready, it will autoplay.
            let me = this;
            if (func) {
                this.readyFunc[this.readyFunc.length] = function () { func.call(me); };
            }
            if (mediaStream[this.id] !== false) {
                //assert true!
                for (var i=0; i<this.readyFunc.length; i++) {
                    this.readyFunc[i]();
                }
            } else {
                window.setTimeout(function () { me.ready(); },50);
            }
            return (mediaStream[this.id] !== false);
        },
        mediaStream: function (stream) {
            if (stream !== undefined) {
                mediaStream[this.id] = stream;
            } else {
                return mediaStream[this.id];
            }
            return this;
        },
        prep: function () {
            console.log('prepped');
            let me = this;
            pc[this.id].ontrack = function (evt) {
                console.log('Track Arrived');
                if (!players[me.id]) {
                    players[me.id] = $E(me.id);
                    players[me.id].onloadedmetadata   = function(e) {
                        this.play();
                    };
                }

                players[me.id].srcObject = evt.streams[0];
                players[me.id].srcObject.getAudioTracks()[0].enabled = true;
                players[me.id].muted = false;
                //Now Unmute Yourself!

            } ;
            pc[this.id].oniceconnectionstatechange = function(e) {
                //maybe someday I'll do something, but right now no...
            };
            pc[this.id].onnegotiationneeded = function (e) {
                var message = this.user_id ? "RTCUserMessageRelay" : "RTCMessageRelay";
                this.createOffer().then(function (offer) {
                    return pc[me.id].setLocalDescription(offer);
                }).then(function () {
                    socket.emit(message,{ "message": me.events.negotiation.inbound, "type": "offer", "desc": this.localDescription, "user_id": this.user_id });
                }).catch(output('Error during negotiation'));
            };
            pc[this.id].onicecandidate = function(e) {
                var message = this.user_id ? "RTCUserMessageRelay" : "RTCMessageRelay";
                socket.emit(message,{ "message": me.events.candidate.inbound, "id": socket.id, "candidate": e.candidate, "user_id": this.user_id });
            };
            socket.on(this.events.offer.inbound,function (offer) {
                var message = this.user_id ? "RTCUserMessageRelay" : "RTCMessageRelay";
                if (offer.id !== socket.id) {
                    pc[me.id].setRemoteDescription(offer.offer).then(function (answer) {
                        pc[me.id].createAnswer(answer).then(function (response) {
                            pc[me.id].setLocalDescription(response).then(function () {
                                socket.emit(message,{ "message": me.events.answer.inbound, "id": socket.id, "answer": response, "user_id": this.user_id });
                            });
                        }).catch(
                            output('Failed to set local description')
                        );
                    }).catch(
                        output('Failed to set remote description')
                    );
                } else {
                    console.log('ignoring my own offer');
                }
            });
            socket.on(this.events.answer.inbound,function (response) {
                if (response.id !== socket.id) {
                    pc[me.id].setRemoteDescription(response.answer).catch(
                        output('Failed to set remote description')
                    );
                }
            });
            socket.on(this.events.candidate.inbound,function (e) {
                if ((e.id !== socket.id) && (e.candidate)) {
                    pc[me.id].addIceCandidate(e.candidate).catch(
                        output('failed adding candidate!')
                    );
                }
            });
            this.prepped = true;
        },
        play: function () {
            var me = this;
            if (!this.prepped) {
                this.prep();
            }
            players[this.id]                    = $E(this.id);
            if (!players[this.id]) {
                console.log('WebRTC Video Player not found!');
                return;
            }
            players[this.id].srcObject          = mediaStream[this.id];
            players[this.id].muted = true;
            players[this.id].onloadedmetadata   = function(e) {
                me.playing = true;
                this.play();
            };
        },
        call: function () {
            console.log("got my reply");
            let me      = this;
            this.callInProgress = true;
            if (!players[this.id]) {
                console.log(console.log('Playing - '+this.id));
                this.play();
            }
            pc[this.id].createOffer(this.offerOptions).then(function (offerData) {
                var message = me.user_id ? "RTCUserMessageRelay" : "RTCMessageRelay";                
                pc[me.id].setLocalDescription(offerData).then(function (data) {
                    socket.emit(message,{ "message": me.events.offer.inbound, 'id': socket.id, 'offer': offerData, "user_id": this.user_id });
                }).catch(
                    output('Failed setting local description')
                );
            });
        },
        reply: function (data) {
            if (data.id != socket.id) {
                console.log('ok, valid reply');
                this.play();
                this.call();
            } else {
                console.log('ignoring my own reply')
            }
        },
        findPeer: function () {
            //We are going to send a message that we are ready to call, and when we get a response that we
            var me = this;
            if (!this.callInProgress) {
                console.log("Sending invite to chat - "+me.events.call.inbound);
                var message = me.user_id ? "RTCUserMessageRelay" : "RTCMessageRelay";
                socket.emit(message, { "message": me.events.call.inbound, "id": socket.id, "user_id": this.user_id  });
                window.setTimeout(function () { me.findPeer(); }, 1000);
            } else {
                console.log('call in progress');
            }
            if (!this.listeningForReply) {
                console.log('Setting listener for reply - '+me.events.reply.inbound);
                socket.on(me.events.reply.inbound, function (data) { me.reply(data); });
                this.listeningForReply = true;
            }
        },
        hangup: function () {
            this.prepped = false;
            this.readyFunc = [];
            if (mediaStream[this.id]) {
                mediaStream[this.id].getTracks().forEach(function (track) {
                    track.stop();
                });
            }
            if (pc[this.id] && pc[this.id].close) {
                pc[this.id].close();
            }
            if (players[this.id] && players[this.id].srcObject) {
                players[this.id].srcObject = null;
            }
            delete players[this.id];
            delete mediaStream[this.id];
            delete pc[this.id];
            delete EasyRTCs[this.id];
        }
    };
    return {
        /* This method takes the arguments passed and 'scrubs' them, allowing you to run with defaults but only change the part of the configuration you want, and not have to pass in an entire configuration array */
        get: function (identifier,websocket,configuration,constraints,options,events,user_id) {
            if (!websocket) {
                return EasyRTCs[identifier];
            }
            user_id         = user_id           ? user_id                           : false;
            socket          = (!socket)         ? websocket                         : socket;
            events          = (events)          ? scrubEvents(events)               : defaults.events;
            constraints     = (constraints)     ? scrubConstraints(constraints)     : defaults.constraints;
            offerOptions    = (options)         ? scrubOfferOptions(options)        : defaults.options;
            configuration   = (configuration)   ? scrubConfiguration(configuration) : defaults.configuration;
            return (EasyRTCs[identifier])       ? EasyRTCs[identifier] : (EasyRTCs[identifier] = Object.create(RTC,{"id": { "value": identifier }, "user_id": { "value": user_id }, "offerOptions": { "value": offerOptions }, "events": { "value": events }, 'initialized': { "value": init(identifier,configuration,constraints) } } ));
        }
    };
})();
