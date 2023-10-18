<table style="width: 100%; height: 100%; text-align: center">
    <tr>
        <td>
            <div class="user-portrait">
                <img onload="Argus.tools.image.align(this)" src="/images/argus/avatars/{{user_id}}.jpg" onerror="this.src='/images/argus/placeholder-{{gender}}.png'" style="margin-right: auto; margin-left: auto; height: 150px; width: 100%;">                
            </div>
            <div style='text-align: center; color: ghostwhite; font-size: 2em; font-weight: bolder'>Incoming Call From {{first_name}} {{last_name}}</div>
            <div style='text-align: center'>
                <button style='background-color: lime; border: 2px solid black; padding: 5px; border-radius: 5px; font-size: 1.5em; font-weight: bolder; color: #333; width: 120px' onclick="Argus.dashboard.call.accept('{{user_id}}','{{window_id}}')">Accept</button> 
                <button style='background-color: crimson; border: 2px solid black; padding: 5px; border-radius: 5px; font-size: 1.5em; font-weight: bolder; color: ivory; width: 120px' onclick="Argus.dashboard.call.decline('{{user_id}}','{{window_id}}')">Decline</button>
            </div>
        </td>
    </tr>
</table>
