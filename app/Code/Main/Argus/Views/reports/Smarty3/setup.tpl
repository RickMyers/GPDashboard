{assign var=layout value=$reports->setup()}
<style type="text/css">
    .report_selection_fields {
        padding: 10px;
    }
    .report_selection_row {
        overflow: hidden; white-space: nowrap; background-color: rgba(202,202,202,.1)
    }
    .report_selection_cell {
        display: inline-block; width: 19.5%; margin-right: 2px
    }    
    .report_component_field {
        padding: 2px; padding-left: 20px;background-color: rgba(202,202,202,.3)
    }
    .report_component_input {
        background-color: lightcyan; padding: 2px; border: 1px solid #aaf; border-radius: 2px; font-size: 1em; width: 100%; 
    }
    .report_component_title {
        color: #333; font-size: .95em;  font-family: monospace; letter-spacing: 1px; background-color: rgba(202,202,202,.3);
    }

</style>
{assign var=cmp_cnt value=0}
<form name="dashboard_reports_form" id="dashboard_reports_form-{$window_id}" action="/argus/reports/export" method="POST" onsubmit="return false" >
    <input type="hidden" name="json_arguments" id="json_arguments-{$window_id}" value="" />
    <input type="hidden" name="namespace" id="namespace-{$window_id}" value="" />
    <input type="hidden" name="method" id="method-{$window_id}" value="" />
    <input type="hidden" name="report" id="report-{$window_id}" value="" />
    <script type="text/javascript">
        Argus.reports.fields['{$window_id}'] = [];
    </script>
    <fieldset class="report_selection_fields" id="report_selection_area-{$window_id}"><legend>Report Selection Criteria</legend>
        <div class="report_selection_row">
{foreach from=$layout item=component key=component_name}
    {assign var=cmp_cnt value=$cmp_cnt+1}
    <script type="text/javascript">
        Argus.reports.fields['{$window_id}'][Argus.reports.fields['{$window_id}'].length] = '{$component.resource.id}';
        //alert('{$component.name}')
    </script>
    {if ($component.type == "Select")}
        <div class="report_selection_cell component_width">
            <div class="report_component_title">
            {$component.name}
            </div>
            <div class="report_component_field">
                <select class="report_component_input" name="{$component.resource.id}" id="{$component.resource.id}-{$window_id}" {if (isset($component.resource.style))}style="{$component.resource.style}"{/if}>
                    <option value=""> </option>
                </select>
            </div>
        </div>
    {if (isset($component.resource.action))}
        <script type="text/javascript">
            (function () {
                {if (!isset($component.resource.on))} 
                    var ao = new EasyAjax('{$component.resource.action}');
                    {if (isset($component.resource.on))}
                        ao.add('{$component.resource.on}',$('#{$component.resource.on}-{$window_id}').val());
                    {/if}
                    ao.then(function (response) {
                        response = JSON.parse(response);
                         var rows = [{ "text": " ", "value": ""}];
                        for (var i=0; i<response.length; i++) {
                            rows[rows.length] = {
                                "text": response[i].{$component.resource.text},
                                "value": response[i].{$component.resource.value}{if (isset($component.resource.title))},
                                "title": response[i].{$component.resource.title}
                                {/if}
                            }
                        }
                        EasyEdits.populateSelectBox('{$component.resource.id}-{$window_id}',rows);
                    }).post();
                {/if}
            })();
        </script>
    {/if}
    {if (isset($component.resource.on))}
        <script type='text/javascript'> 
            $('#{$component.resource.on}-{$window_id}').on('change',function (evt) {
                if (this.value) {
                    var ao = new EasyAjax('{$component.resource.action}');
                    ao.add('{$component.resource.on}',this.value)
                    ao.then(function (response) {
                        response = JSON.parse(response);
                        var rows = [{ "text": " ", "value": ""}];
                        for (var i=0; i<response.length; i++) {
                            rows[rows.length] = {
                                "text": response[i].{$component.resource.text},
                                "value": response[i].{$component.resource.value}{if (isset($component.resource.title))},
                                "title": response[i].{$component.resource.title}
                                {/if}
                            }
                        }
                        EasyEdits.populateSelectBox('{$component.resource.id}-{$window_id}',rows);                    
                    }).post();
                }
            })
        </script>
    {/if}
    {if (isset($component.content))}
        <script type="text/javascript">
            (function () {
                var json = `
                    {$component.content}
                `;
                EasyEdits.populateSelectBox('{$component.resource.id}-{$window_id}',json);
            })();
        </script>
    {/if}
{elseif ($component.type == "Date")}
        <div class="report_selection_cell component_width">
            <div class="report_component_title">
            {$component.name}
            </div>
            <div class="report_component_field">
                <input type="text" class="report_component_input" name="{$component.resource.id}" id="{$component.resource.id}-{$window_id}" {if (isset($component.resource.style))}style="{$component.resource.style}"{/if} />
            </div>
        </div>
        <script type="text/javascript">
            (function () {
                $('#{$component.resource.id}-{$window_id}').datepicker();
            })();
        </script>
{elseif ($component.type == "Text")}
        <div class="report_selection_cell component_width">
            <div class="report_component_title">
            {$component.name}
            </div>
            <div class="report_component_field">
                <input type="text" class="report_component_input" name="{$component.resource.id}" id="{$component.resource.id}" {if (isset($component.resource.style))}style="{$component.resource.style}"{/if}/>
            </div>
        </div>
        <script type="text/javascript">
            (function () {
            })();
        </script>
{elseif ($component.type == "Checkbox")}    
    @TODO
{elseif ($component.type == "Radio")}    
    @TODO
{elseif ($component.type == "Hidden")}
    {*  Output HTML for input type = Hidden *}
{/if}
{/foreach}
<style type='text/css'>
    .component_width {
        width: {$reports->determineComponentWidth($cmp_cnt)}%
    }
</style>
    </div>
    <br />
    <div>   
        <input type="button" id="argus_report_run-{$window_id}" value="  Run Report  " />
        <input type="button" id="argus_report_export-{$window_id}" value="  Export CSV  " style="float: right" />
    </div>
    <script type="text/javascript">
        $('#argus_report_run-{$window_id}').on('click',function (evt) {
            var ao = new EasyAjax('/argus/reports/display');
            ao.add('method','{$reports->getMethod()}').add('namespace','{$namespace}').add('report','{$report}');
            $('#report_results-{$window_id}').html('<h3>Running Report... Please Wait</h3>');
            for (var i=0; i<Argus.reports.fields['{$window_id}'].length; i++) {
                ao.add(Argus.reports.fields['{$window_id}'][i],$('#'+Argus.reports.fields['{$window_id}'][i]+'-{$window_id}').val());
            }
            ao.then(function (response) {
                $('#report_results-{$window_id}').html(response);
            }).post();
         });
        $('#argus_report_export-{$window_id}').on('click',function (evt) {
            var args = {
                "method": "{$reports->getMethod()}",
                "namespace": "{$namespace}",
                "report": "{$report}"
            };
            for (var i=0; i<Argus.reports.fields['{$window_id}'].length; i++) {
                args[Argus.reports.fields['{$window_id}'][i]] = $('#'+Argus.reports.fields['{$window_id}'][i]+'-{$window_id}').val();
            }
            $('#namespace-{$window_id}').val('{$namespace}');
            $('#report-{$window_id}').val('{$report}');
            $('#method-{$window_id}').val('{$reports->getMethod()}');
            $('#json_arguments-{$window_id}').val(JSON.stringify(args));
            document.getElementById('dashboard_reports_form-{$window_id}').submit();
         });         
    </script>
    <hr />
    </fieldset>
    <div id="report_results-{$window_id}" style="overflow: auto">
    </div>
</form>
<script type="text/javascript">
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            $('#report_results-{$window_id}').height(win.content.height() - $E('report_selection_area-{$window_id}').offsetHeight);
        }
    })();
</script>

