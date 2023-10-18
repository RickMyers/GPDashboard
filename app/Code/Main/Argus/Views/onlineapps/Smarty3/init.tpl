<style type='text/css'>
    .online_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 24.25%; height: 5%;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .3%
    }
    .online_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 24.25%; margin-right: .3%; 
        height: 84.3%; margin-top: 0px; overflow: auto;
    }
    .online_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 24.25%; height: 7%;
        color: navy; text-align: center; margin-bottom: 0px; margin-right: .3%
    }
    .online_pagination_control {
        padding: 2px 5px;
    }
</style>

<div class='online_queue_header'>
    <img src="/images/ehealth/updates.png" style="height: 18px; position: relative; float: right; margin-right: 5px; cursor: pointer" onclick="Argus.online.applications.fetch()" id="online-application-fetch-icon"/>
    New Applications
</div>
<div class='online_queue_header'>
    In-Progress Applications
</div>
<div class='online_queue_header'>
    Errored Applications
</div>
<div class='online_queue_header'>
    Completed Applications
</div>

<br />
<div class='online_queue_body' id="online-new-application-queue">
</div>
<div class='online_queue_body' id="online-inprogress-application-queue">
</div>
<div class='online_queue_body' id="online-errored-application-queue">
</div>
<div class='online_queue_body' id="online-completed-application-queue">
</div>
<div class='online_queue_footer' >
    <table width='100%'>
        <tr>
            <td>
                <span id='oainq-from-row'></span>-<span id='oainq-to-row'></span> of <span id='oainq-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='oainq-previous' id='oainq-previous' style='' class='online_pagination_control' value='<' />
                <input type='button' name='oainq-first' id='oainq-first' style='' class='online_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='oainq-last' id='oainq-last' style='' class='online_pagination_control' value='>>' />
                <input type='button' name='oainq-next' id='oainq-next' style='' class='online_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='oainq-page'></span> of <span id='oainq-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='online_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='oaipq-from-row'></span>-<span id='oaipq-to-row'></span> of <span id='oaipq-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='oaipq-previous' id='oaipq-previous' style='' class='online_pagination_control' value='<' />
                <input type='button' name='oaipq-first' id='oacaq-first' style='' class='online_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='oaipq-last' id='oaipq-last' style='' class='online_pagination_control' value='>>' />
                <input type='button' name='oaipq-next' id='oaipq-next' style='' class='online_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
               <span id='oaipq-page'></span> of <span id='oaipq-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='online_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='oaerr-from-row'></span>-<span id='oaerr-to-row'></span> of <span id='oaerr-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='oaerr-previous' id='oaerr-previous' style='' class='online_pagination_control' value='<' />
                <input type='button' name='oaerr-first' id='oaerr-first' style='' class='online_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='oaerr-last' id='oaerr-last' style='' class='online_pagination_control' value='>>' />
                <input type='button' name='oaerr-next' id='oaerr-next' style='' class='online_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
               <span id='oaerr-page'></span> of <span id='oaerr-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='online_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='oacaq-from-row'></span>-<span id='oacaq-to-row'></span> of <span id='oacaq-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='oacaq-previous' id='oacaq-previous' style='' class='online_pagination_control' value='<' />
                <input type='button' name='oacaq-first' id='oacaq-first' style='' class='online_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='oacaq-last' id='oacaq-last' style='' class='online_pagination_control' value='>>' />
                <input type='button' name='oacaq-next' id='oacaq-next' style='' class='online_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
               <span id='oacaq-page'></span> of <span id='oacaq-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('oainq',function (page,rows) {
       Argus.online.refresh($E('online-new-application-queue'),'oainq',page,rows);
    },1,14);
    Pagination.init('oaipq',function (page,rows) {
       Argus.online.refresh($E('online-inprogress-application-queue'),'oaipq',page,rows);
    },1,14);    
    Pagination.init('oacaq',function (page,rows) {
       Argus.online.refresh($E('online-completed-application-queue'),'oacaq',page,rows);
    },1,14);
    Pagination.init('oaerr',function (page,rows) {
       Argus.online.refresh($E('online-errored-application-queue'),'oaerr',page,rows);
    },1,14);    
</script>