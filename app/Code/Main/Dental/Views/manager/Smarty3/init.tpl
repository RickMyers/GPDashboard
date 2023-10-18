<style type='text/css'>
    .mgrhedis_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 16.15%; height: 5%;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .mgrhedis_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 16.15%; margin-right: .1%; height: 70%; margin-top: 0px; overflow: hidden;
    }
    .mgrhedis_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 16.15%; height: 7%;
        color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .mgrhedis_pagination_control {
        padding: 2px 5px;
    }
</style>
<div class='mgrhedis_queue_header'>
    <img style='float: right; height: 22px; cursor: pointer' src='/images/dashboard/assignments.png' onclick='Argus.dental.hedis.manager.assign.list()' title="Assignments"/>
    <img src='/images/dashboard/upload.png' title='Upload Call List' style='float: left; height: 22px; cursor: pointer' onclick='Argus.counseling.uploadForm()' /> Unassigned Contacts
</div>
<div class='mgrhedis_queue_header'>
    <img style='float: right; height: 22px; cursor: pointer' src='/images/dental/snapshot.png' onclick='Argus.dental.hedis.campaign.snapshot()' title="Campaign Snapshot"/>
   
    Queued Contacts
</div>
<div class='mgrhedis_queue_header'>
    <img style='float: left; height: 22px; cursor: pointer' src='/images/dental/return.png' onclick='Argus.dental.hedis.manager.onhold.giveback()' title="Return On-Hold Contacts To Hygienists"/>
    <img style='float: right; height: 22px; cursor: pointer' src='/images/dental/recall.png' onclick='Argus.dental.hedis.manager.onhold.recall()' title="Recall All On-Hold Contacts To Unassigned Queue"/>    
    On-Hold Contacts
</div>
<div class='mgrhedis_queue_header'>
    Returned Contacts
</div>
<div class='mgrhedis_queue_header'>
    Requested Appointment
</div>
<div class='mgrhedis_queue_header'>
    <img style='float: right; height: 22px; cursor: pointer' src='/images/dental/batch_claims.png' onclick='Argus.dental.hedis.manager.claims.run()' title="Batch Completed Claims"/>    
    Completed Counseling
</div>
<br />
<div class='mgrhedis_queue_body' id="unassigned-call-queue">
</div>
<div class='mgrhedis_queue_body' id="manager-queued-call-queue">
</div>
<div class='mgrhedis_queue_body' id="manager-onhold-call-queue">
</div>
<div class='mgrhedis_queue_body' id="manager-returned-call-queue">
</div>
<div class='mgrhedis_queue_body' id="manager-requested-call-queue">
</div>
<div class='mgrhedis_queue_body' id="manager-completed-call-queue">
</div>
<div class='mgrhedis_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='ua-from-row'></span>-<span id='ua-to-row'></span> of <span id='ua-rows'></span>
            <td align='center'>
                <input type='button' name='ua-previous' id='ua-previous' style='' class='mgrhedis_pagination_control' value='<' />
                <input type='button' name='ua-first' id='ua-first' style='' class='mgrhedis_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='ua-last' id='ua-last' style='' class='mgrhedis_pagination_control' value='>>' />
                <input type='button' name='ua-next' id='ua-next' style='' class='mgrhedis_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='ua-page'></span> of <span id='ua-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='mgrhedis_queue_footer' >
    <table width='100%'>
        <tr>
            <td>
                <span id='qd-from-row'></span>-<span id='qd-to-row'></span> of <span id='qd-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='qd-previous' id='qd-previous' style='' class='mgrhedis_pagination_control' value='<' />
                <input type='button' name='qd-first' id='qd-first' style='' class='mgrhedis_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='qd-last' id='qd-last' style='' class='mgrhedis_pagination_control' value='>>' />
                <input type='button' name='qd-next' id='qd-next' style='' class='mgrhedis_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='qd-page'></span> of <span id='qd-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='mgrhedis_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='oh-from-row'></span>-<span id='oh-to-row'></span> of <span id='oh-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='oh-previous' id='oh-previous'  style='' class='mgrhedis_pagination_control' value='<' />
                <input type='button' name='oh-first' id='oh-first' style='' class='mgrhedis_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='oh-last' id='oh-last' style='' class='mgrhedis_pagination_control' value='>>' />
                <input type='button' name='oh-next' id='oh-next' style='' class='mgrhedis_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='oh-page'></span> of <span id='oh-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='mgrhedis_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='rt-from-row'></span>-<span id='rt-to-row'></span> of <span id='rt-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='rt-previous' id='rt-previous'  style='' class='mgrhedis_pagination_control' value='<' />
                <input type='button' name='rt-first' id='rt-first' style='' class='mgrhedis_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='rt-last' id='rt-last' style='' class='mgrhedis_pagination_control' value='>>' />
                <input type='button' name='rt-next' id='rt-next' style='' class='mgrhedis_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='rt-page'></span> of <span id='rt-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='mgrhedis_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='ra-from-row'></span>-<span id='ra-to-row'></span> of <span id='ra-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='ra-previous' id='ra-previous'  style='' class='mgrhedis_pagination_control' value='<' />
                <input type='button' name='ra-first' id='ra-first' style='' class='mgrhedis_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='ra-last' id='ra-last' style='' class='mgrhedis_pagination_control' value='>>' />
                <input type='button' name='ra-next' id='ra-next' style='' class='mgrhedis_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='ra-page'></span> of <span id='ra-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div class='mgrhedis_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='cm-from-row'></span>-<span id='cm-to-row'></span> of <span id='cm-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='cm-previous' id='cm-previous' style='' class='mgrhedis_pagination_control' value='<' />
                <input type='button' name='cm-first' id='cm-first' style='' class='mgrhedis_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='cm-last' id='cm-last' style='' class='mgrhedis_pagination_control' value='>>' />
                <input type='button' name='cm-next' id='cm-next' style='' class='mgrhedis_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
               <span id='cm-page'></span> of <span id='cm-pages'></span>
            </td>
        </tr>
    </table>
</div>
<div style="border: 1px solid ghostwhite; height: 15%; overflow: hidden">
    <div style="text-align: center; border-bottom: 1px solid ghostwhite">
        <b>Virtual Call-Center Monitor</b>
    </div>
    <table style="width: 100%">
        <tr>
    {foreach from=$hygenists->getUsersByRoleName() item=hygenist}
            <td align="center">
                <div style="position: relative; float: left; width: 50px; height: 50px; margin-right: 5px; margin-bottom: 5px; overflow: hidden">
                    {assign var=avatar value='../images/argus/avatars/'|cat:$hygenist.user_id|cat:'.jpg'}
                    {if ($file->exists($avatar))}
                        <img id="hedis-callcenter-employee-{$hygenist.user_id}" src="/images/argus/avatars/{$hygenist.user_id}.jpg" style="height: 100%; opacity: .1" onload="Argus.tools.image.align(this)"/>
                    {else}
                        <img id="hedis-callcenter-employee-{$hygenist.user_id}" src="/images/argus/placeholder-{$hygenist.gender}.png" style="height: 100%; opacity: .1" onload="Argus.tools.image.align(this)"/>
                    {/if}
                    <table style="position: absolute; top: 0px; left: 0px; width: 100%; height: 100%">
                        <tr>
                            <td align="center">{$hygenist.first_name}</td>
                        </tr>
                    </table>
                </div>
            </td>
    {/foreach}
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('ua',function (page,rows) {
       Argus.dental.hedis.manager.refresh($E('unassigned-call-queue'),'ua',page,rows);
    },1,14);
    Pagination.init('qd',function (page,rows) {
       Argus.dental.hedis.manager.refresh($E('manager-queued-call-queue'),'qd',page,rows);
    },1,14);
    Pagination.init('oh',function (page,rows) {
       Argus.dental.hedis.manager.refresh($E('manager-onhold-call-queue'),'oh',page,rows);
    },1,14);
    Pagination.init('rt',function (page,rows) {
       Argus.dental.hedis.manager.refresh($E('manager-returned-call-queue'),'rt',page,rows);
    },1,14);      
    Pagination.init('ra',function (page,rows) {
       Argus.dental.hedis.manager.refresh($E('manager-requested-call-queue'),'ra',page,rows);
    },1,14);    
    Pagination.init('cm',function (page,rows) {
       Argus.dental.hedis.manager.refresh($E('manager-completed-call-queue'),'cm',page,rows);
    },1,14);
</script>