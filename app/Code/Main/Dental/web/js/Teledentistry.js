Argus.teledentistry = (function () {
    var devices = [];                                                           //Array of devices (cameras).  The first one to connect is assumed to be the camera you want to do facetime with
    var wand    = false;                                                                   //Specific reference to the wand camera device
    var facetime=false;                                                               //Specific reference to the facetime camera device
    var room    = Argus.tools.id(6);                                            //Virtual waiting room ID
    var win     = {
        facetime:    false,
        wand:        false,
        snapshot:    false,
        waitingRoom: false,
        test:        false
    };
    //constraints are used to define limitations (or lack thereof) of the connecting cameras. For instance, we want Audio on facetime but not on the wand camera
    var offerOptions = {
        "facetime": {
            offerToReceiveAudio: 0,
            offerToReceiveVideo: 1
        },
        "wand": {
            offerToReceiveAudio: 0,
            offerToReceiveVideo: 1
        }
    };
    var constraints = {
        players: {
            "facetime": "dental-facetime-body",
            "wand":     "dental-wand-body"
        },
        wand: {
            audio: false,
            video: {
                mandatory: {
                    sourceId: false
                }
            }
        },
        facetime: {
            audio: true,
            video: {
                mandatory: {
                    sourceId: false
                }
            }
        }
    };

    var configuration = {
        iceServers: [
            {
                urls: "stun:stun.l.google.com:19302"
            },
            {
                urls: "turn:numb.viagenie.ca",
                'credential': '',
                'username': ''
            }
        ]
    };
    if (navigator && navigator.mediaDevices && navigator.mediaDevices.enumerateDevices) {
        navigator.mediaDevices.enumerateDevices().then(function (deviceInfo) {
            deviceInfo.forEach(function (device) {
                //We are going to assume that the first video device to connect is the facetime camera, and the second one to connect is the wand
                if (device.kind === 'videoinput') {
                    if (devices.length === 0) {
                        constraints.facetime.video.mandatory.sourceId = device.deviceId;
                    } else if (devices.length === 1) {
                        constraints.wand.video.mandatory.sourceId     = device.deviceId;
                    } else {
                        alert("Take it easy tiger, we only support two cameras at a time here...");
                    }
                    devices[devices.length] = device;
                }
            });
        });
    }
    return {
        set: function (whichone,RTC) {
            if (whichone === 'wand') {
                wand = RTC;
            } else {
                facetime = RTC;
            }
            return this;
        },
        constraints: function (camera) {
            return constraints[camera];
        },
        options: function (camera) {
            return offerOptions[camera];
        },
        configuration: function () {
            return configuration;
        },
        events: function (id) {
            return {
                "call": {
                    "inbound": "inbound"+id+"Call"
                },
                "reply": {
                    "inbound": "inbound"+id+"Reply"
                },
                "offer": {
                    "inbound": "inbound"+id+"Offer"
                },
                "answer": {
                    "inbound": "inbound"+id+"Answer"
                },
                "candidate": {
                    "inbound": "inbound"+id+"Candidate"
                },
                "negotiation": {
                    "inbound": "inbound"+id+"Negotiation"
                }
            }
        },
        dentist: false,
        waiting: false,
        windows: function () {
            return win;
        },
        peers: {
            facetime: false,
            wand: false
        },
        available: function () {
            return (navigator && navigator.mediaDevices);
        },
        test: {
            page: function () {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/dental/teledentistry/test')).add('window_id',win.id).then(function (response) {
                    win._scroll(false)._title('Test Call')._open(response);
                }).get();
            }
        },
        waitingRoom: {
            refresh: function (stuff) {
                //need to relay to the waiting room window new content
                win.waitingRoom._open(stuff).dock('L');
            },
            queue: function (ind) {
                var message = (Argus.teledentistry.waiting===false) ? "Would you like to enter the Teledentistry Waiting Room?" : "Do you wish to exit the Teledentistry Waiting Room?";
                if (confirm(message)) {
                    Argus.teledentistry.waiting = !Argus.teledentistry.waiting;                                             //toggle
                    win.waitingRoom = win.waitingRoom ? win.waitingRoom : Desktop.semaphore.checkout(true);
                    $(ind).css('opacity',Argus.teledentistry.waiting ? 1.0 : 0.4);
                    (new EasyAjax('/dental/teledentistry/room')).add('waiting',Argus.teledentistry.waiting).add('window_id',win.waitingRoom.id).add('room',room).then(function (response) {
                        if (Argus.teledentistry.waiting) {
                            win.waitingRoom.close = function () {
                                var choice = confirm("Do you wish to leave the Teledentistry Waiting Room?");
                                if (choice) {
                                    Argus.teledentistry.waiting = false;
                                    (new EasyAjax('/dental/teledentistry/closeroom')).add('room',room).then(function () {
                                        Argus.dashboard.socket.emit('patientLeftWaitingRoom', {});
                                        $('#dental-waiting-room-alert').css('opacity','0.4');
                                    }).post();
                                } else {
                                    return false;
                                }
                            };
                            win.waitingRoom._static(true)._title('Dental Waiting Room')._open(response).dock('TL');
                        } else {
                            Argus.dashboard.socket.emit('patientLeftWaitingRoom', {});
                            win.waitingRoom._close();
                        }
                    }).post();
                }
            }
        },
        snapshot: function (source) {
            var canvas      = $E('dental-snapshot-canvas');
            var context     = canvas.getContext('2d');
            var width       = $('#dental-'+source+'-body').width();
            var height      = $('#dental-'+source+'-body').height();
            canvas.width    = width;
            canvas.height   = height;
            context.clearRect(0,0,width,height);
            context.drawImage($E('dental-'+source+'-body'), 0, 0, width, height);
            var data        = canvas.toDataURL('image/png');
            $E('dental-snapshot-image').setAttribute('src', data);
        },
        form: {

        },
        open: {
            waitingRoom: function () {
                win.waitingRoom = (win.waitingRoom) ? win.waitingRoom : Desktop.semaphore.checkout(true);
                win.waitingRoom._title("Dental Waiting Room")._static(true)._open();
                (new EasyAjax('/dental/teledentistry/waitingroom')).add('window_id',win.waitingRoom.id).then(function (response) {
                    win.waitingRoom.set(response).dock('TL');
                }).post();
            },
            facetime: function (form_id) {
                win.facetime = (win.facetime) ? win.facetime : Desktop.semaphore.checkout(true);
                win.facetime._title("Argus Facetime")._static(true)._open().dock('TR');
                (new EasyAjax('/dental/teledentistry/facetime')).add('form_id',form_id).add('window_id',win.facetime.id).then(function (response) {
                    win.facetime.set(response);
                }).post();
            },
            snapshot: function (form_id,whichone) {
                win.snapshot = (win.snapshot) ? win.snapshot : Desktop.semaphore.checkout(true);
                win.snapshot._title("Wand Snapshot")._static(true)._scroll(true)._open();
                (new EasyAjax('/dental/teledentistry/snapshot')).add('form_id',form_id).add('window_id',win.snapshot.id).then(function (response) {
                    win.snapshot.set(response);
                    Argus.teledentistry.snapshot(whichone);
                    win.snapshot.resizeTo(720*(4/3),720);
                }).post();
            },
            wand: function (form_id) {
                win.wand = (win.wand) ? win.wand : Desktop.semaphore.checkout(true);
                win.wand._title("Argus Wand")._static(true)._open().dock('BR');
                (new EasyAjax('/dental/teledentistry/wand')).add('form_id',form_id).add('window_id',win.wand.id).then(function (response) {
                    win.wand.set(response);
                    Argus.dashboard.socket.emit('teledentistryWandActivated',{ "form_id": form_id, "user_id": Branding.id });
                }).post();
            }
        },
        _wand: function (arg) {
            if (arg!==undefined) {
                wand = arg;
                return this;
            }
            return wand;
        },
        _facetime: function (arg) {
            if (arg!==undefined) {
                facetime = arg;
                return this;
            }
            return facetime;
        },
        _room: function () {
            return room;
        },
        connect: {
            dentist: function () {
                if (Argus.teledentistry.waiting) {
                    Argus.teledentistry.open.facetime('player');
                }
            },
            swap: function () {
                //first we swap player references, then we swap constraints, then we swap mediastreams
                var swap  = constraints.players.facetime;
                constraints.players.facetime = constraints.players.wand;
                constraints.players.wand     = swap;
                swap = constraints.wand.video.mandatory.sourceId;
                constraints.wand.video.mandatory.sourceId     = constraints.facetime.video.mandatory.sourceId;
                constraints.facetime.video.mandatory.sourceId = swap;
                swap = constraints.wand.audio;
                constraints.wand.audio     = constraints.facetime.audio;
                constraints.facetime.audio = swap
                swap = facetime.mediaStream();
                facetime.mediaStream(wand.mediaStream());
                wand.mediaStream(swap);
                facetime.play();
                wand.play()
            },
            facetime: function () {
                navigator.mediaDevices.getUserMedia(constraints.facetime).then(function(mediaStream) {
                    console.log('Facetime Player: '+constraints.players.facetime);
                    var video = document.getElementById(constraints.players.facetime);
                    video.srcObject = mediaStream;
                    video.onloadedmetadata = function(e) {
                        video.play();
                        console.log('playing main camera');
                    };
                });

            },
            wand: function () {
                navigator.mediaDevices.getUserMedia(constraints.wand).then(function(mediaStream) {
                    console.log('Wand Player: '+constraints.players.wand);
                    var video = document.getElementById(constraints.players.wand);
                    video.srcObject = mediaStream;
                    video.onloadedmetadata = function(e) {
                        video.play();
                        console.log('playing wand');
                    };
                });
            },
            hangup: function () {
                Argus.dashboard.socket.emit('dentistHungup');
                Argus.teledentistry.connect.close();
            },
            peer: function (form_id) {
                Argus.dashboard.socket.emit('dentistInitiatedCall',{"form_id": form_id});
            },
            close: function () {
                let stream = videoElem.srcObject;
                let tracks = stream.getTracks();

                tracks.forEach(function(track) {
                  track.stop();
                });

                videoElem.srcObject = null;
            }

        },
        init: function () {
            //deals with the fact that WebRTC is still in its infancy and the various browser makers prefix unfinished specs
            navigator.getUserMedia       = navigator.getUserMedia       || navigator.mozGetUserMedia       || navigator.webkitGetUserMedia;
            window.RTCPeerConnection     = window.RTCPeerConnection     || window.mozRTCPeerConnection     || window.webkitRTCPeerConnection;
            window.RTCIceCandidate       = window.RTCIceCandidate       || window.mozRTCIceCandidate       || window.webkitRTCIceCandidate;
            window.RTCSessionDescription = window.RTCSessionDescription || window.mozRTCSessionDescription || window.webkitRTCSessionDescription;
        },
        finish: function () {

        }
    }
})();
