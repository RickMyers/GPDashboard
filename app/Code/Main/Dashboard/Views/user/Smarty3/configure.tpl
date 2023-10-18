<style type='text/css'>
    .app {
         padding: 20px 10px 10px 10px; border: 1px solid ghostwhite; border-radius: 30px; float: left; width: 140px; height: 140px; margin-right: 25px; margin-bottom: 25px; text-align: center
    }
    .app:hover {
        background-color: rgba(202,202,202,.7); cursor: pointer
    }
    .available_app {
        background-color: rgba(202,202,202,.15)
    }
    .installed_app {
        background-color: rgba(255,255,255,.5)
    }
</style>
<div id="dashboard-top" style="position: relative">
    <hr style='opacity: .4' />
    <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Landing.dashboard.home()">home</span> | <span onclick="Landing.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'>DASHBOARD Configuration</span>
    <hr style='opacity: .4' />
    <form name="dashboard-chart-configure-form" id="dashboard-chart-configure-form" onsubmit="return false">
        <input type='hidden' name='namespace'   id='namespace'  value='dashboard' />
        <input type='hidden' name='controller'  id='controller' value='user' />
        <input type='hidden' name='action'      id='action'     value='home' />
        <fieldset><legend style="color: ghostwhite">Charts</legend>
            {assign var=charts value=$chart_library->fetch(false,false,'home')}
            {assign var=available value=$available_charts->inventory()}
            <div style='padding: 20px'>
            {foreach from=$charts item=chart}
                <div style='white-space: nowrap; overflow: hidden;'>
                    <div style='min-width: 250px; background-color: rgba(202,202,202,{cycle values=".1,.2"}); width: 30%; overflow: hidden; margin-right: 2px; display: inline-block'>
                        {$chart.description}
                    </div>
                    <div style='min-width: 150px; background-color: rgba(202,202,202,{cycle values=".1,.2"}); width: 30%; overflow: hidden; display: inline-block'>
                        <select id="{$chart.layer}" name="{$chart.layer}" style="width: 100%; color: #333; background-color: lightcyan; padding: 2px; border: 1px solid #aaf">
                            <option value="">Choose a chart</option>
                            {assign var=control value=false}
                            {foreach from=$available item=option}
                                {if (($control != $option.package) && ($control != false))}
                                </optgroup>
                                {/if}
                                {if ($control != $option.package)}
                                    <optgroup label="{$option.package}">
                                    {assign var=control value=$option.package}
                                {/if}
                                {if ($option.chart_id)}
                                <option title="{$option.description}" value="{$option.chart_id}">{$option.name}</option>
                                {/if}
                            {/foreach}
                            </optgroup>
                        </select>
                    </div>
                </div>
            {/foreach}
            <br /><input type="submit" value=" Set " style="color: #333; padding: 3px 10px; border: 1px solid silver; font-size: .9em; background-color: seashell; border-radius: 3px" />
            </div>
        </fieldset>
    </form>
    <form name="dashboard-app-configure-form" id="dashboard-app-configure-form" onsubmit="return false">
        <fieldset><legend style="color: ghostwhite">Apps</legend>
            <div style='padding: 20px'>
                <u>Available Apps</u>:<br /><br />
                <div style='width: 1200px'>
                {foreach from=$apps->availableAndInstalled() item=app}
                <div app_id='{$app.id}' class='app {if ($app.app_id != '')}installed_app{else}available_app{/if}' value='{if ($app.app_id != '')}1{else}0{/if}' onclick='Argus.configuration.app(this)'>
                    <table style='width: 100%; height: 100%'>
                        <tr>
                            <td style='text-align: center'>
                                <img src="{$app.icon}" style="height: 50px" /><br /><br />
                                {$app.name}
                            </td>
                        </tr>
                    </table>
                </div>
                {/foreach}
                </div>
            </div>
        </fieldset>
        <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" value=" Select " style="color: #333; padding: 3px 10px; border: 1px solid silver; font-size: .9em; background-color: seashell; border-radius: 3px" />
    </form>
    <br /><br /><br /><br /><br />
</div>
<script type="text/javascript">
    {assign var=user_charts value=$chart_library->users(false,false,home,Environment::whoAmI())};
        {foreach from=$user_charts item=chart}
            $('#{$chart['layer']}').val('{$chart['chart_id']}');
        {/foreach}
    Form.intercept($E('dashboard-chart-configure-form'),false,'/dashboard/user/save',false,function (response) { 
        window.location.reload();
    } );
    Form.intercept($E('dashboard-app-configure-form'),false,'/dashboard/user/appsave',false,function (response) { 
        window.location.reload();
    } );
</script>
