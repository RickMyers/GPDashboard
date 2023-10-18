<style type="text/css">
    .new-app-layer {
        width: 700px; border: 1px solid transparent; padding: 10px;  color: #333; background-color: ghostwhite; margin-left: auto; margin-right: auto
    }
    .new-app-field {
        background-color: lightcyan; border: 1px solid #aaf; padding: 2px; border-radius: 2px; width: 90%;
    }
    .new-app-fieldname {
        font-family: monospace; font-size: .9em; letter-spacing: 1px; position: relative
    }
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div class="new-app-layer">
                <form name="new-app-form" id="new-app-form-{$window_id}" onsubmit="return false">
                    <fieldset style="border-bottom: 1px solid #333"><legend style="border-bottom: 1px solid #333">Create A New Desktop App</legend>

                        <div style="width: 47.5%; display: inline-block">                        
                            <input type="text" name="new_app_name" id="new_app_name_{$window_id}" class="new-app-field"  style="width: 100%" /><br />
                            <span class="new-app-fieldname">App Name</span><br /><br />
                        </div>
                            
                        <div style="width: 47.5%; display: inline-block; text-align: center; vertical-align: top">
                            <input type="button" name="create_new_app_button" id="create_new_app_button_{$window_id}" value='Create!' style="vertical-align: top; width: 200px; height: 50px; background-color: cornflowerblue; font-size: 2em; color: ghostwhite; font-weight: bold" />                                
                        </div>    
                        
                        <span class="new-app-fieldname">Description</span><br />
                        <textarea name="new_app_description" id="new_app_description_{$window_id}" class="new-app-field" style="width: 90%; height: 40px"></textarea><br /><br />
                        <div style="width: 47.5%; display: inline-block">
                            <input type="file" name="new_app_icon" id="new_app_icon_{$window_id}" class="new-app-field" /><br />
                            <span class="new-app-fieldname">App Icon</span><br /><br />
                        </div>
                         
                        <div style="width: 47.5%; display: inline-block">    
                            <input type="file" name="new_app_minimized" id="new_app_minimized_{$window_id}" class="new-app-field" /><br />
                            <span class="new-app-fieldname">Minimized Icon</span><br /><br />
                        </div>

                        <div style="width: 47.5%; display: inline-block">
                            <input type="text" name="new_app_uri" id="new_app_uri_{$window_id}" class="new-app-field" /><br />
                            <span class="new-app-fieldname">App URI</span><br /><br />
                        </div>
                        
                        <div style="width: 47.5%; display: inline-block">
                            <input type="text" name="new_app_component" id="new_app_component_{$window_id}" class="new-app-field" /><br />
                            <span class="new-app-fieldname">Component (optional)</span><br /><br />
                        </div>
                        
                            <fieldset><legend>Who can use this app</legend>
                                {foreach from=$roles->fetch() item=role}
                                    <div style="display: inline-block; margin-right: 10px;">
                                        <label><input type="checkbox" role_id="{$role.id}" value="{$role.id}">&nbsp;{$role.name}</label>
                                    </div>
                                {/foreach}
                            </fieldset>
                    </fieldset>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    (function () {
        var xx = new EasyEdits('','new-app-{$window_id}');
        xx.fetch("/edits/dashboard/newapp");
        xx.process(xx.getJSON().replace(/&&win_id&&/g,'{$window_id}'));
    })();
</script>
