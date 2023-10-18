{assign var=projects value=$projects->fetch()}
<style type='text/css'>
    .librio-document-control {
        background-color: rgba(202,202,202,.2); color: white; width: 75px; height: 75px; margin-right: 5px; display: inline-block; cursor: pointer
    }
    .librio-project-content {
        display: inline-block; background-color: rgba(202,202,202,.2); color: white; width: 200px; cursor: pointer; margin-right: 4px; margin-bottom: 2px; padding:4px
    }
</style>
<div class="librio-document-control" onclick="Argus.librio.project.add()">
    <table style="width: 100%; height: 100%" cellpadding='0' cellpadding='0'>
        <tr>
            <td align='center'>
                New Project
            </td>
        </tr>
    </table>
</div>
<div id="librio-new-category-icon" class="librio-document-control" onclick="Argus.librio.category.add()" style="display: none">
    <table style="width: 100%; height: 100%" cellpadding='0' cellpadding='0'>
        <tr>
            <td align='center'>
                New Category
            </td>
        </tr>
    </table>
</div>
<div id="librio-new-document-icon" class="librio-document-control" onclick="Argus.librio.document.add()" style="display: none">
    <table style="width: 100%; height: 100%" cellpadding='0' cellpadding='0'>
        <tr>
            <td align='center'>
                New Document
            </td>
        </tr>
    </table>
</div>

<br /><br />
Documentation Management
<div style="padding: 0px 0px 0px 10px; margin: 0px">
    <div id="librio-project-navigation" style="color: #333">
    </div>
    {foreach from=$projects item=project}
        <div id="librio-project-{$project.id}-management-tab" onclick="Argus.librio.project.contents('{$project.id}')" class="librio-project-content" title="{$project.description}">
            {$project.project}
        </div>
    {/foreach}
    <div id="librio-content-container">
    </div>
</div>
