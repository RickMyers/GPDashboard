<style type="text/css">
    .recap-field {
        background-color: lightcyan;
    }
    .public-note-recap-field {
        background-color: lightcyan;
    }
    .close-recap {
        color: #333;
    }
</style>
{assign var=closed value=false}
{if (isset($event_details.closed) && ($event_details.closed == 'Y'))}
    {assign var=closed value=true}
{/if}
<div style="background-color: #333; color: ghostwhite; padding: 5px 2px; font-size: 1.05em">
    Event Recap
</div>
<div id="event-member-recap-{$event_id}" style="height: 440px; overflow:auto; padding: 5px 2px; font-weight: bolder"
     ><div style="white-space: nowrap; overflow: hidden"
        ><div style="width: 20%; display: inline-block; text-align: center"> 
            Member
        </div>
        <div style="width: 15%; display: inline-block; text-align: center">
            Outcome
        </div>
        <div style="width: 8%; display: inline-block; text-align: center">
            Add-On
        </div>
        <div style="width: 7%; display: inline-block; text-align: center">
            Generated
        </div>
        <div style="width: 8%; display: inline-block; text-align: center">
           Tech<br />Signed
        </div>
        <div style="width: 7%; display: inline-block; text-align: center">
           O.D.<br />Signed
        </div>
        <div style="width: 8%; display: inline-block; text-align: center">
            Claimed
        </div>
        <div style="width: 20%; display: inline-block; text-align: center">
            Notes
        </div>            
    </div>
    {foreach from=$members->summarizeEvent() item=member}
        <!--form onsubmit="return false"-->        
        <div style='background-color: rgba(202,202,202,{cycle values=".1,.4"}); overflow: hidden; white-space: nowrap; padding: 2px'>
            <div style="display: inline-block; width: 20%">
                <a href="#" onclick="Argus.vision.consultation.open('{$member.tag}'); return false">[{$member.member_id}] {$member.member_name}</a>
            </div>
            <div style="display: inline-block; width: 15%; text-align: center; text-align: center">
                <select event_member_id='{$member.id}' id="event_recap_{$member.id}" class="recap-field" style='width: 100%; padding: 2px' {if ($closed)}disabled="disabled"{/if}>
                    <option value=""></option>
                    <option value="S" {if (isset($member.result) && ($member.result=='S') && (isset($member.screening_technician) && ($member.screening_technician)))}selected="selected"{/if}>Submitted</option>
                    <option value="N" {if (isset($member.result) && ($member.result=='N'))}selected="selected"{/if}>No-Show</option>
                    <option value="C" {if (isset($member.result) && ($member.result=='C'))}selected="selected"{/if}>Canceled</option>
                    <option value="R" {if (isset($member.result) && ($member.result=='R'))}selected="selected"{/if}>Re-Scheduled</option>
                    <option value="U" {if (isset($member.result) && ($member.result=='U'))}selected="selected"{/if}>Unable To Scan</option>
                    <option value="G" {if (isset($member.result) && ($member.result=='G'))}selected="selected"{/if}>Gap Already Closed</option>
                </select>
            </div>
            <div style="display: inline-block; width: 8%; text-align: center">
                <input type="checkbox" class="addon-recap-field" event_member_id='{$member.id}' {if (isset($member.addon) && ($member.addon=='Y'))}checked="checked"{/if} {if ($closed)}disabled="disabled"{/if} />
            </div>
            {if ((isset($member.status) && ($member.status=='S')) && !isset($member.result))}
                <script type="text/javascript">
                    $('#event_recap_{$member.id}').val('{$member.status}').change();
                </script>
            {/if}                
            <div style="display: inline-block; width: 7%; text-align: center">
                {if (isset($member.form_generated) && ($member.form_generated == 'Y'))}
                    <input type="checkbox" disabled='disabled' checked="checked" />
                {else}
                    <input type="checkbox" disabled='disabled' />
                {/if}
            </div>
            <div style="display: inline-block; width: 8%; text-align: center">
                {if (isset($member.pcp_staff_has_signed) && ($member.pcp_staff_has_signed == 'Y'))}
                    <input type="checkbox" disabled='disabled' checked="checked" />
                {else}
                    <input type="checkbox" disabled='disabled' />
                {/if}
            </div>            
            <div style="display: inline-block; width: 7%; text-align: center">
                {if (isset($member.status) && ($member.status == 'C'))}
                    <input type="checkbox" disabled='disabled' checked="checked" />
                {else}
                    <input type="checkbox" disabled='disabled' />
                {/if}
            </div>
            <div style="display: inline-block; width: 8%; text-align: center">
                {if (isset($member.claim_status) && ($member.claim_status == 'Y'))}
                    <input type="checkbox" disabled='disabled' checked="checked" />
                {else}
                    <input type="checkbox" disabled='disabled' />
                {/if}
            </div>
            <div style="display: inline-block; width: 23%">
                <input class="event-member-note" event_member_id="{$member.id}" type="text" value="{if (isset($member.note))}{$member.note}{/if}" style="width: 100%; border: 1px solid #333; background-color: lightcyan; padding: 2px" {if ($closed)}disabled="disabled"{/if} />
            </div>
        </div>
        <!--/form-->
    {/foreach}
</div>
<div id="event_{$event_id}_footer">
 
    <div style="background-color: #333; color: #333; padding: 5px 2px; font-size: 1.05em" id="notes_nav_{$event_id}">

    </div><form onsubmit="return false" style='width: 100%; margin: 0px; padding: 0px'>
                <div id="public_notes_tab_{$event_id}"><textarea {if ($closed)}disabled="disabled"{/if} event_id='{$event_id}' placeholder="Public Notes Shared With Office Location" class="public-note-recap-field" style='margin: 0px 0px -5px 0px; width: 100%; height: 120px'>{$event->getPublicNotes()}</textarea></div>
                <div id="private_notes_tab_{$event_id}"><textarea {if ($closed)}disabled="disabled"{/if} event_id='{$event_id}' placeholder="Private Notes Shared Only With HEDIS Team" class="private-note-recap-field" style='margin: 0px 0px -5px 0px; width: 100%; height: 120px; background-color: #ffcccc'>{$event->getPrivateNotes()}</textarea></div>
        </form><div style="background-color: #333; color: ghostwhite; padding: 5px 2px; font-size: .95em; text-align: center; margin: 0px">
            {* if ($closed)}
                <img src="/images/vision/download_icon" onclick="Argus.vision.download()" style="float: right; margin-right: 5px; cursor: pointer" />
                <div style="display: inline-block; margin-left: auto; margin-right: auto; color: ghostwhite">This Event Has Been Closed</div>
            {else}
                <button event_id='{$event_id}' class="close-recap"> Close Event </button>
            {/if *}            
            <button event_id='{$event_id}' class="close-recap"> Close Event </button>
    </div>  
</div>        
<script type="text/javascript">
    (function () {
        var tabs = new EasyTab('notes_nav_{$event_id}',120);
        tabs.add('Public Notes',false,'public_notes_tab_{$event_id}');
        tabs.add('Private Notes',false,'private_notes_tab_{$event_id}');
        tabs.tabClick(0);
    })();
    $('.close-recap').on('click',function (evt) {
        if (confirm('Complete and close the event?')) {
            (new EasyAjax('/vision/event/close')).add('event_id',this.getAttribute('event_id')).then(function (response) {
                var win = Desktop.whoami('event-member-recap-{$event_id}');
                Desktop.window.list[win]._close();
            }).post();        
        }
    });
    $('.recap-field').on('change',function (evt) {
        (new EasyAjax('/vision/event/save')).add('event_member_id',this.getAttribute('event_member_id')).add('result',this.value).then(function (response) {
        }).post();
    });
    $('.addon-recap-field').on('click',function (evt) {
        (new EasyAjax('/vision/event/save')).add('event_member_id',this.getAttribute('event_member_id')).add('addon',(this.checked ? 'Y' : 'N')).then(function (response) {
        }).post();
    });
    $('.public-note-recap-field').on('change',function (evt) {
        (new EasyAjax('/vision/event/note')).add('event_id',this.getAttribute('event_id')).add('public_notes',this.value).then(function (response) {
            console.log(response);
        }).post();        
    });    
    $('.private-note-recap-field').on('change',function (evt) {
        (new EasyAjax('/vision/event/note')).add('event_id',this.getAttribute('event_id')).add('private_notes',this.value).then(function (response) {
            console.log(response);
        }).post();        
    });        
    $('.event-member-note').on('change',function (evt) {
        (new EasyAjax('/vision/event/save')).add('event_member_id',this.getAttribute('event_member_id')).add('note',this.value).then(function (response) {
        }).post();
    });
    
</script>
