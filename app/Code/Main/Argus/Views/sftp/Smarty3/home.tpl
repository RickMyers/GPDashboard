<style type="text/css">
    .sftp_upload_layer {
        width: 700px; margin-right: auto; margin-left: auto;
    }
    .sftp_fieldset {
        padding: 10px;
    }
    .sftp_fieldset input select {
        border: 1px solid #333; color: #333; background-color: lightcyan; padding: 2px; 
    }
    
</style>
<table style="width: 100%; height: 100%">
    <tr>
        <td>
            <div class="sftp_upload_layer">
                <form name="sftp_upload_form" id="sftp_upload_form" onsubmit="return false">
                    <fieldset class="sftp_fieldset"><legend>File Upload</legend>
                        Please select the file to upload, and file destination:<br /><br />
                        <input type="file" name="sftp_file" id="sftp_file" />
                        <select name="sftp_destination" id="sftp_destination">
                            <option value="Choose location" selected disabled> </option>
                            <option value="A"> A </option>
                            <option value="B"> B </option>
                        </select>
                    </fieldset>
                </form>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript">
    (function () {
        $('#sftp_upload_form').submit(function () {
            (new EasyAjax('/argus/sftp/upload')).addFiles('sftp_file',$('#sftp_file').get()).add('destination',$('#sftp_destination').val()).then(function (response) {
                console.log(response);
            }).post();
        });
    })();
</script>