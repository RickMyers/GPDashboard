    <style type="text/css">
        .search-field-area {
            display: inline;
            background-color: rgba(202,202,202,.7);
            border: 1px solid rgba(50,50,50,.5);
            background-image: url(/images/dental/search2.png);
            background-repeat: no-repeat;
            background-position: 6px 2px;
            border-radius: 16px;
            padding-left: 30px;
            padding-top: 3px; padding-bottom: 4px;
            width: 260px;
        }
        .search-field {
            border: 0px; width: 230px;
            background-color: rgba(202,202,202,.1);
            color: white;
        }
         .search-field:focus { outline-width: 0; }
    </style>
    <div id="dashboard-top" style="position: relative">
        <hr style='opacity: .4' />
        <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Argus.dashboard.home()">home</span> | <span onclick="Argus.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'><i class="glyphicons glyphicons-dashboard glyph-active"></i> DASHBOARD</span> <a id="dashboard-configure-link" onclick="return false" href="#" style='font-family: monospace; font-size: .7em; letter-spacing: 2px;  color: #426D84'>configuration</a>
        <hr style='opacity: .4' />
        {foreach from=$navigation->optionsByRole() item=option}
            <div class='{$option.class}' onclick='{$option.method}' style='{$option.style}'>
                <img src='{$option.image}' style='{$option.image_style}' />
                <div style='text-align: center;'>
                    {$option.title}
                </div>
            </div>
        {/foreach}
        <div style='clear: both'></div>
        <hr style='opacity: .4' />
        <div style="clear: both"></div>
        <div id="dashboard-user-graphs">
            <div class='dashboard-graph'>
                <div id="dashboard-chart-1-label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
                <div style="height: 140px; position: relative">
                    <canvas id='dashboard-chart-1' style='width: 100%; height: 100%;'></canvas>
                </div>
            </div>
            <div class='dashboard-graph'>
                <div id="dashboard-chart-2-label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
                <div style="height: 140px; position: relative">
                    <canvas id='dashboard-chart-2' style='width: 100%; height: 100%;'></canvas>
                </div>
            </div>
            <div class='dashboard-graph' >
                <div id="dashboard-chart-3-label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
                <div style="height: 140px; position: relative">
                    <canvas id='dashboard-chart-3' style='width: 100%; height: 100%;'></canvas>
                </div>
            </div>
            <div class='dashboard-graph'>
                <div id="dashboard-chart-4-label" style="background-color: rgba(202,202,202,.3)">&nbsp;</div>
                <div style="height: 140px; position: relative">
                    <canvas id='dashboard-chart-4' style='width: 100%; height: 100%;'></canvas>
                </div>
            </div>
        </div>
        <div style='clear: both'></div>
        <hr style='opacity: .4' />
        
    </div>
    <div id="sub-container">
        <script type="text/javascript">
            var DashboardApps = [];
        </script>
        {foreach from=$apps->installed() item=app}
            <script type="text/javascript">
                
                DashboardApps[DashboardApps.length] = {
                    "id": "{$app.id}",
                    "namespace": "{$app.namespace}",
                    "name": "{$app.name}",
                    "zones": "{$app.zones}",
                    "action": "{$app.action}",
                    "setup": "{$app.setup_uri}",
                    "period": "{$app.period}",
                    "render": "{$app.render}",
                    "callback": {$app.callback},
                    "arguments": "{$app.arguments}",
                    "description": "{$app.description}"
                }
                
            </script>
            {if ($app.render == 'Y')}
                <div id='app-{$app.id}-container' class='dashboard-app-container'>
                    <div id='app-{$app.id}-header' class='dashboard-app-header'><img onclick="Argus.tools.toggle(this); $('#app-{$app.id}-body').slideToggle()" style="float: left; cursor: pointer; margin-right: 5px; height: 20px;" src="/images/dashboard/collapse.png" />
                        <div style="float: right">
                            {if ($app.widget)}
                                {assign var=widget value=Argus::fetchWidget($app.widget)}
                                {$widget}
                            {/if}
                        </div>    {$app.name}
                    </div>
                    <div id='app-{$app.id}-body' class='dashboard-app-body' style="position: relative">
                                 Waiting to load...
                    </div>
                </div>
            {/if}
        {foreachelse}
            No apps :-(   You should try some...
        {/foreach}
        <div style='clear: both'></div>
    </div>
    <script type='text/javascript'>
        if (!Argus.dashboard.loaded) {
            Argus.dashboard.loaded = true;  //this prevents multiple loadings of the resizer to the resize event
            Argus.templates.load(); //fetch all of the dynamic templates for the polls
        }
        var DashboardResizer = (function (apps) {
            var zone            = 250;   //default size of a zone
            var number_of_zones = 6;
            return function () {
                let width = $('#sub-container').width();
                let calculated_zone_width = Math.floor(width/number_of_zones);
                let zone_width = (calculated_zone_width > zone) ? calculated_zone_width : zone;
                let app_dimension = '';
                for (let i=0; i<apps.length; i++) {
                    if (apps[i].render==='Y') {
                        app_dimension = apps[i].zones.split('x');
                        $("#app-"+apps[i].id+"-container").width(app_dimension[0] * zone_width);
                        if ($E("app-"+apps[i].id+"-header")) {
                            $("#app-"+apps[i].id+"-body").height(app_dimension[1]*zone -$E("app-"+apps[i].id+"-header").offsetHeight );
                        }
                    }
                }


            }
        })(DashboardApps);
        $(window).resize(DashboardResizer).resize();
        for (var i=0; i< DashboardApps.length; i++) {
            (function (app) {
                (new EasyAjax(app.setup)).then(function (response) {
                    $("#app-"+app.id+"-body").html(response);
                }).post(true);
            })(DashboardApps[i]);
            var f = (function (app) {
                    return function (response) {
                         $("#app-"+app.id+"-body").html(response);
                    }
            })(DashboardApps[i]);
            Heartbeat.register(DashboardApps[i].namespace,"app-"+DashboardApps[i].id+"-body",DashboardApps[i].action,DashboardApps[i].callback,DashboardApps[i].period,DashboardApps[i].arguments.split(','));
        }
        $('#dashboard-configure-link').on("click",function () {
            (new EasyAjax('/dashboard/user/configure')).add('user_id','{$user->getId()}').then(function (response) {
                $('#container').html(response);
            }).post();
        });
        
        var options = {
            labels: {
                // This more specific font property overrides the global property
                fontColor: '#ffffff'
            },            
            legend: {
                labels: {
                    // This more specific font property overrides the global property
                    fontColor: '#ffffff'
                }
            }
        };
        
        {assign var=charts value=$chart_library->users(false,false,'home',{$member->getId()})}
        {foreach from=$charts item=chart}
            {if ($chart['resource'])}
                {assign var=chart_data value=$chart_library->resource($chart)}
            {else}
                {assign var=chart_data value=$chart_library->render($chart)}
            {/if}
            {if ($chart.layer)}
            $('#{$chart.layer}-label').html("{$chart.description}");
            {/if}
            {$chart_data|unescape}
        {/foreach}
    </script>