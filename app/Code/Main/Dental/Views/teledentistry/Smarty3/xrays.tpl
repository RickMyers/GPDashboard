<style type='text/css'>
    .xray-thumbnail {
        float: left; padding: 5px; border: 1px solid #333; border-radius: 5px; margin-right: 5px;; cursor: pointer
    }
</style>
{foreach from=$xrays->thumbnails() item=xray}
    <div class='xray-thumbnail'>
        <img onclick="Argus.dental.consultation.xray.analyze('{$xray.id}')" src="{$xray.thumbnail}" />
    </div>
{foreachelse}
    No X-Rays Found....
{/foreach}    

