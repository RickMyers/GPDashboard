
<style type='text/css'>
    .vision_tech_completed_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.5%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .vision_tech_completed_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.5%; margin-right: .1%; height: 355px; margin-top: 0px; overflow: auto;
    }
    .vision_tech_completed_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.5%; height: 25px;
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
<div class='vision_tech_completed_queue_header'>
    COMPLETED-Q
</div>
<br />
<div class='vision_tech_completed_queue_body' id="vision-tech_completed-queue">
</div>
<br />
<div class='vision_tech_completed_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='tech_completed-from-row'></span>-<span id='tech_completed-to-row'></span> of <span id='tech_completed-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='tech_completed-previous' id='tech_completed-previous' style='' class='vision_pagination_control' value='<' />
                <input type='button' name='tech_completed-first' id='tech_completed-first' style='' class='vision_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='tech_completed-last' id='tech_completed-last' style='' class='vision_pagination_control' value='>>' />
                <input type='button' name='tech_completed-next' id='tech_completed-next' style='' class='vision_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='tech_completed-page'></span> of <span id='tech_completed-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('tech_completed',function (page,rows) {
       Argus.vision.tech.refresh($E('vision-tech_completed-queue'),'tech_completed',page,rows);
    },1,10);
</script>
