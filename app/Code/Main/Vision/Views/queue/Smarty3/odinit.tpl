<style type='text/css'>
    .vision_od_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.50%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .vision_od_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.50%; margin-right: .1%; height: 92%; margin-top: 0px; overflow: auto; position: relative;
    }
    .vision_od_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.50%; height: 25px;
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

<div class='vision_od_queue_header'>
    {if ($user->userHasRole('HEDIS Vision Manager'))}
    <img src="/images/vision/reassign.png" onclick="Argus.vision.od.reassign()" style="height: 24px; cursor: pointer; margin-left: 5px; float: left" title="Re-assign scanning forms..." />
    {/if}
    OD Scanning Form Q 
</div>
<div class='vision_od_queue_header'>
<img src="/images/vision/vision_form_icon.png" title="Create a new retinal consultation" style="float: right; margin-right: 5px; height: 20px; cursor: pointer"  onclick='Argus.vision.consultation.create()'/>    
    OD Screening Form Q
</div>
<div class='vision_od_queue_header'>
    Staging Queue
</div>    
<br />
<div class='vision_od_queue_body' id="vision_scanning_queue">
</div>
<div class='vision_od_queue_body' id="vision_screening_queue">
</div>
<div class='vision_od_queue_body' id="vision_od_staging_queue">
</div>    
<div class='vision_od_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='scanning-from-row'></span>-<span id='scanning-to-row'></span> of <span id='scanning-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='scanning-previous' id='scanning-previous'  style='' class='vision_pagination_control' value='<' />
                <input type='button' name='scanning-first' id='scanning-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='scanning-last' id='scanning-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='scanning-next' id='scanning-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='scanning-page'></span> of <span id='scanning-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='vision_od_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='screening-from-row'></span>-<span id='screening-to-row'></span> of <span id='screening-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='screening-previous' id='screening-previous'  style='' class='vision_pagination_control' value='<' />
                <input type='button' name='screening-first' id='screening-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='screening-last' id='screening-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='screening-next' id='screening-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='screening-page'></span> of <span id='screening-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='vision_od_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='od_staging-from-row'></span>-<span id='od_staging-to-row'></span> of <span id='od_staging-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='od_staging-previous' id='od_staging-previous'  style='' class='vision_pagination_control' value='<' />
                <input type='button' name='od_staging-first' id='od_staging-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='od_staging-last' id='od_staging-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='od_staging-next' id='od_staging-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='od_staging-page'></span> of <span id='od_staging-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('screening',function (page,rows) {
        Argus.vision.od.refresh($E('vision_screening_queue'),'screening',page,rows);
    },1,20);
    Pagination.init('scanning',function (page,rows) {
        Argus.vision.od.refresh($E('vision_scanning_queue'),'scanning',page,rows);
    },1,20);    
    Pagination.init('od_staging',function (page,rows) {
        Argus.vision.od.refresh($E('vision_od_staging_queue'),'od_staging',page,rows);
    },1,20);
</script>
