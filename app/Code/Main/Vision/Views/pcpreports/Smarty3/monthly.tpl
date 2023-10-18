<style type="text/css">
    .quarter { display: inline-block; width: 25%; overflow: hidden; white-space: nowrap }
    .fifth   { display: inline-block; width: 20%; overflow: hidden; white-space: nowrap }
    .third   { display: inline-block; width: 33%; overflow: hidden; white-space: nowrap }
    .tenth   { display: inline-block; width: 10%; overflow: hidden; white-space: nowrap }
    .sixth   { display: inline-block; width: 16%; overflow: hidden; white-space: nowrap }
    .eighth  { display: inline-block; width: 12%; overflow: hidden; white-space: nowrap }
</style>
{foreach from=$data item=forms key=month_name}
<div style="background-color: #333; color: ghostwhite; font-weight: bold; padding: 2px">
    <div style='font-size: 1.5em; padding: 4px 0px 4px 0px'>{$month_name}</div>
    <div class="eighth" style="padding-left: 15px">
        Created Date
    </div>
    <div class="tenth">
        Form Status
    </div>    
    <div class="fifth">
        Member Name
    </div>
    <div class="eighth">
        Member ID
    </div>
    <div class="eighth">
        Date Of Birth
    </div>
    <div class="quarter">
        Address
    </div>
</div>
{foreach from=$forms item=form}
    <div {if ($form.status=='C')}onclick="Argus.vision.consultation.open('{$form.id}')"{/if} style="{if ($form.status=='C')}cursor: pointer;{/if}background-color: rgba(202,202,222,{cycle values=".2,.4"}); padding: 2px">
        <div class="eighth"  style="padding-left: 15px">
            {$form.created|date_format:"m/d/Y"}
        </div>
        <div class="tenth">
            {$form.status}
        </div>               
        <div class="fifth">
            {$form.member_name}
        </div>
        <div class="eighth">
            {$form.member_id}
        </div>
        <div class="eighth">
            {$form.date_of_birth|date_format:"m/d/Y"}
        </div>
        <div class="quarter">
            {$form.member_address}
        </div>
    </div>
{/foreach}
{/foreach}
<div style="background-color: #333; color: ghostwhite; font-weight: bold; padding: 2px">&nbsp;</div>

