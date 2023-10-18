<fieldset><legend>Argus Messenger</legend>
<style>
    .messenger-row {
         margin-bottom: 0px; padding: 0px; background-color: rgba(202,202,202,.3); box-sizing: border-box
    }
    .messenger-avatar {
         margin-bottom: 0px; padding: 0px; display: inline-block; width: 50px; height: 50px; position: relative; overflow: hidden;
         overflow: hidden; border-radius: 25px;
    }
    .messenger-image {
        width: 100%; height: 100%; margin-bottom: 0px; padding: 0px;
    }
    .messenger-text {
        display: inline-block; vertical-align: top; padding-top: 14px; font-size: 1.5em; font-family: monospace; margin-bottom: 0px; 
    }
</style>
<div id="argus-messenger">
      <messenger-user-list
        v-for="user in onlineUsers"
        v-bind:messenger="user"
        v-bind:key="user.user_id"
      ></messenger-user-list>
</div>
</fieldset>
<script>
    {literal}
    Vue.component(
        'messenger-user-list',
        { 
            props: ['messenger'],
            template: Humble.template('dashboard/messenger'),
            methods: {
                logout: function (data) {
                    if (confirm('Logout this person?')) {
                        Argus.dashboard.socket.emit('logUserOff',data);
                    }   
                },
                chat: function (data) {
                    console.log('chat');
                    console.log(data);
                    console.log(this);
                },
                video: function (data) {

                    var win = Desktop.semaphore.checkout(true);
                    (new EasyAjax('/dashboard/messenger/call')).add('window_id',win.id).add('with',data.uid).then(function (response) {
                        win._open(response);
                        Argus.dashboard.socket.emit('RTCUserMessage',{'message': 'incomingCall','from': Branding.id, 'user_id': data.uid });
                        Argus.dashboard.socket.on('callAccepted',function (data) {
                            var user_id = data.uid;
                            console.log('mydata');
                            console.log(data);
                            EasyRTC.get(win.id).findPeer();
                            win.close = function () {
                                EasyRTC.get(win.id).hangup();
                            };
                        });
                    }).post();
                    Argus.dashboard.socket.on('callDeclined',function () {
                        alert('call declined');
                        win._close();
                    });
                    console.log(data);
                }  
            } 
        }
    );    
    (function () {
        var win_id = Desktop.whoami($E('argus-messenger'));
        Desktop.window.list[win_id]._scroll(true).dock('TL');
        Argus.apps(win_id, new Vue({
                el: '#argus-messenger',
                data: function () {
                    return {
                        isAdmin: false,
                        onlineUsers: [
                        ]
                    }
                }
            })
        );
    })();
    {/literal}
</script>
