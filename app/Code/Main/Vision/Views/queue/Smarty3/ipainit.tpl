<style type='text/css'>
    .ipa_queue_header {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.6%; height: 22px;
        background-color: ghostwhite; color: navy; text-align: center; margin-bottom: 0px; margin-right: .1%
    }
    .ipa_queue_body {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.6%; margin-right: .1%; height: 664px; margin-top: 0px; overflow: auto;
    }
    .ipa_queue_footer {
        display: inline-block; border: 1px solid ghostwhite; margin-left: .1%; width: 99.6%; height: 25px;
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
    .nc_heading {
        cursor: pointer; background-color: #333; color: ghostwhite; text-align: center; display: inline-block; margin: 0px; font-size: .9em
    }    
    .nc_field {
        font-family: sans-serif; color: black; font-size: .8em; padding-left: 15px
    }
    .ipa_pagination_control {
        padding: 2px 5px; font-size: .8em
    }    
</style>
<div class='ipa_queue_body'>
    <div style="white-space: nowrap; overflow: visible">
        <div class="nc_heading"  style="width: 3%">
           &diams;
        </div><div class="nc_heading" style="width: 8%">Type of Event
        </div><div class="nc_heading" style="width: 8%">Event Date
        </div><div class="nc_heading" style="width: 7%">
            <select name="health_plan" id="health_plan"  style='background-color: yellow; color: #333'>
                <option value="">Health Plans</option>
                {foreach from=$pcps->setIpaId({$ipa.id})->ipaHealthPlans() item=hp}
                    <option value="{$hp.client_id}">{$hp.client}</option>
                {/foreach}
            </select>
        </div><div class="nc_heading" style="width: 15%">Member
        </div><div class="nc_heading" style="width: 30%">Office
        </div><div class="nc_heading" style="width: 15%">
            <select name="physician_npi" id="physician_npi" style='background-color: yellow; color: #333'>
                <option value="" style="font-style: italic">Physician</option>
                {foreach from=$pcps->setIpaId({$ipa.id})->ipaPhysicians() item=pcp}
                    <option value="{$pcp.npi}">Dr. {$pcp.name}</option>
                {/foreach}
            </select>
        </div><div class="nc_heading" onclick="Argus.vision.ipa.sortField('technician_name')" style="width: 11%">Technician</div>    
    </div>    
    <div id="ipa_clients_queue"></div>
</div>
<div class='ipa_queue_footer'>
    <table width='100%'>
        <tr>
            <td>
                <span id='ipa_clients-from-row'></span>-<span id='ipa_clients-to-row'></span> of <span id='ipa_clients-rows'></span>
            </td>
            <td align='center'>
                <input type='button' name='ipa_clients-previous' id='ipa_clients-previous'  style='' class='ipa_pagination_control' value='<' />
                <input type='button' name='ipa_clients-first' id='ipa_clients-first' style='' class='ipa_pagination_control' value='<<' />
                &nbsp;&nbsp;
                <input type='button' name='ipa_clients-last' id='ipa_clients-last' style='' class='ipa_pagination_control' value='>>' />
                <input type='button' name='ipa_clients-next' id='ipa_clients-next' style='' class='ipa_pagination_control' value='>' />
            </td>
            <td align='right' style='padding-right: 4px'>
                <span id='ipa_clients-page'></span> of <span id='ipa_clients-pages'></span>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    Pagination.init('ipa_clients',function (page,rows) {
        Argus.vision.ipa.refresh($E('ipa_clients_queue'),'ipa_clients',page,rows);
    },1,50);
    $('#physician_npi').on('change',function (evt) {
        Argus.vision.ipa.refresh($E('ipa_clients_queue'),'ipa_clients',1,50)
    });
    $('#health_plan').on('change',function (evt) {
        Argus.vision.ipa.refresh($E('ipa_clients_queue'),'ipa_clients',1,50)
    });    
</script>

