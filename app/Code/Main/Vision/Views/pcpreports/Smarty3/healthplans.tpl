<style type="text/css">
    .quarter { display: inline-block; width: 25%; overflow: hidden }
    .fifth   { display: inline-block; width: 20%; overflow: hidden }
    .third   { display: inline-block; width: 33%; overflow: hidden }
    .tenth   { display: inline-block; width: 10%; overflow: hidden }
    .sixth   { display: inline-block; width: 16%; overflow: hidden }
    .eighth  { display: inline-block; width: 12%; overflow: hidden }
</style>
{foreach from=$data item=forms key=healthplan}
<div style="background-color: #333; color: ghostwhite; font-weight: bold; padding: 2px">
    <div class="fifth">
        Member Name
    </div>
    <div class="eighth">
        Healthplan
    </div>
    <div class="eighth">
        Member ID
    </div>
    <div class="eighth">
        Form Status
    </div>    
    <div class="eighth">
        Date Of Birth
    </div>
    <div class="quarter">
        Address
    </div>
</div>
{foreach from=$forms item=form}
    <div {if ($form.status=='C')}onclick="Argus.vision.consultation.open('{$form.id}')"{/if} style="{if ($form.status=='C')}cursor: pointer;{/if} background-color: rgba(202,202,222,{cycle values=".2,.4"}); padding: 2px">
        <div class="fifth">
            {$form.member_name}
        </div>
        <div class="eighth">
            {$form.screening_client}
        </div>
        <div class="eighth">
            {$form.member_id}
        </div>
        <div class="tenth">
            {$form.status}
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
