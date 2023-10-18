{assign var=users value=$users->fetchData()}
{assign var=labels value=$labels->fetch()}
<table style='width: 100%;' cellspacing='1' cellpadding='2'>
    <tr style='background-color: #333; color: ghostwhite; font-size: .8em; '>
        <th style="padding: 5px 0px 5px 0px">Last Name, First Name [User Name]</th>
        {foreach from=$labels item=label}
        <th style="text-align: center; padding: 5px 0px 5px 0px"><img src="{$label.banner_light}" height="30" /></th>
        {/foreach}
    </tr>    
    {foreach from=$users item=user}
        <tr style='background-color: rgba(202,202,202,{cycle values=".2,.4"}); font-size: .9em'>
            <td style="padding: 4px 2px 4px 2px">{$user.last_name}, {if ($user.use_preferred_name == 'Y')}{$user.preferred_name}{else}{$user.first_name}{/if}</td>
            {foreach from=$labels item=label}
                <td align='center'>
                    <input type='radio' name='label_{$user.id}' id='label_{$user.id}_{$label.id}' value='{$label.id}'
                           onclick='Argus.dashboard.whitelabels.update("{$user.id}","{$label.id}")'
                           title="Checking this box will make user {$user.first_name} {$user.last_name} use the {$label.label} appearance." 
                    />
                </td>
            {/foreach}
        </tr>
    {/foreach}
</table>
<script type="text/javascript">
{foreach from=$users item=user}
    {if (isset($user.white_label_id))}
    if ($E('label_{$user.id}_{$user.white_label_id}')) {
        $E('label_{$user.id}_{$user.white_label_id}').checked = true;
    }
    {/if}
{/foreach}
</script>