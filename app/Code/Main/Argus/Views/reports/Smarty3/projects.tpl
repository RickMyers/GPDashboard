{assign var=roles value=$roles->fetch()}
{assign var=projects value=$projects->fetch()}
<table style='width: 100%;' cellspacing='1' cellpadding='2'>
    <tr style='background-color: #333; color: ghostwhite; font-size: .8em'>
        <th>Project Name</th>
        {foreach from=$roles item=role}
         <th style="text-align: center">{$role.name|replace:' ':'<br />'}</th>
        {/foreach}
    </tr>    
    {foreach from=$projects item=project}

        <tr style='background-color: rgba(202,202,202,{cycle values=".2,.4"}); font-size: .9em'>
            <td style="padding: 4px 2px 4px 2px" title="{$project.description}">{$project.project}</td>
            {foreach from=$roles item=role}
                <td align='center'>
                    <input type='checkbox' name='role_{$project.id}_{$role.id}' id='role_{$project.id}_{$role.id}' value='Y'
                           onclick='Argus.configuration.report.grant(this,"{$project.id}","{$role.id}")'
                           title="Checking this box will give all users who have the role of {$role.name} access to this report project." 
                    />
                    <a href="#" onclick="Argus.configuration.report.users('{$project.id}','{$role.id}'); return false">more...</a>
                </td>
            {/foreach}
        </tr>
    {/foreach}
</table>
<script type="text/javascript">    
{foreach from=$project_access->fetch() item=role}
    if ($E('role_{$role.project_id}_{$role.role_id}')) {
        $E('role_{$role.project_id}_{$role.role_id}').checked = true;
    }
{/foreach}
</script>