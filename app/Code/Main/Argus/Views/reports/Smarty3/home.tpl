<style type="text/css">
    .report_selection {
        padding: 2px; background-color: lightcyan; color: #333
    }
</style>


<form name="report_module_select_form" id="report_module_select_form" onsubmit="return false">
    <select name="namespace" id="report_module_namespace" class="report_selection">
        <option value=""> Please select from below... </option>
        {foreach from=$modules->fetch() item=module}
            <option value="{$module.namespace}" title="{$module.title}">[{$module.namespace|ucfirst}] - {$module.title}</option>
        {/foreach}
    </select><br />
    Please select the component to report on<br /><br />
    <div id="available_reports">
    </div>
</form>
    
<script type="text/javascript">
    (function () {
        $('#report_module_namespace').on("change",function (evt) {
            (new EasyAjax('/argus/reports/available')).add('namespace',this.value).then(function (response) {
                $('#available_reports').html(response);
            }).post();
        });
    })();
</script>