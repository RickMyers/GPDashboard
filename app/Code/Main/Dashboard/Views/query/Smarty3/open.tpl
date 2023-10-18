<style type="text/css">
    .query-column {
        display: inline-block; width: 50%; box-sizing: border-box; padding: 5px; overflow: auto; white-space: nowrap
    }
</style>
<form name="general_query_form" id="general_query_form-{$window_id}" onsubmit="return false">
    <input type="hidden" name="query_id" value="" id="query_id-{$window_id}" />
    <input type="hidden" name="query_desc" value="" id="query_desc-{$window_id}" />
    <div id="query_edit-{$window_id}" style="position: relative">
        <textarea name="query" id="query-{$window_id}" style="width: 100%; height: 100%; padding: 2px; background-color: lightcyan; color: #333; border: 1px solid #333"></textarea>
        <img id="query_exec_icon-{$window_id}" src="/images/vision/exec_query.png" style="cursor: pointer; height: 40px; position: absolute; bottom: 5px; right: 70px" title="Run Query" />
        <img id="query_save_icon-{$window_id}" src="/images/vision/save_query.png" style="cursor: pointer; height: 40px; position: absolute; bottom: 5px; right: 5px" title="Save Query"/>        
    </div>
    <div id="query_columns-{$window_id}" style="position: relative">
        <div class="query-column" id="query_list-{$window_id}" style="border-right: 1px solid #333"></div>
        <div class="query-column" id="query_results-{$window_id}"></div>
    </div>
</form>
<script type="text/javascript">
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = function () {
            var c = win.content.height();
            $('#query_edit-{$window_id}').height(Math.round(c*.29));
            $('.query-column').height(Math.round(c*.7));
        }
        function listQueries() {
            (new EasyAjax('/dashboard/query/list')).add('rows',20).add('page',1).add('window_id','{$window_id}').then(function (response) {
                $('#query_list-{$window_id}').html(response);
            }).post();            
        }
        function saveQuery() {
            var desc;
            if (desc = prompt("Set the description",$('#query_desc-{$window_id}').val())) {
                $('#query_desc-{$window_id}').val(desc);
                (($('#query_id-{$window_id}').val()) ?  (new EasyAjax('/dashboard/query/save')).add('query_id',$('#query_id-{$window_id}').val()) : (new EasyAjax('/dashboard/query/save'))).add('query',$('#query-{$window_id}').val()).add('description',desc).then(function (response) {
                    if (response) {
                        $('#query_id-{$window_id}').val(response);
                    }
                    listQueries();
                }).post();
            } else {
                alert("Can't save without a description");
            }
        }
        function execQuery() {
            (new EasyAjax('/dashboard/query/exec')).add('query',$('#query-{$window_id}').val()).then(function (response) {
                $('#query_results-{$window_id}').html(response);
            }).post();
        }
        $('#query_save_icon-{$window_id}').on('click',saveQuery);
        $('#query_exec_icon-{$window_id}').on('click',execQuery);
        listQueries();
    })();
</script>