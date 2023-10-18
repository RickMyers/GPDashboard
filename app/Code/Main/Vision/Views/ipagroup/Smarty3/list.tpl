<style type="text/css">
    .group_member_deassociate {
        height: 15px; cursor: pointer; display: inline-block
    }
</style>
<ul>
{foreach from=$members->list() item=member}
    <li><img src="/images/argus/redx.png" title="Remove IPA From Group" class="group_member_deassociate" group_member_id="{$member.id}" /> {$member.ipa}</li>
{foreachelse}
    No Members Yet In Group
{/foreach}
</ul>
<script type="text/javascript">
    $('.group_member_deassociate').on("click",function (evt) {
        (new EasyAjax('/vision/ipagroup/deassociate')).add('window_id','{$window_id}').add('group_id',$('#current_group_id-{$window_id}').val()).add('id',evt.target.getAttribute('group_member_id')).then(function (response) {
            $('#ipa_group_members-{$window_id}').html(response);
        }).post();
    });
</script>


