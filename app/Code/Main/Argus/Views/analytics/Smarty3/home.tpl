{assign var=user_charts value=$analytical->userCharts()}
<style type='text/css'>
    .chart-delete-icon {
        position: absolute; bottom: 0px; right: 0px; height: 40px; display: none; cursor: pointer
    }
</style>
<div id="members-top" style="position: relative">
    <hr style='opacity: .4' />
    <div style="float: right; font-size: .9em;"><span style="cursor: pointer" onclick="Landing.dashboard.home()">home</span> | <span onclick="Landing.help.home()" style="cursor: pointer">help</span></div><span style='font-size: 1.2em'>CHARTS, ANALYTICS, &amp; REPORTS</span>
    <hr style='opacity: .4' />
    <div class='dashboard-icon' onclick='Argus.analytics.home()'>
        <img src='/images/argus/analytics-icon.png' style='' />
        <div style='text-align: center;'>
            Analytics
        </div>
    </div>
    <div id="analytics-options-layer" style="padding: 4px; display: inline-block; width: 80%; border-radius: 2px; border: 1px solid transparent; vertical-align: top">
        <img src="/images/dashboard/collapse.png" style="float: left; cursor: pointer; margin-right: 5px; height: 20px;" onclick="Argus.tools.toggle(this); $('#analytics-form-layer').slideToggle(); $('.chart-delete-icon').toggle()"/> Chart Selection &amp; Sizing
        <div style="clear: both"></div>
        <div id="analytics-form-layer" style="display: none;">
            <form onsubmit="return false" name="analytics_chart_form" id="analytics_chart_form">
                <div style="padding-top: 10px; color: #333">
                    <select name="id" id="analytic-chart" style="width: 50%; display: inline-block; background-color: lightcyan; padding: 2px; border: 1px solid #aaf">
                        <option value="">Choose a chart</option>
                        {assign var=control value=false}
                        {foreach from=$available_charts->inventory() item=option}
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
                    <select name="width" id="analytic_chart_width" style="width: 20%; display: inline-block; background-color: lightcyan; padding: 2px; border: 1px solid #aaf">
                        <option value=".25"> 25% </option>
                        <option value=".50"> 50% </option>
                        <option value=".75"> 75% </option>
                        <option value="1"> 100% </option>
                    </select> 
                    <select name="alignment" id="analytic_chart_alignment" style="width: 20%; display: inline-block; background-color: lightcyan; padding: 2px; border: 1px solid #aaf">
                        <option value="left"> Left </option>
                        <option value="right"> Right </option>
                    </select>                     
                    <input type="button" value=" Add " id="analytics_add_button" style="display: inline-block" />
                </div>
                <div style="">
                    <div style="display: inline-block; width: 50%">Chart</div>
                    <div style="display: inline-block; width: 20%">Placement</div>
                    <div style="display: inline-block; width: 20%">Alignment</div>
                </div>
            </form>
        </div>
    </div>    
    
    <div style='clear: both'></div>
    <hr style='opacity: .4' />
</div>
<div id="analytics-container" style="position: relative;">
    {foreach from=$user_charts item=chart}
    <div id='analytical-chart-{$chart.id}-graph' style="display: inline-block; margin-right: 15px; background-color: rgba(55,55,55,.3); margin-top: 15px">
        <div id="analytical-chart-{$chart.id}-label" style="width: 100%; display: block; background-color: rgba(202,202,202,.3)">&nbsp;</div>
        <div id="analytical-chart-{$chart.id}-container" style="height: 140px; position: relative;">
            <canvas id='analytical-chart-{$chart.id}' style='width:100%; height: 100%; position: relative; '></canvas>
            <img src="/images/dashboard/red_x.png" class="chart-delete-icon" onclick="Argus.analytics.remove('{$chart.chart_id}')"/>
        </div>
    </div>
    {/foreach}
</div>

<script>
    $('#analytics_add_button').on('click',function () {
        (new EasyAjax('/argus/analytics/add')).addForm('analytics_chart_form').then(function (response) {
              $('#container').html(response);
        }).post();
    });    
    (function () {
        var charts = [];
        {foreach from=$user_charts item=chart}
            charts[charts.length] = {
                id: '{$chart.id}',
                graph: '#analytical-chart-{$chart.id}-graph',
                container: '#analytical-chart-{$chart.id}-container',
                label: '#analytical-chart-{$chart.id}-label',
                width: '{$chart.width}',
                alignment: '{$chart.alignment}',
                text: "{$chart.description}"
            };
        {/foreach}
        var usable_width = $('#analytics-container').width() - 100;
        var chart,container;
        for (var i=0; i<charts.length; i++) {
            $(charts[i].label).html(charts[i].text);
            container = $(charts[i].container);
            chart     = $E('analytical-chart-'+charts[i].id);   
            var w     = parseInt(usable_width*charts[i].width);  
            var h     = parseInt(w*.60);
            console.log(w+','+h);
            container.css('width',w+'px')
            container.css('height',h+"px");
            container.css('float',charts[i].alignment);
            $(charts[i].graph).css('width',w+'px','height',h+25+"px");
        }
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
        {*
        
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
        *}        
    })();

</script>