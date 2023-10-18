<style type='text/css'>
    .vision_archive_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 49.5%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .vision_archive_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 49.5%; margin-right: .1%; height: 355px; margin-top: 0px; overflow: auto;
    }
    .vision_archive_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 49.5%; height: 25px;
        color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }    
    .consultation_form {
        margin: .2%; overflow: auto; background-color: lightgoldenrodyellow;  border: 1px solid #333; height: 98%;
    }
    .narrow_width {
        width: 35%;
    }
    .medium_width {
        width: 25%
    }
    .wide_width {
        width: 50%
    }
    .full_width{
        width: 100%;
    }
    .nc_row {
       overflow: hidden; white-space: nowrap; display: inline-block
    }
    .nc_cell {
        padding: 1px; display: inline-block; background-color: rgba(202,202,202,.2); margin-right: 1px; margin-bottom: 1px; overflow: hidden;
    }
    .nc_desc {
        font-family: monospace; font-size: .7em; letter-spacing: 1px; color: #333
    }
    .nc_field {
        font-family: sans-serif; color: black; font-size: .8em; padding-left: 15px
    }

    .vision_pagination_control {
        padding: 2px 5px; font-size: .8em
    }    
</style>

<div class='vision_archive_queue_header'>
    <a href='/vision/forms/export' target="_blank" style="float: left; margin-left: 5px">Export</a>
    <img src='/images/dental/snapshot.png' title="HealthPlan Snapshot" style="float: right; margin-right: 5px; height: 20px; cursor: pointer"  onclick='Argus.vision.hedis.campaign.snapshot()'/>    
    <!--img src='/images/dental/batch_claims.png' title="Batch PDF" style="float: right; margin-right: 5px; height: 20px; cursor: pointer"  onclick='Argus.vision.hedis.campaign.pdfconverter()'/-->    
    SIGNED-Q
</div>
<div class='vision_archive_queue_header'>
    
    ARCHIVED-Q
</div>
<br />
<div class='vision_archive_queue_body' id="vision-signed-queue">
</div>
<div class='vision_archive_queue_body' id="vision-archived-queue">
</div>
<br />
<div class='vision_archive_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='signed-from-row'></span>-<span id='signed-to-row'></span> of <span id='signed-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='archived-previous' id='signed-previous' style='' class='vision_pagination_control' value='<' />
                <input type='button' name='archived-first' id='signed-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='archived-last' id='signed-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='archived-next' id='signed-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='signed-page'></span> of <span id='signed-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='vision_archive_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='archived-from-row'></span>-<span id='archived-to-row'></span> of <span id='archived-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='archived-previous' id='archived-previous' style='' class='vision_pagination_control' value='<' />
                <input type='button' name='archived-first' id='archived-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='archived-last' id='archived-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='archived-next' id='archived-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='archived-page'></span> of <span id='archived-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('signed',function (page,rows) {
       Argus.vision.archive.refresh($E('vision-signed-queue'),'signed',page,rows);
    },1,10);    
    Pagination.init('archived',function (page,rows) {
       Argus.vision.archive.refresh($E('vision-archived-queue'),'archived',page,rows);
    },1,10);
</script>
