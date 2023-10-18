{assign var=ctr value=0}
{assign var=event_id value=$members->getEventId()}
{* This is a duplicate (DRY) of /vision/schedule/listmembers, sometime in the near future, consolidate them *}
<table cellspacing="1" cellpadding="2" style="width: 100%">
    <tr>
        <th>&diam;</th>
        <th>Name</th>
        <th>Member ID</th>
        <th>Address</th>
        <th>Date Of Birth</th>
        <th>HBA1C</th>
        <th>HBA1C Date</th>
        <th>FBS</th>
        <th>FBS Date</th>
    </tr>
{foreach from=$members->eventParticipants() item=member}
    {assign var=ctr value=$ctr+1}
    <tr style="background-color: rgba(155,155,155,{cycle values=".2,.35"})">
        <td><a href="#" onclick='Argus.vision.member.remove("{$member.first_name} {$member.last_name}","{$member.id}","{$event_id}"); return false' style="color: red; text-decoration: none"> X </a>
        <td>{$member.last_name}, {$member.first_name}</td>
        <td>{$member.member_number}</td>
        <td>{if isset($member.address)} {$member.address}, {$member.city}, {$member.state}, {$member.zip_code} {else} {/if}</td>
        <td>{if isset($member.date_of_birth)} {$member.date_of_birth|date_format:"m/d/Y"}{else} {/if} </td>
        <td>{if isset($member.hba1c)} {$member.hba1c} {else} {/if}</td>
        <td>{if isset($member.hba1c_date)} {$member.hba1c_date|date_format:"m/d/Y"} {else} {/if}</td>
        <td>{if isset($member.fbs)} {$member.fbs} {else} {/if}</td>
        <td>{if isset($member.fbs_date)} {$member.fbs_date|date_format:"m/d/Y"} {else}  {/if}</td>
    </tr>    
{/foreach}
</table>     
<script type="text/javascript">
    $('#event_eligible_{$event_id}').val('{$ctr}');
</script>