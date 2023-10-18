{assign var=users value=$user_roles->getUsersByRoleId()}
{assign var=denied value=$denied->fetch()}
{if ($access->getId() != '')}
    {assign var=checked value="checked"}
{else}
    {assign var=checked value=""}
{/if}
<h3>{$project->getProject()} - {$project->getDescription()}</h3>
<table style='width: 80%;' cellspacing='1' cellpadding='2'>
    <tr style='background-color: #333; color: ghostwhite; font-size: .8em'>
        <th>User Name</th>
        <th>Access</th>
        <th>&nbsp;</th>
    </tr>    
    {foreach from=$users item=user}

        <tr style='background-color: rgba(202,202,202,{cycle values=".2,.4"}); font-size: .9em'>
            <td width="30%" style="padding: 4px 2px 4px 2px">{$user.last_name}, {$user.first_name} [{$user.user_name}]</td>
            <td width="10%" align='left'>
                <input type='checkbox' name='denied_user_{$project_id}_{$user.user_id}' id='denied_{$project_id}_{$user.user_id}' value='Y' {$checked}
                       onclick='Argus.configuration.project.deny(this,"{$project_id}","{$role_id}","{$user.user_id}")'
                       title="Unchecking this box will deny the user the ability to run reports in this project." 
                />
            </td>
            <td width="*">&nbsp;</td>
        </tr>
    {/foreach}
</table>
<script type="text/javascript">
    {foreach from=$denied item=user}
        $E('denied_{$project_id}_{$user.user_id}').checked = false;
    {/foreach}
</script>