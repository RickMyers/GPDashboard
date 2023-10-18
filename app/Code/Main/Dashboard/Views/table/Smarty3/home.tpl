<div id="table_select_and_edit_nav_{$window_id}">
</div>
<script type="text/javascript">
    (function () { 
        var tabs = new EasyTab('table_select_and_edit_nav_{$window_id}',140);
        tabs.add('Select &amp; View',false,'table_select_tab_{$window_id}');
        tabs.add('General Query',false,'general_query_tab_{$window_id}');
        tabs.add('Backup &amp; Restore',false,'backup_and_restore_tab_{$window_id}');
        tabs.tabClick(0);
        Desktop.window.list['{$window_id}']._scroll(true);
    })();
</script>
<div id="table_select_tab_{$window_id}" style="padding: 10px">
    <style type="text/css">
    </style>
    <form name="table_select_and_edit_form" id="table_select_and_edit_form_{$window_id}" onsubmit="return false">
        <div style="float: right; margin-right: 10px">
            <select name="rows" id="rows_{$window_id}">
                <option value="" style="font-style: italic">Rows</option>
                <option value="50">50</option>
                <option value="100">100</option>
                <option value="250">150</option>
                <option value="500">500</option>
            </select>
            <select name="page" id="page_{$window_id}">
                <option value="" style="font-style: italic">Page</option>
                <option value="1">1</option>
            </select>
        </div>
        <div style="display: inline-block; margin-left: 10px">        
            <select name="namespace" id="namespace_{$window_id}">
                <option value="" style="font-style: italic">Namespace</option>
                {foreach from=$entity->namespaces() item=namespace}
                    <option value="{$namespace.namespace}">{$namespace.namespace}</option>
                {/foreach}
            </select>
            <select name="entity" id="entity_{$window_id}">
                <option value="" style="font-style: italic">Entity</option>
            </select>
        </div>
        <hr />
        <div id="table_select_query_results_{$window_id}"></div>
    </form>
                
    <script type="text/javascript">
        (function () {
            var xx = new EasyEdits('','entity-selector-{$window_id}');
            xx.fetch("/edits/dashboard/entityselect");
            xx.process(xx.getJSON().replace(/&&win_id&&/g,'{$window_id}'));
        })();    
    </script>
</div>
        
<!-- ############################################################################ -->

<div id="general_query_tab_{$window_id}">
    <style type="text/css">
    </style>
    <form name="general_query_form" id="general_query_form_{$window_id}" onsubmit="return false">
        <input type="hidden" name="window_id" id="window_id_{$window_id}" value="{$window_id}" />
        <textarea name="query" id="general_query_{$window_id}" style="width: 100%; height: 120px; background-color: lightcyan; border: 1px solid #aaf; padding: 5px; border-radius: 5px"></textarea>
        <div style="float: right; margin-right: 10px">
            <select name="rows" id="query_rows_{$window_id}">
                <option value="" style="font-style: italic">Rows</option>
                <option value="50">50</option>
                <option value="100">100</option>
                <option value="250">150</option>
                <option value="500">500</option>
            </select>
            <select name="page" id="query_page_{$window_id}">
                <option value="" style="font-style: italic">Page</option>
                <option value="1">1</option>
            </select>                
        </div>
        <input type="button" name="general_query_run_button" id="general_query_run_button_{$window_id}" value="   RUN   " />&nbsp;&nbsp;&nbsp;
        <input type="button" name="general_query_save_button" id="general_query_save_button_{$window_id}" value="   SAVE   " />&nbsp;&nbsp;&nbsp;
        
        <hr />
        <div id="general_query_form_results_{$window_id}">
        </div>
    </form>
    <script type="text/javascript">
        $('#general_query_run_button_{$window_id}').on("click",function (evt) {
            $('#general_query_form_results_{$window_id}').html('<h5>Running Query...</h5>');
            (new EasyAjax('/dashboard/table/run')).packageForm('general_query_form_{$window_id}').then(function (response) {
                $('#general_query_form_results_{$window_id}').html(response);
            }).post();
        });
        $('#general_query_save_button_{$window_id}').on("click",function (evt) {
            
        });        
    </script>
</div>
        
<!-- ############################################################################ -->

<div id="backup_and_restore_tab_{$window_id}">
    <style type="text/css">
    </style>
</div>