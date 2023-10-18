<div>
    <div class='messenger-row'>
        <div style="float: right; margin-right: 5px">
            <div style="display: inline-block; margin-top: 10px; width: 26px; height: 26px;">
                <img v-on:click="logout(messenger)" class="messenger-image" src="/images/dashboard/logoff_icon.png" style="width: 26px; height: 26px; cursor: pointer" v-bind:title="'Force Logout '+messenger.first_name+' '+messenger.last_name"/>
            </div>        
            <div style="display: inline-block; margin-top: 10px; width: 26px; height: 26px; margin-left: 10px;">
                <img v-on:click="chat(messenger)" class="messenger-image" src="/images/dashboard/text_chat_icon.png" style="width: 26px; height: 26px; cursor: pointer" v-bind:title="'Text With '+messenger.first_name+' '+messenger.last_name"/>
            </div>
            <div style="display: inline-block; margin-top: 10px; width: 26px; height: 26px;">
                <img v-on:click="video(messenger)" class="messenger-image" src="/images/dashboard/video_call_icon.png" style="width: 26px; height: 26px; cursor: pointer" v-bind:title="'Video Call With '+messenger.first_name+' '+messenger.last_name" />
            </div>
        </div>    
        <div class='messenger-avatar'>
            <img class='messenger-image' v-bind:src="messenger.avatar" ></img>
        </div>
        <div class='messenger-text'>
            [{{ messenger.user_name }}] {{ messenger.first_name }} {{ messenger.last_name }}
        </div>
    </div>
    <div style="clear: both; height: 2px; background-color: white"></div>
</div>