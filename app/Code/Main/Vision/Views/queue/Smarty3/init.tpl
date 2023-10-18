<style type='text/css'>
    .vision_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .vision_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; margin-right: .1%; height: 355px; margin-top: 0px; overflow: auto; position: relative;
    }
    .vision_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 32.9%; height: 25px;
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

<div class='vision_queue_header'>
    <img src="/images/vision/import.png" style="cursor: pointer; height: 20px; float: left" onclick="Argus.vision.member.importList()" title="Import Member List" />
    INBOUND-Q
</div>
<div class='vision_queue_header'>
<img src="/images/vision/training_video.png" style="height: 26px; background: #4076AE; float:left; cursor: pointer; margin-right: 15px; position: relative; top: -2px;" title="Training Webinar" onclick="Argus.vision.training.webinar('/vision/pcp/training')"/>    
<img src="/images/vision/vision_form_icon.png" title="Create a new retinal consultation" style="float: right; margin-right: 5px; height: 20px; cursor: pointer"  onclick='Argus.vision.consultation.create()'/>    
    STAGING-Q
</div>
<div class='vision_queue_header'>
    OUTBOUND-Q
</div>    
<br />
<div class='vision_queue_body' id="vision_inbound_queue">
</div>
<div class='vision_queue_body' id="vision_staging_queue">
</div>
<div class='vision_queue_body' id="vision_outbound_queue">
</div>    
<div class='vision_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='inbound-from-row'></span>-<span id='inbound-to-row'></span> of <span id='inbound-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='inbound-previous' id='inbound-previous'  style='' class='vision_pagination_control' value='<' />
                <input type='button' name='inbound-first' id='inbound-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='inbound-last' id='inbound-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='inbound-next' id='inbound-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='inbound-page'></span> of <span id='inbound-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='vision_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='staging-from-row'></span>-<span id='staging-to-row'></span> of <span id='staging-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='staging-previous' id='staging-previous'  style='' class='vision_pagination_control' value='<' />
                <input type='button' name='staging-first' id='staging-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='staging-last' id='staging-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='staging-next' id='staging-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='staging-page'></span> of <span id='staging-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='vision_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='outbound-from-row'></span>-<span id='outbound-to-row'></span> of <span id='outbound-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='outbound-previous' id='outbound-previous'  style='' class='vision_pagination_control' value='<' />
                <input type='button' name='outbound-first' id='outbound-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='outbound-last' id='outbound-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='outbound-next' id='outbound-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='outbound-page'></span> of <span id='outbound-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('staging',function (page,rows) {
        Argus.vision.refresh($E('vision_staging_queue'),'staging',page,rows);
    },1,10);
    Pagination.init('inbound',function (page,rows) {
        Argus.vision.refresh($E('vision_inbound_queue'),'inbound',page,rows);
    },1,10);    
    Pagination.init('outbound',function (page,rows) {
        Argus.vision.refresh($E('vision_outbound_queue'),'outbound',page,rows);
    },1,10);
</script>