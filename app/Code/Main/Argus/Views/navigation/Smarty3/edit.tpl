{assign var=data value=$option->load()}
{assign var=nav_id value=$option_active->getOptionId()}
<form name="navigation-edit-form" id="navigation-edit-form-{$data.id}" onsubmit="return false"/>
<div>
    <div class="navigation-cell" style="width: 10%; text-align: center">
        <input type="text" style="width: 100%; color: #333; background-color: lightcyan" value="{$data.image}" name="image" id="navigation_image-{$data.id}" />
    </div>
    <div class="navigation-cell" style="width: 10%">
        <input type="text" style="width: 100%; color: #333; background-color: lightcyan" value="{$data.title}" name="title" id="navigation_title-{$data.id}" />
    </div>        
    <div class="navigation-cell" style="width: 10%">
        <input type="text" style="width: 100%; color: #333; background-color: lightcyan" value="{$data.class}" name="class" id="navigation_class-{$data.id}" />
    </div>
    <div class="navigation-cell" style="width: 15%">
        <input type="text" style="width: 100%; color: #333; background-color: lightcyan" value="{$data.method}" name="method" id="navigation_method-{$data.id}" />
    </div>
    <div class="navigation-cell" style="width: 20%">
        <input type="text" style="width: 100%; color: #333; background-color: lightcyan" value="{$data.style}" name="style" id="navigation_style-{$data.id}" />
    </div>
    <div class="navigation-cell" style="width: 20%">
        <input type="text" style="width: 100%; color: #333; background-color: lightcyan" value="{$data.image_style}" name="image_style" id="navigation_image_style-{$data.id}" />
    </div>
    <div class="navigation-cell" style="width: 5%; text-align: center">
        <input type="button" onclick="Argus.configuration.navigation.update('{$data.id}')" style="color: #333" value="  Update  " />
    </div>    
</div>
<div>
    <div class="" style="display: inline-block; width: 10%;">
        Image
    </div>
    <div class="" style="display: inline-block; width: 10%">
        Title
    </div>        
    <div class="" style="display: inline-block; width: 10%">
        Default Class
    </div>
    <div class="" style="display: inline-block; width: 15%">
        Javascript Method
    </div>
    <div class="" style="display: inline-block; width: 20%">
        Icon Style
    </div>
    <div class="" style="display: inline-block; width: 20%">
        Image Style
    </div>    
</div>
<br /><br />
<div>
    <div class="navigation-cell-header" style="display: inline-block; width: 2%; text-align: center">
        &diam;
    </div>    
    <div class="navigation-cell-header" style="display: inline-block; width: 15%;">
        Namespace
    </div>
    <div class="navigation-cell-header" style="display: inline-block; width: 15%">
        Controller
    </div>        
    <div class="navigation-cell-header" style="display: inline-block; width: 15%">
        Action
    </div>
    <div class="navigation-cell-header" style="display: inline-block; width: 10%">
        Role ID
    </div>
    <div class="navigation-cell-header" style="display: inline-block; width: 20%">
        Role Name
    </div>
</div>
{foreach from=$option_active->options() item=active}
    {assign var=last value=$active}
<div>
    <div class="navigation-cell" style="display: inline-block; width: 2%; text-align: center">
        <a href="#" onclick="Argus.configuration.navigation.unlink('{$data.id}','{$active.id}'); return false"> X </a>
    </div>    
    <div class="navigation-cell" style="display: inline-block; width: 15%;">
        {$active.namespace}
    </div>
    <div class="navigation-cell" style="display: inline-block; width: 15%">
        {$active.controller}
    </div>        
    <div class="navigation-cell" style="display: inline-block; width: 15%">
        {$active.action}
    </div>
    <div class="navigation-cell" style="display: inline-block; width: 10%">
        {$active.role_id}
    </div>
    <div class="navigation-cell" style="display: inline-block; width: 20%">
        {$active.role_name}
    </div>    
</div>
{/foreach}
<form name="navigation-form" id="navigation-{$last.id}-form">
    <input type="hidden" name="id"          value="{$nav_id}" id="option_id-{$last.id}" />
    <input type="hidden" name="namespace"   value="{$last.namespace}" id="option_namespace-{$last.id}" />
    <input type="hidden" name="controller"  value="{$last.controller}" id="option_controller-{$last.id}" />
    <input type="hidden" name="action"      value="{$last.action}" id="option_action-{$last.id}" />
    <div>
        <div class="navigation-cell" style="display: inline-block; width: 2%; text-align: center">
            &nbsp;
        </div>    
        <div class="navigation-cell" style="display: inline-block; width: 15%;">
            {$last.namespace}
        </div>
        <div class="navigation-cell" style="display: inline-block; width: 15%">
            {$last.controller}
        </div>        
        <div class="navigation-cell" style="display: inline-block; width: 15%">
            {$last.action}
        </div>
        <div class="navigation-cell" style="display: inline-block; width: 30%">
            <select name="role_id" id="role_id-{$last.id}">
                <option value=''></option>
                {foreach from=$roles->fetch() item=role}
                <option value="{$role.id}">{$role.name}</option>
                {/foreach}
                &nbsp;<input type="button" name="navigation-role-submit" id="new-navigation-role-submit-{$last.id}" value=" Add Role" />
            </select>
        </div>    
    </div>
</form>
<br /><br />
</form>
<script type="text/javascript">
    var ee = new EasyEdits(null,"navigation-{$last.id}-form");
    ee.fetch("/edits/dashboard/navigation", function (response) {
        this.process(response.replace(/&&id&&/g,'{$last.id}').replace(/&&nav_id&&/,'{$nav_id}'));
    });    
</script>