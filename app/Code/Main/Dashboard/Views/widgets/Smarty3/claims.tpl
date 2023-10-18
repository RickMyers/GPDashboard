<form name='claims-analyzer-form' id='claims-analyzer-form-{$window_id}' onsubmit='return false'>
    <br />
    <div class=''>
        <input type='file' class='' style='background-color: lightcyan; padding: 2px; border: 1px solid #aaf; width: 350px; display: inline-block' name='claims_file' id='claims_file-{$window_id}' /> <button style="padding: 2px" id='claims-analyze-button-{$window_id}'>Submit</button>
    </div>
    <div style='font-size: .9em'>
        Claims File To Analyze
    </div>
</form>
<hr />
<div id='claims-analyzer-results-{$window_id}'>
</div>
<script type="text/javascript">
    $('#claims-analyze-button-{$window_id}').on('click',function (e) {
        (new EasyAjax('/dashboard/claims/analyze')).addFiles('claims_file',$E('claims_file-{$window_id}')).then(function (response) {
            $('#claims-analyzer-results-{$window_id}').html(response);
        }).post();
    });
</script>