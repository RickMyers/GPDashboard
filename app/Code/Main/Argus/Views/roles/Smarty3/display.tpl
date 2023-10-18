
{assign var=module_list value=$modules->_orderBy('namespace=ASC')->fetch()->toArray()}
<form name='argus-current-roles' id='argus-current-roles' onsubmit='return false'>
    <fieldset><legend>Current Roles</legend>
        <table cellpadding='2' cellspacing='4' border='0'>
            <tr>
                <th align='center' style='background-color: #333'></th>
                <th align='center' style='background-color: #333'>Role Name</th>
                <th align='center' style='background-color: #333'>Added</th>
                <th align='center' style='background-color: #333'>Default</th>
                <th align='center' style='background-color: #333'>Immutable</th>
                {foreach from=$module_list item=module}
                <th style='text-align: center; padding: 0px 10px; background-color: #333'>{$module.namespace|ucfirst}</th>
                {/foreach}
            </tr>
            
        {foreach from=$roles->fetch() item=role}
            <tr style="background-color: rgba(202,202,202,{cycle values=".2,.5"}">
                <td style='padding: 2px'><input class='redButton' type='button' value='X' style='padding: 2px 4px' onclick='Argus.roles.remove("{$role.id}","{$role.name}")' /></td>
                <td style='padding: 2px 5px; font-weight: bolder'>{$role.name}</td>
                <td align='center' style='padding: 2px 10px'>{$role.modified}</td>
                <td align='center' style='padding: 2px 20px'>{$role.default}</td>
                <td align='center' style='padding: 2px 30px'>{$role.immutable}</td>
                
                {foreach from=$module_list item=module}
                    {assign var=namespace value=$module.namespace}
                    <td  align='center'><input type='checkbox' class='argus_role_authorization'
                                               {if (isset($role['authorizations']))} 
                                                   {assign var=auth value=$role.authorizations}
                                                   value='got it'
                                                   {if isset($auth[$namespace])}
                                                   checked='checked'
                                                   {/if}
                                               {/if} role_name='{$role.name}' namespace='{$module.namespace}' role_id='{$role.id}' />
                    </td>
                {/foreach}
            </tr>
        {/foreach}

            <tr style='border-top: 2px solid ghostwhite'>
                 <td style='padding: 2px'></td>
                 <td style='padding: 2px 5px'><input type='text' name='role_name' id='role_name' style='background-color: lightcyan; padding: 2px; border: 1px solid #aaf' /></td>
                 <td align='center' style='padding: 2px 10px'>N/A</td>
                 <td align='center' style='padding: 2px 20px'><input type='checkbox' name='default' id='default' value='Y'  style='background-color: lightcyan; border: 1px solid #aaf' /></td>
                 <td align='center' style='padding: 2px 0px 2px 30px'>
                     <input type='checkbox' name='immutable' id='immutable' value='Y'  style='background-color: lightcyan; border: 1px solid #aaf' />
                     <input type='button' class='' id="new-role-submit" name="new-role-submit" value='Add' style='padding: 2px 4px; font-size: .9em; color: #333' />
                 </td>
             </tr>
        </table>
    </fieldset>
</form>
<script type="text/javascript">
new EasyEdits('/edits/argus/newrole','new-role-form');
$('.argus_role_authorization').on('click',function (evt) {
    (new EasyAjax('/argus/roles/authorize')).add('role_id',evt.target.getAttribute('role_id')).add('namespace',evt.target.getAttribute('namespace')).add('authorize',evt.target.checked ? 'Y' : 'N').then(function (response) {
        console.log(response);
    }).post();
});
</script>