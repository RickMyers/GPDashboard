<table style="width: 100%; height: 100%">
    <tr>
        <td style="background-color: #333; height: 25px">&nbsp;</td>
    </tr>
    <tr>
        <td>
           
            <div style='margin-left: auto; margin-right: auto; width: 400px'>
                <fieldset><legend>Recredential Notification</legend>
                    Clicking the send button below will e-mail a notification of a requirement to recredential.<br /><br />
                E-Mail: <input type='text' style='width: 285px; background-color: lightcyan; padding: 3px; border-radius: 3px; color: #333; border: 1px solid #aaf' name='credentialing_email' id='credentialing_email-{$window_id}' value='' /><br /><br />
                <input type='button' onclick='Argus.provider.recred.request("{$window_id}")' value=' Send E-Mail ' />
                </fieldset>
            </div>
            
        </td>
    </tr>
    <tr>
        <td style="background-color: #333; height: 25px">
            &nbsp;
        </td>
    </tr>
</table>

