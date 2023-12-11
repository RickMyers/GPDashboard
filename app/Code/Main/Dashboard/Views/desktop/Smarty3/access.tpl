<style type="text/css">
    .grant-access-widget {
        width: 700px; padding: 20px; border: 1px solid #333; border-radius: 10px; margin-left: auto; margin-right: auto
    }
    .grant-access-element {
        background-color: lightcyan; width: 225px; border: 1px solid #aaf; padding: 2px
    }
    .grant-access-desc {
        margin-bottom: 20px; font-family: monospace; letter-spacing: 2px; color: #333; font-size: .95em
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div class="grant-access-widget">
                <form name="desktop_grant_access_form" id="desktop_grant_access_form-{$window_id}">
                    <fieldset><legend>Grant Access Instructions</legend>
                        Choose an app from the list below, and a role, and then click the 'Grant Access' button to add that app to the desktop of every person who has that role.  It is best to be more restrictive... don't grant access if you are not absolutely sure
                        <select class="grant-access-element" name="app_id" id="app_id-{$window_id}">
                            <option value=''> </option>
                            {foreach from=$apps->fetch() item=app}
                                <option value='{$app.id}'> {$app.app} </option>
                            {/foreach}
                        </select>
                        <div class='grant-access-desc'>
                            Desktop App
                        </div>
                        <select class="grant-access-element" name="role_id" id="role_id-{$window_id}">
                            <option value=''> </option>
                            {foreach from=$roles->fetch() item=role}
                                <option value='{$role.id}'> {$role.name} </option>
                            {/foreach}                            
                        </select>
                        <div class='grant-access-desc'>
                            User Role
                        </div>
                        <input type="button" name="grant_access_submit" id="grant_access_submit-{$window_id}" value="  Grant Access  " /><br />
                    </fieldset>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    (function () {
        $('#grant_access_submit-{$window_id}').on('click',function (evt) {
            (new EasyAjax('/dashboard/desktop/grant')).addForm('desktop_grant_access_form-{$window_id}').then(function (response) {
                alert(response);
            }).post();
        });
    })();
</script>
