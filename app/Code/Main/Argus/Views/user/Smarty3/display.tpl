{assign var=roles value=$roles->fetch()}
<div>
    <div style="float: right">
                                                                                    <style type="text/css">
        .user-search-box {
            border-radius: 8px; height: 25px; width: 270px; border: 1px solid #333; padding-left: 30px; background-color: ghostwhite; background-image: url(/images/dental/search.png); background-repeat: no-repeat
        }
        .user-search-field {
            border: 0px; color: #333; background-color: ghostwhite; width: 230px; height: 20px; position: relative; top: 2px
        }
        .user-search-field:focus {
            outline: none;
        }
    </style>
    <div class="user-search-box" style="display: inline-block">
        <input class="user-search-field" type="text" style="" name="user-search-field" id="user-search-field" placeholder="Search..." value="{$users->getStartsWith()}">
    </div>
    <script type="text/javascript">
        $('#user-search-field').on("keydown",function (evt) {
            if (evt.keyCode == 13) {
                Argus.users.display(evt.target.value);
            }        
        });
    </script>
</div>
<a href='#' onclick="Argus.users.display('A')">A</a>&nbsp;
<a href='#' onclick="Argus.users.display('B')">B</a>&nbsp;
<a href='#' onclick="Argus.users.display('C')">C</a>&nbsp;
<a href='#' onclick="Argus.users.display('D')">D</a>&nbsp;
<a href='#' onclick="Argus.users.display('E')">E</a>&nbsp;
<a href='#' onclick="Argus.users.display('F')">F</a>&nbsp;
<a href='#' onclick="Argus.users.display('G')">G</a>&nbsp;
<a href='#' onclick="Argus.users.display('H')">H</a>&nbsp;
<a href='#' onclick="Argus.users.display('I')">I</a>&nbsp;
<a href='#' onclick="Argus.users.display('J')">J</a>&nbsp;
<a href='#' onclick="Argus.users.display('K')">K</a>&nbsp;
<a href='#' onclick="Argus.users.display('L')">L</a>&nbsp;
<a href='#' onclick="Argus.users.display('M')">M</a>&nbsp;
<a href='#' onclick="Argus.users.display('N')">N</a>&nbsp;
<a href='#' onclick="Argus.users.display('O')">O</a>&nbsp;
<a href='#' onclick="Argus.users.display('P')">P</a>&nbsp;
<a href='#' onclick="Argus.users.display('Q')">Q</a>&nbsp;
<a href='#' onclick="Argus.users.display('R')">R</a>&nbsp;
<a href='#' onclick="Argus.users.display('S')">S</a>&nbsp;
<a href='#' onclick="Argus.users.display('T')">T</a>&nbsp;
<a href='#' onclick="Argus.users.display('U')">U</a>&nbsp;
<a href='#' onclick="Argus.users.display('V')">V</a>&nbsp;
<a href='#' onclick="Argus.users.display('W')">W</a>&nbsp;
<a href='#' onclick="Argus.users.display('X')">X</a>&nbsp;
<a href='#' onclick="Argus.users.display('Y')">Y</a>&nbsp;
<a href='#' onclick="Argus.users.display('Z')">Z</a>&nbsp;
<select name="user_role" id="user_role" style="color: #333; display: inling-block; padding: 2px; background-color: lightcyan; border: 1px solid #aaf; border-radius: 4px; margin-left: 5px">
    <option value=""  selected='true'>Role (optional)</option>
    {foreach from=$roles item=role}
        <option value="{$role.id}">{$role.name}</option>
    {/foreach}
</select>
</div>

<table style='width: 100%;' cellspacing='1' cellpadding='2'>
    <tr style='background-color: #333; color: ghostwhite; font-size: .8em'>
        <th>Last Name, First Name [User Name]</th>
        {foreach from=$roles item=role}
         <th style="text-align: center">{$role.name|replace:' ':'<br />'}</th>
        {/foreach}
    </tr>    
    {foreach from=$users->fetchData() item=user}

        <tr style='background-color: rgba(202,202,202,{cycle values=".2,.4"}); font-size: .9em'>
            <td style="padding: 4px 2px 4px 2px">
                <a href="#" title="ID: [{$user.id}] {$user.user_name}" onclick="Argus.users.view('{$user.id}'); return false" style="color: {if ($user.account_status == 'L')} red; {else} white; {/if} ">
                    {if (trim($user.entity_name))}{$user.entity_name}{else}{$user.last_name}, {if ($user.use_preferred_name == 'Y')}{$user.preferred_name}{else}{$user.first_name}{/if}{/if}
                </a>
            </td>
            {foreach from=$roles item=role}
                <td align='center'>
                    <input type='checkbox' name='role_{$user.id}_{$role.id}' id='role_{$user.id}_{$role.id}' value='Y'
                           onclick='Argus.user.role(this,"{$user.id}","{$role.id}");'
                           title="Checking this box will make {$user.first_name} {$user.last_name} a {$role.name}." 
                           {if (($role.immutable == 'Y') || ($role.default == 'Y'))} disabled='true' {/if}
                    />
                </td>
            {/foreach}
        </tr>
    {/foreach}
</table>
<script type="text/javascript">    
{foreach from=$user_roles->fetch() item=role}
    if ($E('role_{$role.user_id}_{$role.role_id}')) {
        $E('role_{$role.user_id}_{$role.role_id}').checked = true;
    }
{/foreach}
$('#user_role').on('change',function () {
    Argus.users.display(Argus.users.starts_with);
});
{if ($users->getRoleId())}
    $('#user_role').val('{$users->getRoleId()}');
{/if}
</script>