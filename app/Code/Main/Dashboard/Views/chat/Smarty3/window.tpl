<style>
  #chat-window-{$window_id} { font: 13px Helvetica, Arial; }
  #{$window_id}-form { background: #000; padding: 3px; position: absolute; bottom: 1px; width: 100%; }
  #{$window_id}-form > input  { border: 0; padding: 10px; width: 90%; margin-right: .5%; }
  #{$window_id}-form > button { width: 9%; background: rgb(130, 224, 255); border: none; padding: 10px; }
  #{$window_id}-messages { list-style-type: none; margin: 0; padding: 0; }
  #{$window_id}-messages li { padding: 5px 10px; }
  #{$window_id}-messages li:nth-child(odd) { background: #eee; }
</style>
</head>
<div id="chat-window-{$window_id}" style="position: relative">
    <ul id="{$window_id}-messages"></ul>
    <form id="{$window_id}-form" action="">
        <input id="{$window_id}-m" type="text" autocomplete="off" /><button>Send</button>
    </form>
</div>
<script type="text/javascript">
    (function () {
        $('#{$window_id}-form').submit(function () {
            Argus.dashboard.socket.emit('chat message', $('#'+Argus.dashboard.chat.window.id+'-m').val());
            $('#'+Argus.dashboard.chat.window.id+'-m').val('');
            return false;
        });

        var win = Desktop.window.list['{$window_id}'];
        win.resize = (function (win) {
            return function () {
                $('#chat-window-{$window_id}').height(win.content.height());
            }
        })(win);
        win.resize();

    })();
</script>

