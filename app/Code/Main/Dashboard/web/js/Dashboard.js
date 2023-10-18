Argus.dashboard = function ($) {
    var messenger     = null;
    var imActive        = false;
    var desktopActive   = false;
    var chatWindows     = { };
    return {
        loaded: false,
        desktop: {
            toggle: function () {
                if (desktopActive) {
                    $('#container').fadeIn();
                    $('#container-desktop').fadeOut();
                } else {
                    $('#container').fadeOut();
                    $('#container-desktop').fadeIn(Desktop.icon.position);                    
                }
                desktopActive = !desktopActive
            },
            access: function () {
                let win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/dashboard/desktop/access')).add('window_id',win.id).then(function (response) {
                    win._title('Desktop App Access')._open(response);
                }).post();
            }
        },
        call: {
            ring: false,
            incoming: false,
            accept: function (user_id,window_id) {
                Argus.dashboard.call.ring.pause();
                console.log('i accept call from '+user_id);
                Argus.dashboard.socket.emit('RTCUserMessage',{"message": "callAccepted", "user_id": user_id});
                Desktop.window.list[window_id].splashScreen();
                //Argus.dashboard.RTCS[window_id].findPeer();
            },
            decline: function (user_id,window_id) {
                Argus.dashboard.call.ring.pause();
                Argus.dashboard.socket.emit('RTCUserMessage',{"message": "callDeclined", "user_id": user_id});
                Desktop.window.list[window_id].splashScreen();    
                Desktop.window.list[window_id]._close();
            }
        },
        feature: {
            win: false,
            template: false,
            page: 1,
            rows: 40,
            list: function () {
                (new EasyAjax('/dashboard/feature/list')).add('page',Argus.dashboard.feature.page).add('rows',Argus.dashboard.feature.rows).then(function (response) {
                    var raw = {
                        "data": JSON.parse(response)
                    };
                    $('#dashboard_feature_request_list').html(Argus.dashboard.feature.template(raw));
                }).post();
            },
            request: function () {
                var win = Argus.dashboard.feature.win = (Argus.dashboard.feature.win) ? Argus.dashboard.feature.win : Desktop.semaphore.checkout(true);
                win._static(true)._title('Bug or Feature Request');
                (new EasyAjax('/dashboard/feature/requestform')).then(function (response) {
                    win._open(response);
                }).get();
            }
        },
        socket: {
            on: function (a,b) {
                //These are just stubbed out for when we deploy to prod and the Hub isn't ready
                console.log('Listener Issue, not ready to listen for '+a);
            },
            emit: function (a,b) {
                //These are just stubbed out for when we deploy to prod and the Hub isn't ready
            },
            removeListener(a,b) {
                
            }
        },
        im: {
            open: function () {
                messenger._open();
                messenger.close = function () { imActive = false;  return true};
                (new EasyAjax('/dashboard/messenger/home')).then((response) => {
                    messenger.set(response);
                    imActive = true;
                    Argus.dashboard.socket.emit('userStatus');
                }).get();
            }
        },
        chat: {
            window: false
        },
        home: function () {
            (new EasyAjax('/dashboard/user/home')).then(function (response) {
                $('#container').html(response);
            }).post();
        },
        app: {
            create: function () {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/dashboard/app/new')).add('window_id',win.id).then(function (response) {
                    win._open(response)._title('New Desktop App');
                }).get();
            }
        },
        video: {
            call: function () {
                
            }
        },
        init: function () {
            Handlebars.registerHelper('zebra',function (row) {
                return (row % 2) ? .15 : .3;
            });
            Handlebars.registerHelper('format_time',function (data) {
                var t   = data.split(':');
                var ft  = "";
                if (t.length > 0) {
                    ft = ((t[0]>12) ? t[0]-12 : t[0]) +':'+ t[1] + ((t[0]>12) ? " PM" : " AM");
                }
                return ft;
            });
            Handlebars.registerHelper('ucfirst',function (string) {
               return string.charAt(0).toUpperCase()+string.slice(1);  
            });
            Argus.dashboard.feature.template = Handlebars.compile((Humble.template('dashboard/RequestList')));
            Argus.dashboard.socket = io(Branding.socket);
            Argus.dashboard.socket.on('connect',function () {
                //each namespace gets to register its RTC listeners now...
                window.setTimeout(function () {
                    //this is cheesy.  We are going to wait a few seconds to let everything else catch up... this is an anti-pattern but oh well
                    for (var i in Argus) {
                        if (Argus[i].RTC) {
                            Argus[i].RTC();
                        }
                    }
                    Scheduler.init();
                },2000);
            });
            Argus.dashboard.call.incoming    = Handlebars.compile((Humble.template('dashboard/IncomingCall')));            
        },
        user: {
            list: function () {
                Argus.dashboard.socket.emit('userStatus');
            }
        },
        logout: function (message) {
            (new EasyAjax('/dashboard/user/logout')).then(function () {
                message = message ? message : 'Successfully Logged Out';
                window.location.href = '/index.html?message='+message;                    
            }).post();
        },
        maps: {
            home: function () {
                (new EasyAjax('/dashboard/maps/home')).then(function (response) {
                    $('#container').html(response);
                }).post();
            }
        },
        RTCS: [],        
        RTC: function () {
            messenger = Desktop.semaphore.checkout(true);
            if (messenger) {
                messenger._title('Online Users')._static(true);
                messenger._cancel = function () { alert('ok') }; 
            }
            Argus.dashboard.socket.emit('logUserIn',{ "user_id": Branding.id });
            console.log('connected to signaling server');
            //The following allows each module to register their RTC events, all they have to do is have a method called RTC() off of their namespace
            Argus.dashboard.socket.on('currentUsers',function (data) {
                console.log(data);
            });
            Argus.dashboard.socket.on('rickHasLeft',function (data) {
                $('#ricks_familiar').css('opacity',0.3);
            });
            Argus.dashboard.socket.on('rickIsOnline',function (data) {
                $('#ricks_familiar').css('opacity',0.9);
            });
            Argus.dashboard.socket.on('logout',function (data) {
                //This is when the user logs out
                Argus.dashboard.logout('Logout Successful');
            });
            Argus.dashboard.socket.on('MessageTest',function (data) {
                console.log('Ive been pinged with a message test');
                console.log(data);
            });            
            Argus.dashboard.socket.on('chatInvite_'+Branding.id,function (data) {
                console.log("Incoming Chat Invite");
                console.log(data);
                //Ok, we got a chat invite... it should contain the chat room id
                //Set a listener for that rooms chat messages
            });
            Argus.dashboard.socket.on('chat message', function(msg){
                if (!Argus.dashboard.chat.window) {
                    var win = Argus.dashboard.chat.window = Desktop.semaphore.checkout(true);
                    //this looks like a good place for a vue web component!
                    (new EasyAjax('/dashboard/chat/window')).add('window_id',win.id).then(function (response) {
                        win._static(true)._open(response);
                        $('#'+win.id+'-messages').append($('<li>').text(msg));
                    }).get();
                } else {
                    Argus.dashboard.chat.window._open();
                    $('#'+Argus.dashboard.chat.window.id+'-messages').append($('<li>').text(msg));
                }
            }); 
            Argus.dashboard.socket.on('userListUpdate',function (data) {
                $('#users_online').html(data.users_online);
                if (imActive) {
                    var app = Argus.apps(Desktop.whoami($E('argus-messenger')));
                    app.onlineUsers = data.users;
                    
                }
            });
            Argus.dashboard.socket.on('incomingCall',function (data) {
                console.log(data);
                if (data && data.from) {
                    var win = Desktop.semaphore.checkout(true);
                    (new EasyAjax('/dashboard/user/whois')).add('from',data.from).then(function (response) {
                        var user = JSON.parse(response);
                        var ring = Argus.dashboard.call.ring = new Audio('/app/ringtone.mp3');
                        win._open()._title('Call With '+user.first_name+' '+user.last_name).splashScreen(Argus.dashboard.call.incoming({first_name: user.first_name, last_name: user.last_name, window_id: win.id, user_id: user.id }));
                        ring.addEventListener('canplay',function (evt) {
                            ring.play(); 
                        });
                        (new EasyAjax('/dashboard/messenger/call')).add('window_id',win.id).add('with',data.from).add('name',user.first_name+' '+user.last_name).then(function (response) {
                            win.set(response);
                        }).get();
                    }).get();
                }
            });
            Argus.dashboard.socket.on('broadcastMessage',function (data) {
                //if we do the alert from the main JS thread, then the UI will freeze until the person clicks the OK button.  Let's do the alert from a worker thread so we dont freeze the page
                let blob = new Blob([
                    "onmessage = function(e) { postMessage('"+data.text+"');  }"]
                );
                let blobURL = window.URL.createObjectURL(blob);                 // Obtain a blob URL reference to our worker 'file'.
                let worker = new Worker(blobURL);                               // Now we load our fake file because workers require files
                worker.onmessage = function(message) {
                    alert(message.data);
                    this.terminate();
                };
                worker.postMessage(data.text);
            });
            Argus.dashboard.socket.on('logUserOff',function (data) {
                if (data.uid == Branding.id) {
                    //This is when the user gets logged out
                    Argus.dashboard.logout('Session expired');
                }
            });
        },
        lightbox: {
            ref: false,
            open: function (template) {
                $(Argus.dashboard.lightbox.ref).css('display','block').width($(window).width()).height($(window).height());
                if (template) {
                    $(Argus.dashboard.lightbox.ref).html(template);
                }
            },
            resize: function (evt) {
                $(Argus.dashboard.lightbox.ref).width($(window).width()).height($(window).height());
            },
            inject: function (html) {
                $(Argus.dashboard.lightbox.ref).html(html);
            },
            close: function () {
                $(Argus.dashboard.lightbox.ref).css('display','none');
            }
        },
        whitelabels: {
            home: function () {
                (new EasyAjax('/dashboard/whitelabels/home')).then(function (response) {
                    $('#sub-container').html(response);
                }).post();
            },
            update: function (user_id,label_id) {
                (new EasyAjax('/dashboard/whitelabels/update')).add('id',user_id).add('white_label_id',label_id).then(function (response) {
                    //alert(response);
                }).post();
            }
        },
        background: {
            init: function () {
                $('#background_'+($('#background_id').val() ? $('#background_id').val() : 4)).css('border-width','3px');
            },
            select: function (id,image) {
                $('#background_id').val(id);
                $('#background_image').val(image);
                $(document.body).css('background-image','url(/images/dashboard/backgrounds/'+image+')');
            }
        },
        metrics: {
            app: function (data) {
                console.log(data);
            }
        },
        widgets: {
            calculator: function () {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/dashboard/widgets/calculator')).then(function (response) {
                    win.resizeTo(310,400);
                    win._title('Calculator');
                    win._open(response);
                }).get();
            },
            claims: function () {
                var win = Desktop.semaphore.checkout(true);
                (new EasyAjax('/dashboard/widgets/claims')).add('window_id',win.id).then(function (response) {
                    win._title('Claim File Analyzer')._open(response);
                }).get();
            }
        }
    }
}($);