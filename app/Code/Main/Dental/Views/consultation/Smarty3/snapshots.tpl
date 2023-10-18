<style type='text/css'>
    .snapshot-thumbnail {
        float: left; padding: 5px; border: 1px solid #333; border-radius: 5px; margin-right: 5px;; cursor: pointer
    }
</style>
{foreach from=$snapshots->thumbnails() item=snapshot}
    <div class='snapshot-thumbnail'>
        <img onclick="Argus.dental.consultation.snapshot.analyze('{$snapshot.id}')" src="{$snapshot.thumbnail}" />
    </div>
{foreachelse}
    No snap shots...
{/foreach}    
